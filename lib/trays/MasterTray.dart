// import 'package:flutter/material.dart';

// class MasterTray extends StatefulWidget {
//   const MasterTray({
//     Key? key,
//     required this.traycomponent,
//     required this.media,
//     required this.index,
//     required this.continueWatchTrayData,
//     required this.routePage,
//   }) : super(key: key);

//   final Settings traycomponent;
//   final Size media;
//   final int index;
//   final List<dynamic> continueWatchTrayData;
//   final String? routePage;

//   @override
//   State<MasterTray> createState() => _MasterTrayState();
// }

// class _MasterTrayState extends State<MasterTray> {
//   @override
//   Widget build(BuildContext context) {
//     switch (widget.traycomponent.component!.compType) {
//       case "classic":
//         return ClassicTray(
//             orientation: widget.traycomponent.element!.orientation,
//             size: widget.traycomponent.element!.size,
//             arrangement: widget.traycomponent.component!.arrangement,
//             moviescontent: widget.traycomponent.movies,
//             title: widget.traycomponent.title,
//             routePage: widget.routePage);
//       case "continue_watch":
//         return ContinueWatchTray(
//             orientation: widget.traycomponent.element!.orientation,
//             size: widget.traycomponent.element!.size,
//             arrangement: widget.traycomponent.component!.arrangement,
//             moviescontent: widget.traycomponent.movies,
//             title: widget.traycomponent.title,
//             continueWatchTrayData: widget.continueWatchTrayData);
//       case "featured":
//         return FeaturedTray(
//             orientation: widget.traycomponent.element!.orientation,
//             size: widget.traycomponent.element!.size,
//             arrangement: widget.traycomponent.component!.arrangement,
//             moviescontent: widget.traycomponent.movies,
//             title: widget.traycomponent.title,
//             featuredItemRankWise: widget.traycomponent.content,
//             routePage: widget.routePage);
//       default:
//         return SizedBox.shrink();
//     }
//   }
// }
