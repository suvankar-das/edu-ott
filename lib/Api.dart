import 'dart:convert';
import 'dart:io';
import 'package:edu_ott_indimuse/AppData.dart';
import 'package:edu_ott_indimuse/Environment.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

late final PersistCookieJar cookieJar;

Future<void> initCookieJar() async {
  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies/';

    // Create the cookies directory if it doesn't exist
    final cookieDir = Directory(cookiePath);
    if (!await cookieDir.exists()) {
      await cookieDir.create(recursive: true);
    }

    // Initialize the cookie jar with the created directory
    cookieJar = PersistCookieJar(
        // ignoreExpires:
        //     true, // Optional: add this if you want cookies to persist regardless of expiry
        storage: FileStorage(cookiePath));

    print('Cookie jar initialized successfully at: $cookiePath');
  } catch (e, stackTrace) {
    print('Failed to initialize cookie jar: $e');
    print('Stack trace: $stackTrace');
    throw Exception('Cookie jar initialization failed: $e');
  }
}

class Api {
  Future<http.Response> verifyOtp(
      Map<String, dynamic> otpData, String actionType) async {
    final String apiUrl = actionType == 'login'
        ? '/user/login/phone/verifyotp'
        : '/user/signup/phone/verifyotp';

    var contentUrl = Uri.parse('${EnvironmentVars.kanchaLankaUrl}$apiUrl');
    try {
      List<Cookie> cookies = await cookieJar.loadForRequest(contentUrl);
      String cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      String? encodedDeviceProfile = AppData().encodedDeviceProfile;
      String? encodedUserLocationData = AppData().encodedUserLocationData;

      var userLocationBox = null;
      //await Hive.openBox<UserLocationDataModel>('userLocationBox');
      var userLocationTv = userLocationBox.get('userlocation');

      if (userLocationTv != null) {
        encodedUserLocationData = json.encode(userLocationTv);
      }

      final response = await http.post(
        contentUrl,
        headers: {
          'Cookie': cookieHeader,
          'x-user-location-data': encodedUserLocationData!,
          'x-device-profile': encodedDeviceProfile!,
          'Content-Type': 'application/json'
        },
        body: jsonEncode(otpData),
      );

      if (response.statusCode == 403) {
        return response;
      }

      if (response.headers.containsKey('set-cookie')) {
        List<String> responseCookies =
            response.headers['set-cookie']!.split(',');

        // Save cookies using PersistCookieJar
        cookieJar.saveFromResponse(
          contentUrl,
          responseCookies
              .map((cookie) => Cookie.fromSetCookieValue(cookie))
              .toList(),
        );
        print("cookies===> ${responseCookies}");
      }

      return response;
    } catch (e) {
      print("Error in API call: $e");
      rethrow;
    }
  }
}
