import 'package:edu_ott_indimuse/LocalData/hive_models.dart';
import 'package:edu_ott_indimuse/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  Hive.registerAdapter(SettingsModelAdapter());
  Hive.registerAdapter(PageSettingAdapter());
  Hive.registerAdapter(PageSettingDetailsAdapter());
  Hive.registerAdapter(PageComponentAdapter());
  Hive.registerAdapter(ContentSelectionCriteriaAdapter());
  Hive.registerAdapter(PageElementAdapter());
  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(MovieImagesAdapter());
  Hive.registerAdapter(SettingsWithMoviesAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indimuse Edu',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.grey,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
