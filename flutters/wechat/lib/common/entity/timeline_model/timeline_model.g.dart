// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineModel _$TimelineModelFromJson(Map<String, dynamic> json) =>
    TimelineModel(
      id: json['id'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      video: json['video'] == null
          ? null
          : Video.fromJson(json['video'] as Map<String, dynamic>),
      content: json['content'] as String?,
      postType: json['post_type'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      publishDate: json['publishDate'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$TimelineModelToJson(TimelineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'images': instance.images,
      'video': instance.video,
      'content': instance.content,
      'post_type': instance.postType,
      'user': instance.user,
      'publishDate': instance.publishDate,
      'location': instance.location,
    };
