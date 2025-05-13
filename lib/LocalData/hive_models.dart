// hive_models.dart
import 'package:hive/hive.dart';

part 'hive_models.g.dart';

@HiveType(typeId: 1)
class SettingsModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pageId;

  @HiveField(2)
  final String region;

  @HiveField(3)
  final bool isActive;

  @HiveField(4)
  final bool isDelete;

  @HiveField(5)
  final List<PageSetting> pageSettings;

  @HiveField(6)
  final String pageTypeId;

  SettingsModel({
    required this.id,
    required this.pageId,
    required this.region,
    required this.isActive,
    required this.isDelete,
    required this.pageSettings,
    required this.pageTypeId,
  });
}

@HiveType(typeId: 2)
class PageSetting {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final PageSettingDetails settings;

  PageSetting({
    required this.id,
    required this.type,
    required this.settings,
  });
}

@HiveType(typeId: 3)
class PageSettingDetails {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final PageComponent component;

  @HiveField(2)
  final Map<String, String> content;

  @HiveField(3)
  final ContentSelectionCriteria contentSelectionCriteria;

  @HiveField(4)
  final PageElement element;

  @HiveField(5)
  final bool hideAfterLogin;

  @HiveField(6)
  final bool isActive;

  @HiveField(7)
  final bool isDelete;

  @HiveField(8)
  final String pageId;

  @HiveField(9)
  final String title;

  PageSettingDetails({
    required this.id,
    required this.component,
    required this.content,
    required this.contentSelectionCriteria,
    required this.element,
    required this.hideAfterLogin,
    required this.isActive,
    required this.isDelete,
    required this.pageId,
    required this.title,
  });
}

@HiveType(typeId: 4)
class PageComponent {
  @HiveField(0)
  final String compType;

  @HiveField(1)
  final String arrangement;

  @HiveField(2)
  final int limit;

  PageComponent({
    required this.compType,
    required this.arrangement,
    required this.limit,
  });
}

@HiveType(typeId: 5)
class ContentSelectionCriteria {
  @HiveField(0)
  final List<String> category;

  @HiveField(1)
  final List<String> tag;

  ContentSelectionCriteria({
    required this.category,
    required this.tag,
  });
}

@HiveType(typeId: 6)
class PageElement {
  @HiveField(0)
  final String orientation;

  @HiveField(1)
  final String size;

  @HiveField(2)
  final bool isHover;

  @HiveField(3)
  final bool isFooterTitle;

  PageElement({
    required this.orientation,
    required this.size,
    required this.isHover,
    required this.isFooterTitle,
  });
}

@HiveType(typeId: 7)
class MovieModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String permalink;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final MovieImages? images;

  @HiveField(6)
  final String? author;

  @HiveField(7)
  final bool isFirstEpisodeFree;

  MovieModel({
    required this.id,
    required this.title,
    required this.type,
    required this.permalink,
    required this.tags,
    this.images,
    this.author,
    required this.isFirstEpisodeFree,
  });
}

@HiveType(typeId: 8)
class MovieImages {
  @HiveField(0)
  final String? img32_9;

  @HiveField(1)
  final String? img16_9;

  @HiveField(2)
  final String? img9_16;

  @HiveField(3)
  final String? img1_1;

  @HiveField(4)
  final String? img3_4;

  @HiveField(5)
  final String? img4_3;

  MovieImages({
    this.img32_9,
    this.img16_9,
    this.img9_16,
    this.img1_1,
    this.img3_4,
    this.img4_3,
  });
}

@HiveType(typeId: 9)
class SettingsWithMovies {
  @HiveField(0)
  final SettingsModel settings;

  @HiveField(1)
  final Map<String, MovieModel> movies;

  SettingsWithMovies({
    required this.settings,
    required this.movies,
  });
}
