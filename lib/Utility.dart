import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:edu_ott_indimuse/Api.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

Future<String?> getId() async {
  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    var iosDeviceInfo = await FlutterUdid.consistentUdid;
    ;
    return iosDeviceInfo;
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id;
  }
  return null;
}

Future<void> addRegionCookie(String url, String selectedRegion) async {
  try {
    List<Cookie> existingCookies =
        await cookieJar.loadForRequest(Uri.parse(url));

    if (selectedRegion.isNotEmpty) {
      bool regionExists =
          existingCookies.any((cookie) => cookie.name == 'current_region');

      if (!regionExists) {
        existingCookies.add(Cookie('current_region', 'global'));
      } else {
        // Replace the existing 'current_region' cookie
        existingCookies
            .removeWhere((cookie) => cookie.name == 'current_region');
        existingCookies.add(Cookie('current_region', selectedRegion));
      }
      cookieJar.saveFromResponse(Uri.parse(url), existingCookies);
    }
  } catch (e) {
    print('Error in addRegionCookie: $e');
  }
}

Future<Map<String, String>> getDeviceIdNameType() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    var deviceDetails = {
      "device_name": "iOS",
      "device_type": "ios",
      "device_id": await FlutterUdid.consistentUdid
    };
    // Check if the device is an Apple TV
    if (iosInfo.model.contains("AppleTV")) {
      deviceDetails = {
        "device_name": "Apple TV",
        "device_type": "apple_tv",
        "device_id": await FlutterUdid.consistentUdid
      };
    }
    // Check if the device is a Mac
    if (iosInfo.model.contains("Mac")) {
      deviceDetails = {
        "device_name": "Mac",
        "device_type": "mac",
        "device_id": await FlutterUdid.consistentUdid
      };
    }
    return deviceDetails;
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var deviceDetails = {
      "device_name": "Android",
      "device_type": "android",
      "device_id": androidInfo.id ?? "unknown"
    };
    // Check if the device is an Android TV
    if (androidInfo.systemFeatures.contains('android.software.leanback')) {
      deviceDetails = {
        "device_name": "Android TV",
        "device_type": "android_tv",
        "device_id": androidInfo.id ?? "unknown"
      };
    }

    return deviceDetails;
  }
  return {"device_name": "", "device_type": "", "device_id": ""};
}

Future<Map<String, String>> getLocation() async {
  if (Platform.isIOS) {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location service is not enabled, fetch fallback country and ISD code
      var data = await fetchCountryAndISDCode();
      return {
        'country': data["country"]!,
        'city': data["city"]!,
        'country_code': data["country_code"]!,
        'isd_code': data["isd_code"]!
      };
    }

    // If location service is enabled, check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If permission is denied, request it
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // If denied or denied forever, fetch country and ISD code
        var data = await fetchCountryAndISDCode();
        return {
          'country': data["country"]!,
          'city': data["city"]!,
          'country_code': data["country_code"]!,
          'isd_code': data["isd_code"]!
        };
      }
    }

    // Handle case where permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      var data = await fetchCountryAndISDCode();
      return {
        'country': data["country"]!,
        'city': data["city"]!,
        'country_code': data["country_code"]!,
        'isd_code': data["isd_code"]!
      };
    }

    // If permission is granted (either while in use or always) and location service is enabled
    if (serviceEnabled &&
        (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always)) {
      try {
        // Attempt to fetch the current position

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 5));

        Map<String, String> locationData =
            await _getAddressFromLatLng(position.latitude, position.longitude);
        return locationData;
      } catch (e) {
        // Handle any exceptions or null responses when trying to fetch the position

        var data = await fetchCountryAndISDCode();
        return {
          'country': data["country"]!,
          'city': data["city"]!,
          'country_code': data["country_code"]!,
          'isd_code': data["isd_code"]!
        };
      }
    } else {
      // If permission is not granted, fallback to fetch country and ISD code
      var data = await fetchCountryAndISDCode();
      return {
        'country': data["country"]!,
        'city': data["city"]!,
        'country_code': data["country_code"]!,
        'isd_code': data["isd_code"]!
      };
    }
  } else {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.systemFeatures.contains('android.software.leanback')) {
      var data = await fetchCountryAndISDCode();
      return {
        'country': data["country"]!,
        'city': data["city"]!,
        'country_code': data["country_code"]!,
        'isd_code': data["isd_code"]!,
        'message': 'Connected with android Tv device'
      };
    } else {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        var data = await fetchCountryAndISDCode();
        return {
          'country': data["country"]!,
          'city': data["city"]!,
          'country_code': data["country_code"]!,
          'isd_code': data["isd_code"]!
        };
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        var data = await fetchCountryAndISDCode();
        if (permission == LocationPermission.denied) {
          // return Future.error('Location permissions are denied');
          return {
            'country': data["country"]!,
            'city': data["city"]!,
            'country_code': data["country_code"]!,
            'isd_code': data["isd_code"]!
          };
        }
      }

      if (permission == LocationPermission.deniedForever) {
        var data = await fetchCountryAndISDCode();
        return {
          'country': data["country"]!,
          'city': data["city"]!,
          'country_code': data["country_code"]!,
          'isd_code': data["isd_code"]!
        };
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      Map<String, String> locationData =
          await _getAddressFromLatLng(position.latitude, position.longitude);
      return locationData;
    }
  }
}

Future<Map<String, String>> _getAddressFromLatLng(
    double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks[0];

    String country = place.country ?? '';
    String countryCode = place.isoCountryCode ?? '';
    String city = place.locality ?? '';

    // Get ISD code using the country code
    var countryData = await _getCountryISDCode(countryCode);

    // Return the collected data
    return {
      'country': country,
      'city': city,
      'country_code': countryCode.toLowerCase(),
      'isd_code': countryData['isd_code']
    };
  } catch (e) {
    print(e);
    return Future.error('Failed to get address from coordinates');
  }
}

// Future<String> _getCountryISDCode(String countryCode) async {
//   final response = await http
//       .get(Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode'));

//   if (response.statusCode == 200) {
//     var data = json.decode(response.body);
//     var countryData = data[0];

//     return '${countryData['idd']['root']}${countryData['idd']['suffixes'][0]}';
//   } else {
//     return '+91';
//   }
// }

Future<Map<String, dynamic>> _getCountryISDCode(String countryCode) async {
  try {
    final String jsonString =
        await rootBundle.loadString('assets/data/country_isd_codes.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, dynamic>? countryData =
        jsonMap[countryCode.toUpperCase()];

    if (countryData != null) {
      return countryData;
    } else {
      return {"country_name": "india", "isd_code": "+91"};
    }
  } catch (e) {
    return {"country_name": "Error", "isd_code": "Error"};
  }
}

bool isCloseToMultipleOf15(double oldValue, double newValue) {
  if (newValue > 15) {
    double modulus = newValue % 15;
    if ((modulus >= 12 || modulus <= 3) && (newValue - oldValue).abs() > 5) {
      return true;
    }
  }
  return false;
}

// Function to get ISD code based on the IP address and return necessary info
Future<Map<String, String>> fetchCountryAndISDCode() async {
  // First, fetch the public IP address
  final ipAddress = await fetchIpAddress();

  if (ipAddress == 'Error') {
    print('Could not fetch IP address.');
    return {'country': '', 'city': '', 'country_code': '', 'isd_code': ''};
  }

  final ipInfoUrl = 'https://ipinfo.io/$ipAddress?token=9f7bbcd477316a';

  try {
    // Step 1: Get country code and city from IP address
    final ipInfoResponse = await http.get(Uri.parse(ipInfoUrl));

    if (ipInfoResponse.statusCode == 200) {
      final data = json.decode(ipInfoResponse.body);

      // Extract country code and city (e.g., "IN" for India)
      final countryCode = data['country'];
      final city = sanitizeString(data["city"]);

      print('Country Code: $countryCode');
      print('City: $city');

      // Step 2: Fetch both country name and ISD code using the country code
      // final countryInfo = await fetchCountryInfo(countryCode);
      final countryInfo = await _getCountryISDCode(countryCode);

      return {
        'country': countryInfo['country_name']!,
        'city': city,
        'country_code': countryCode,
        'isd_code': countryInfo['isd_code'],
      };
    } else {
      print('Failed to get IP information: ${ipInfoResponse.statusCode}');
      return {'country': '', 'city': '', 'country_code': '', 'isd_code': ''};
    }
  } catch (error) {
    print('Error: $error');
    return {'country': '', 'city': '', 'country_code': '', 'isd_code': ''};
  }
}

String sanitizeString(String input) {
  const Map<String, String> charMap = {
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'ã': 'a',
    'å': 'a',
    'ā': 'a',
    'ă': 'a',
    'ą': 'a',
    'Á': 'A',
    'À': 'A',
    'Ä': 'A',
    'Â': 'A',
    'Ã': 'A',
    'Å': 'A',
    'Ā': 'A',
    'Ă': 'A',
    'Ą': 'A',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'ē': 'e',
    'ė': 'e',
    'ę': 'e',
    'ě': 'e',
    'É': 'E',
    'È': 'E',
    'Ë': 'E',
    'Ê': 'E',
    'Ē': 'E',
    'Ė': 'E',
    'Ę': 'E',
    'Ě': 'E',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ī': 'i',
    'į': 'i',
    'ı': 'i',
    'Í': 'I',
    'Ì': 'I',
    'Ï': 'I',
    'Î': 'I',
    'Ī': 'I',
    'Į': 'I',
    'I': 'I',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'õ': 'o',
    'ő': 'o',
    'ō': 'o',
    'Ó': 'O',
    'Ò': 'O',
    'Ö': 'O',
    'Ô': 'O',
    'Õ': 'O',
    'Ő': 'O',
    'Ō': 'O',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
    'ű': 'u',
    'ū': 'u',
    'ų': 'u',
    'Ú': 'U',
    'Ù': 'U',
    'Ü': 'U',
    'Û': 'U',
    'Ű': 'U',
    'Ū': 'U',
    'Ų': 'U',
    'ç': 'c',
    'ć': 'c',
    'č': 'c',
    'ĉ': 'c',
    'ċ': 'c',
    'Ç': 'C',
    'Ć': 'C',
    'Č': 'C',
    'Ĉ': 'C',
    'Ċ': 'C',
    'ñ': 'n',
    'ń': 'n',
    'ň': 'n',
    'ņ': 'n',
    'ŋ': 'n',
    'Ñ': 'N',
    'Ń': 'N',
    'Ň': 'N',
    'Ņ': 'N',
    'Ŋ': 'N',
    'š': 's',
    'ś': 's',
    'ş': 's',
    'ŝ': 's',
    'Š': 'S',
    'Ś': 'S',
    'Ş': 'S',
    'Ŝ': 'S',
    'ž': 'z',
    'ź': 'z',
    'ż': 'z',
    'ẑ': 'z',
    'Ž': 'Z',
    'Ź': 'Z',
    'Ż': 'Z',
    'Ẑ': 'Z',
    'ý': 'y',
    'ÿ': 'y',
    'ŷ': 'y',
    'Ý': 'Y',
    'Ÿ': 'Y',
    'Ŷ': 'Y',
    'ř': 'r',
    'ŕ': 'r',
    'ŗ': 'r',
    'Ř': 'R',
    'Ŕ': 'R',
    'Ŗ': 'R',
    'ł': 'l',
    'ĺ': 'l',
    'ļ': 'l',
    'ľ': 'l',
    'Ł': 'L',
    'Ĺ': 'L',
    'Ļ': 'L',
    'Ľ': 'L',
    'đ': 'd',
    'ð': 'd',
    'ď': 'd',
    'Đ': 'D',
    'Ð': 'D',
    'Ď': 'D',
    'ť': 't',
    'ţ': 't',
    'ŧ': 't',
    'ț': 't',
    'Ť': 'T',
    'Ţ': 'T',
    'Ŧ': 'T',
    'Ț': 'T',
    'ĝ': 'g',
    'ğ': 'g',
    'ġ': 'g',
    'ģ': 'g',
    'Ĝ': 'G',
    'Ğ': 'G',
    'Ġ': 'G',
    'Ģ': 'G',
    'ŵ': 'w',
    'Ŵ': 'W',
    'þ': 'p',
    'Þ': 'P',
    'æ': 'ae',
    'Æ': 'AE',
    'œ': 'oe',
    'Œ': 'OE',
    'ß': 'ss'
  };

  // Replace each special character with its mapped equivalent
  charMap.forEach((key, value) {
    input = input.replaceAll(key, value);
  });

  return input;
}

// Function to fetch the public IP address
Future<String> fetchIpAddress() async {
  const ipApiUrl = 'https://api.ipify.org?format=json';

  try {
    final response = await http.get(Uri.parse(ipApiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ip'];
    } else {
      print('Failed to get IP address: ${response.statusCode}');
      return 'Error';
    }
  } catch (error) {
    print('Error fetching IP address: $error');
    return 'Error';
  }
}

// Function to fetch both ISD code and country name using country code
Future<Map<String, String>> fetchCountryInfo(String countryCode) async {
  final url = 'https://restcountries.com/v2/alpha/$countryCode';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Extract the country name and ISD code
      final countryName = data['name'];
      final callingCodes = data['callingCodes'];
      final isdCode =
          callingCodes.isNotEmpty ? callingCodes[0] : 'Unknown ISD Code';

      return {'name': countryName ?? 'Unknown Country', 'isd_code': isdCode};
    } else {
      print('Failed to fetch country info: ${response.statusCode}');
      return {'name': 'Error', 'isd_code': 'Error'};
    }
  } catch (error) {
    print('Error fetching country info: $error');
    return {'name': 'Error', 'isd_code': 'Error'};
  }
}
