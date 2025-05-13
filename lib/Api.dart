import 'dart:convert';
import 'dart:io';
import 'package:edu_ott_indimuse/AppData.dart';
import 'package:edu_ott_indimuse/Environment.dart';
import 'package:edu_ott_indimuse/LocalData/hive_models.dart';
import 'package:hive/hive.dart';
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

    var contentUrl = Uri.parse('${EnvironmentVars.kanchaLankaUrl1}$apiUrl');
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

  // Future<Map<String, dynamic>> fetchSettingsAndMovies() async {
  //   Set<String> uniqueContentIds = {};
  //   Map<String, dynamic> responseData = {};

  //   try {
  //     // Prepare URLs
  //     const homeTemplateUrl =
  //         '${EnvironmentVars.kanchaLankaUrl1}/admin/template/home';
  //     String fullUrl = '${EnvironmentVars.kanchaLankaUrl1}/education/course';
  //     var contentUrl = Uri.parse(fullUrl);

  //     final settingsResponse = await http.get(
  //       Uri.parse(homeTemplateUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     final settingsJson = jsonDecode(settingsResponse.body);

  //     if (settingsJson['error_code'] == 0) {
  //       final settingsData = settingsJson['result'];

  //       // Collect unique content IDs from settings
  //       for (var settingData in settingsData['page_settings']) {
  //         if (settingData['type'] == 'tray' ||
  //             settingData['type'] == 'poster_carousel' ||
  //             settingData['type'] == 'poster') {
  //           final List<String> contentIds =
  //               List<String>.from(settingData['content'] ?? []);
  //           uniqueContentIds.addAll(contentIds);
  //         }
  //       }

  //       // Fetch movies data based on content IDs
  //       final moviesResponse = await http.post(
  //         contentUrl,
  //         body: jsonEncode({'content': uniqueContentIds.toList()}),
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //       );

  //       final moviesJson = jsonDecode(moviesResponse.body);

  //       if (moviesJson['error_code'] == 0) {
  //         responseData['settings'] = settingsData;
  //         responseData['movies'] = moviesJson['result'];
  //       } else {
  //         throw Exception("Failed to fetch movies: ${moviesJson['message']}");
  //       }
  //     } else {
  //       throw Exception("Failed to fetch settings: ${settingsJson['message']}");
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }

  //   return responseData;
  // }

  Future<SettingsWithMovies> fetchSettingsAndMovies() async {
    Set<String> uniqueContentIds = {};
    var settingsBox = await Hive.openBox<SettingsModel>('settingsBox');
    var moviesBox = await Hive.openBox<MovieModel>('moviesBox');

    try {
      const homeTemplateUrl =
          '${EnvironmentVars.kanchaLankaUrl1}/admin/template/home';
      String fullUrl = '${EnvironmentVars.kanchaLankaUrl1}/education/course';
      var contentUrl = Uri.parse(fullUrl);

      final settingsResponse = await http.get(
        Uri.parse(homeTemplateUrl),
        headers: {'Content-Type': 'application/json'},
      );

      final settingsJson = jsonDecode(settingsResponse.body);

      if (settingsJson['error_code'] != 0) {
        throw Exception("Failed to fetch settings: ${settingsJson['message']}");
      }

      final settingsData = settingsJson['result'];

      final settingsModel = SettingsModel(
        id: settingsData['_id'] ?? '',
        pageId: settingsData['page_id'] ?? '',
        region: settingsData['region'] ?? '',
        isActive: settingsData['is_active'] ?? false,
        isDelete: settingsData['is_delete'] ?? false,
        pageSettings:
            (settingsData['page_settings'] as List? ?? []).map((setting) {
          final settings = setting['settings'] ?? {};
          final component = settings['component'] ?? {};
          final element = settings['element'] ?? {};
          final contentSelection = settings['content_selection_criteria'] ?? {};

          return PageSetting(
            id: setting['id'] ?? '',
            type: setting['type'] ?? '',
            settings: PageSettingDetails(
              id: settings['_id']?.toString() ?? '',
              component: PageComponent(
                compType: component['comp_type']?.toString() ?? '',
                arrangement: component['arrangement']?.toString() ?? '',
                limit: _parseInt(component['limit']),
              ),
              content: _parseContent(settings['content']),
              contentSelectionCriteria: ContentSelectionCriteria(
                category: List<String>.from(contentSelection['category'] ?? []),
                tag: List<String>.from(contentSelection['tag'] ?? []),
              ),
              element: PageElement(
                orientation: element['orientation']?.toString() ?? '',
                size: element['size']?.toString() ?? '',
                isHover: element['is_hover'] ?? false,
                isFooterTitle: element['is_footer_title'] ?? false,
              ),
              hideAfterLogin: settings['hide_after_login'] ?? false,
              isActive: settings['is_active'] ?? false,
              isDelete: settings['is_delete'] ?? false,
              pageId: settings['page_id']?.toString() ?? '',
              title: settings['title']?.toString() ?? '',
            ),
          );
        }).toList(),
        pageTypeId: settingsData['page_type_id']?.toString() ?? '',
      );

      // Store settings to Hive
      await settingsBox.put('settings', settingsModel);

      for (var setting in settingsModel.pageSettings) {
        if (setting.type == 'tray' ||
            setting.type == 'poster_carousel' ||
            setting.type == 'poster') {
          uniqueContentIds.addAll(setting.settings.content.values);
        }
      }

      final moviesResponse = await http.post(
        contentUrl,
        body: jsonEncode({'content': uniqueContentIds.toList()}),
        headers: {'Content-Type': 'application/json'},
      );

      final moviesJson = jsonDecode(moviesResponse.body);

      if (moviesJson['error_code'] != 0) {
        throw Exception("Failed to fetch movies: ${moviesJson['message']}");
      }

      final moviesMap = <String, MovieModel>{};
      for (var movie in moviesJson['result'] ?? []) {
        final images = movie['images'];
        final movieModel = MovieModel(
          id: movie['_id']?.toString() ?? '',
          title: movie['title']?.toString() ?? '',
          type: movie['type']?.toString() ?? '',
          permalink: movie['permalink']?.toString() ?? '',
          tags: List<String>.from(movie['tags'] ?? []),
          images: images != null
              ? MovieImages(
                  img32_9: images['img_32_9']?.toString(),
                  img16_9: images['img_16_9']?.toString(),
                  img9_16: images['img_9_16']?.toString(),
                  img1_1: images['img_1_1']?.toString(),
                  img3_4: images['img_3_4']?.toString(),
                  img4_3: images['img_4_3']?.toString(),
                )
              : null,
          author: movie['author']?.toString(),
          isFirstEpisodeFree: movie['is_first_episode_free'] ?? false,
        );
        moviesMap[movieModel.id] = movieModel;

        // Store each movie in Hive
        await moviesBox.put(movieModel.id, movieModel);
      }

      var settingsWithMoviesBox =
          await Hive.openBox<SettingsWithMovies>('settingsWithMoviesBox');
      await settingsWithMoviesBox.put(
          'data',
          SettingsWithMovies(
            settings: settingsModel,
            movies: moviesMap,
          ));

      return SettingsWithMovies(
        settings: settingsModel,
        movies: moviesMap,
      );
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

// Helper function to safely parse integers
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

// Helper function to parse content which might be a Map or List
  Map<String, String> _parseContent(dynamic content) {
    if (content == null) return {};
    if (content is Map) {
      return content.map((key, value) => MapEntry(
            key.toString(),
            value.toString(),
          ));
    }
    return {};
  }
}
