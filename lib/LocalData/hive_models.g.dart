// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 1;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      id: fields[0] as String,
      pageId: fields[1] as String,
      region: fields[2] as String,
      isActive: fields[3] as bool,
      isDelete: fields[4] as bool,
      pageSettings: (fields[5] as List).cast<PageSetting>(),
      pageTypeId: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pageId)
      ..writeByte(2)
      ..write(obj.region)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.isDelete)
      ..writeByte(5)
      ..write(obj.pageSettings)
      ..writeByte(6)
      ..write(obj.pageTypeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PageSettingAdapter extends TypeAdapter<PageSetting> {
  @override
  final int typeId = 2;

  @override
  PageSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageSetting(
      id: fields[0] as String,
      type: fields[1] as String,
      settings: fields[2] as PageSettingDetails,
    );
  }

  @override
  void write(BinaryWriter writer, PageSetting obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PageSettingDetailsAdapter extends TypeAdapter<PageSettingDetails> {
  @override
  final int typeId = 3;

  @override
  PageSettingDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageSettingDetails(
      id: fields[0] as String,
      component: fields[1] as PageComponent,
      content: (fields[2] as Map).cast<String, String>(),
      contentSelectionCriteria: fields[3] as ContentSelectionCriteria,
      element: fields[4] as PageElement,
      hideAfterLogin: fields[5] as bool,
      isActive: fields[6] as bool,
      isDelete: fields[7] as bool,
      pageId: fields[8] as String,
      title: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PageSettingDetails obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.component)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.contentSelectionCriteria)
      ..writeByte(4)
      ..write(obj.element)
      ..writeByte(5)
      ..write(obj.hideAfterLogin)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.isDelete)
      ..writeByte(8)
      ..write(obj.pageId)
      ..writeByte(9)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageSettingDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PageComponentAdapter extends TypeAdapter<PageComponent> {
  @override
  final int typeId = 4;

  @override
  PageComponent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageComponent(
      compType: fields[0] as String,
      arrangement: fields[1] as String,
      limit: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PageComponent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.compType)
      ..writeByte(1)
      ..write(obj.arrangement)
      ..writeByte(2)
      ..write(obj.limit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageComponentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentSelectionCriteriaAdapter
    extends TypeAdapter<ContentSelectionCriteria> {
  @override
  final int typeId = 5;

  @override
  ContentSelectionCriteria read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentSelectionCriteria(
      category: (fields[0] as List).cast<String>(),
      tag: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ContentSelectionCriteria obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentSelectionCriteriaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PageElementAdapter extends TypeAdapter<PageElement> {
  @override
  final int typeId = 6;

  @override
  PageElement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageElement(
      orientation: fields[0] as String,
      size: fields[1] as String,
      isHover: fields[2] as bool,
      isFooterTitle: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PageElement obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.orientation)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.isHover)
      ..writeByte(3)
      ..write(obj.isFooterTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageElementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 7;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      permalink: fields[3] as String,
      tags: (fields[4] as List).cast<String>(),
      images: fields[5] as MovieImages?,
      author: fields[6] as String?,
      isFirstEpisodeFree: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.permalink)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.author)
      ..writeByte(7)
      ..write(obj.isFirstEpisodeFree);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieImagesAdapter extends TypeAdapter<MovieImages> {
  @override
  final int typeId = 8;

  @override
  MovieImages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieImages(
      img32_9: fields[0] as String?,
      img16_9: fields[1] as String?,
      img9_16: fields[2] as String?,
      img1_1: fields[3] as String?,
      img3_4: fields[4] as String?,
      img4_3: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieImages obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.img32_9)
      ..writeByte(1)
      ..write(obj.img16_9)
      ..writeByte(2)
      ..write(obj.img9_16)
      ..writeByte(3)
      ..write(obj.img1_1)
      ..writeByte(4)
      ..write(obj.img3_4)
      ..writeByte(5)
      ..write(obj.img4_3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieImagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SettingsWithMoviesAdapter extends TypeAdapter<SettingsWithMovies> {
  @override
  final int typeId = 9;

  @override
  SettingsWithMovies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsWithMovies(
      settings: fields[0] as SettingsModel,
      movies: (fields[1] as Map).cast<String, MovieModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SettingsWithMovies obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.settings)
      ..writeByte(1)
      ..write(obj.movies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsWithMoviesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
