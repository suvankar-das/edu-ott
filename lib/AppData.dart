import 'dart:convert';

import 'package:edu_ott_indimuse/Utility.dart';

class AppData {
  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();

  String? encodedDeviceProfile;
  String? encodedUserLocationData;

  Future<void> initialize() async {
    Map<String, String> deviceInfo = await getDeviceIdNameType();
    Map<String, String> userLocationData = await getLocation();
    encodedDeviceProfile = json.encode(deviceInfo);
    encodedUserLocationData = json.encode(userLocationData);
  }
}
