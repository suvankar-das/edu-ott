import 'package:edu_ott_indimuse/LocalData/hive_models.dart';
import 'package:edu_ott_indimuse/trays/ClassicTray.dart';
import 'package:flutter/material.dart';

class MasterTray extends StatefulWidget {
  const MasterTray({
    Key? key,
    required this.traycomponent,
    required this.media,
    required this.routePage,
  }) : super(key: key);

  final PageSettingDetails traycomponent;
  final Map<String, MovieModel> media;
  final String? routePage;

  @override
  State<MasterTray> createState() => _MasterTrayState();
}

class _MasterTrayState extends State<MasterTray> {
  @override
  Widget build(BuildContext context) {
    switch (widget.traycomponent.component!.compType) {
      case "classic":
        return ClassicTray(
          orientation: widget.traycomponent.element!.orientation,
          size: widget.traycomponent.element!.size,
          arrangement: widget.traycomponent.component!.arrangement,
          moviescontent: widget.media,
          title: widget.traycomponent.title,
          routePage: widget.routePage,
          movieIds: widget.traycomponent.content,
        );

      default:
        return SizedBox.shrink();
    }
  }
}
