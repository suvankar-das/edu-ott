import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:edu_ott_indimuse/Environment.dart';
import 'package:edu_ott_indimuse/LocalData/hive_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class ClassicTray extends StatefulWidget {
  const ClassicTray({
    Key? key,
    required this.orientation,
    required this.size,
    required this.arrangement,
    required this.moviescontent,
    required this.title,
    required this.routePage,
    required this.movieIds,
  }) : super(key: key);

  final Map<String, MovieModel> moviescontent;
  final String orientation;
  final String size;
  final String arrangement;
  final String? title;
  final String? routePage;
  final Map<String, String> movieIds;

  @override
  State<ClassicTray> createState() => _ClassicTrayState();
}

class _ClassicTrayState extends State<ClassicTray> {
  double height = 0.0;
  double width = 0.0;
  bool ready = false;
  bool isAndroidTv = false;
  int? focusedIndex;

  @override
  void initState() {
    super.initState();
    _checkCurrentDevice();
  }

  Future<void> _checkCurrentDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      bool is_AndroidTv = false;

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.systemFeatures != null &&
            androidInfo.systemFeatures!.contains('android.software.leanback')) {
          is_AndroidTv = true;
        }
      }

      setState(() {
        ready = true;
        isAndroidTv = is_AndroidTv;
      });
    } catch (e) {
      print("Error getting device info: $e");
      setState(() {
        ready = true;
        isAndroidTv = false;
      });
    }
  }

  @override
  void dispose() {
    focusedIndex = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) return SizedBox.shrink();

    height = (MediaQuery.of(context).size.width) / 3;
    width = MediaQuery.of(context).size.width / 3;

    final orderedMovieIds = widget.movieIds.values.toList();

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? 'Default Title',
            style: const TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: height + 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: orderedMovieIds.length,
              itemBuilder: (context, index) {
                final movieId = orderedMovieIds[index];
                final movie = widget.moviescontent[movieId];

                if (movie == null) return const SizedBox.shrink();

                String title = movie.title;
                String author = movie.author ?? '';
                String rating = "4.7";

                bool isFocused = index == focusedIndex;
                String imageUrl = movie.images?.img1_1 != null
                    ? '${EnvironmentVars.bucketUrl}/${movie.images!.img1_1}'
                    : EnvironmentVars.defaultImage;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Focus(
                    canRequestFocus: isAndroidTv,
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        setState(() {
                          focusedIndex = index;
                        });
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        // Handle navigation
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()
                          ..scale(isAndroidTv && isFocused ? 1.1 : 1.0),
                        width: width,
                        height: height + 100,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            if (isAndroidTv && isFocused)
                              const BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: width,
                                height: height,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.grey),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Container(
                              width: width,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.85),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'by $author',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text(
                                        "4.7",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.star,
                                          color: Colors.orange, size: 14),
                                      const Icon(Icons.star,
                                          color: Colors.orange, size: 14),
                                      const Icon(Icons.star,
                                          color: Colors.orange, size: 14),
                                      const Icon(Icons.star,
                                          color: Colors.orange, size: 14),
                                      const Icon(Icons.star_half,
                                          color: Colors.orange, size: 14),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          "(5123)",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
