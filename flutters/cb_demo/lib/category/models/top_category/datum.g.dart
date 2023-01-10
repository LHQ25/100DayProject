// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      id: json['id'] as int?,
      type: json['type'] as int?,
      videoRankType: json['videoRankType'] as int?,
      title: json['title'] as String?,
      cover: json['cover'] as String?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'videoRankType': instance.videoRankType,
      'title': instance.title,
      'cover': instance.cover,
    };
