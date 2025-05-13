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
  SettingsModel? settingsWithMovies;

  @override
  void initState() {
    super.initState();
    _fetchSettingsFromHive();
  }

  Future<void> _fetchSettingsFromHive() async {
    try {
      var settingsBox = await Hive.openBox<SettingsModel>('settingsBox');
      setState(() {
        settingsWithMovies = settingsBox.get('settings');
      });
    } catch (e) {
      print('Error fetching settings: $e');
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
          const Center(child: PositionedLogo()),

          // ✅ Show actual content when data is available
          if (settingsWithMovies != null)
            RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i < settingsWithMovies!.pageSettings.length;
                        i++)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Builder(
                          builder: (context) {
                            final item = settingsWithMovies!.pageSettings[i];
                            switch (item.type) {
                              case "tray":
                              // return MasterTray(
                              //   traycomponent: item,
                              //   media: null,
                              //   index: i,
                              //   continueWatchTrayData: null,
                              //   routePage: "Home",
                              // );

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
        ],
      ),
    );
  }
}
