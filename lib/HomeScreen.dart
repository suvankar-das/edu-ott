import 'package:edu_ott_indimuse/LocalData/hive_models.dart';
import 'package:edu_ott_indimuse/PositionedLogo.dart';
import 'package:edu_ott_indimuse/trays/MasterTray.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SettingsWithMovies? settingsWithMovies;

  @override
  void initState() {
    super.initState();
    _fetchSettingsFromHive();
  }

  Future<void> _fetchSettingsFromHive() async {
    try {
      var swmBox =
          await Hive.openBox<SettingsWithMovies>('settingsWithMoviesBox');
      setState(() {
        settingsWithMovies = swmBox.get('data');
      });
    } catch (e) {
      print('Error fetching settingsWithMovies: $e');
    }
  }

  Future<void> _refreshData() async {
    // Add your refresh logic here
    await _fetchSettingsFromHive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fixed logo at top
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PositionedLogo(),
          ),

          // Scrollable content starts below the logo
          if (settingsWithMovies != null)
            Padding(
              padding: const EdgeInsets.only(
                  top: 110, bottom: 0), // height + some buffer
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0;
                          i < settingsWithMovies!.settings.pageSettings.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Builder(
                            builder: (context) {
                              final item =
                                  settingsWithMovies!.settings.pageSettings[i];
                              final moviesData = settingsWithMovies!.movies;

                              switch (item.type) {
                                case "tray":
                                  return MasterTray(
                                    traycomponent: item.settings,
                                    media: moviesData,
                                    routePage: "Home",
                                  );
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
