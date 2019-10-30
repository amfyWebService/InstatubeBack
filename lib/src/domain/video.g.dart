// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Video extends _Video {
  Video(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.title,
      this.description,
      this.path});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  final String userId;

  @override
  final String title;

  @override
  final String description;

  @override
  final String path;

  Video copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String userId,
      String title,
      String description,
      String path}) {
    return Video(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        path: path ?? this.path);
  }

  bool operator ==(other) {
    return other is _Video &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.path == path;
  }

  @override
  int get hashCode {
    return hashObjects(
        [id, createdAt, updatedAt, userId, title, description, path]);
  }

  @override
  String toString() {
    return "Video(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, userId=$userId, title=$title, description=$description, path=$path)";
  }

  Map<String, dynamic> toJson() {
    return VideoSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const VideoSerializer videoSerializer = VideoSerializer();

class VideoEncoder extends Converter<Video, Map> {
  const VideoEncoder();

  @override
  Map convert(Video model) => VideoSerializer.toMap(model);
}

class VideoDecoder extends Converter<Map, Video> {
  const VideoDecoder();

  @override
  Video convert(Map map) => VideoSerializer.fromMap(map);
}

class VideoSerializer extends Codec<Video, Map> {
  const VideoSerializer();

  @override
  get encoder => const VideoEncoder();
  @override
  get decoder => const VideoDecoder();
  static Video fromMap(Map map) {
    return Video(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        userId: map['user_id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        path: map['path'] as String);
  }

  static Map<String, dynamic> toMap(_Video model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'user_id': model.userId,
      'title': model.title,
      'description': model.description,
      'path': model.path
    };
  }
}

abstract class VideoFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    userId,
    title,
    description,
    path
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String userId = 'user_id';

  static const String title = 'title';

  static const String description = 'description';

  static const String path = 'path';
}

// **************************************************************************
// _GraphQLGenerator
// **************************************************************************

/// Auto-generated from [Video].
final GraphQLObjectType videoGraphQLType =
    objectType('Video', isInterface: false, interfaces: [], fields: [
  field('id', graphQLString),
  field('created_at', graphQLDate),
  field('updated_at', graphQLDate),
  field('user_id', graphQLString),
  field('title', graphQLString),
  field('description', graphQLString),
  field('path', graphQLString),
  field('idAsInt', graphQLInt)
]);
