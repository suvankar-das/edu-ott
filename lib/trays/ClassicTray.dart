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

    switch (widget.orientation) {
      case "landscape":
        height = isAndroidTv
            ? (MediaQuery.sizeOf(context).width / 6) * 9 / 16
            : (((MediaQuery.of(context).size.width) / 2.5) * 9) / 16;
        width = isAndroidTv
            ? MediaQuery.of(context).size.width / 5
            : MediaQuery.of(context).size.width / 2.5;
        break;
      case "square":
        height = isAndroidTv
            ? MediaQuery.sizeOf(context).width / 7
            : (MediaQuery.of(context).size.width) / 3;
        width = isAndroidTv
            ? MediaQuery.of(context).size.width / 5.5
            : MediaQuery.of(context).size.width / 3;
        break;
      case "portrait":
        height = isAndroidTv
            ? MediaQuery.of(context).size.height * 0.30
            : ((MediaQuery.of(context).size.width / 4) * 16) / 9;
        width = isAndroidTv
            ? MediaQuery.of(context).size.width / 9
            : MediaQuery.of(context).size.width / 4;
        break;
    }

    if (widget.size == "poster") {
      height = isAndroidTv
          ? MediaQuery.of(context).size.height * 0.7 * 1.5
          : ((MediaQuery.of(context).size.width / 4) * 16 / 9) * 1.5;
      width = isAndroidTv
          ? MediaQuery.of(context).size.height * 0.7 * 1.5
          : ((MediaQuery.of(context).size.width / 4) * 16 / 9) * 1.5;
    }

    final orderedMovieIds = widget.movieIds.values.toList();

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            height: height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: orderedMovieIds.length,
              itemBuilder: (context, index) {
                final movieId = orderedMovieIds[index];
                final movie = widget.moviescontent[movieId];

                if (movie == null) return const SizedBox.shrink();

                bool isFocused = index == focusedIndex;
                String imageUrl;

                switch (widget.orientation) {
                  case 'portrait':
                    imageUrl = movie.images?.img9_16 != null
                        ? '${EnvironmentVars.bucketUrl}/${movie.images!.img9_16}'
                        : EnvironmentVars.defaultImage;
                    break;
                  case 'landscape':
                    imageUrl = movie.images?.img16_9 != null
                        ? '${EnvironmentVars.bucketUrl}/${movie.images!.img16_9}'
                        : EnvironmentVars.defaultImage;
                    break;
                  case 'square':
                    imageUrl = movie.images?.img1_1 != null
                        ? '${EnvironmentVars.bucketUrl}/${movie.images!.img1_1}'
                        : EnvironmentVars.defaultImage;
                    break;
                  default:
                    imageUrl = EnvironmentVars.defaultImage;
                }

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
                        // Navigator.push(...)
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()
                          ..scale(isAndroidTv && isFocused ? 1.1 : 1.0),
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
                        height: height,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.medium,
                                maxHeightDiskCache: 800,
                                maxWidthDiskCache: 800,
                                imageUrl: imageUrl,
                                fit: BoxFit.fill,
                                width: width,
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
