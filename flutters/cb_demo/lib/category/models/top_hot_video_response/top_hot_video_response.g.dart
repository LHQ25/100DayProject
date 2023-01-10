// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_hot_video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopHotVideoResponse _$TopHotVideoResponseFromJson(Map<String, dynamic> json) =>
    TopHotVideoResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopHotVideoResponseToJson(
        TopHotVideoResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

TopHotVideoRequest _$TopHotVideoRequestFromJson(Map<String, dynamic> json) =>
    TopHotVideoRequest(
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      cityCode: json['cityCode'] as String?,
      currentPage: json['currentPage'] as int?,
    );

Map<String, dynamic> _$TopHotVideoRequestToJson(TopHotVideoRequest instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'cityCode': instance.cityCode,
      'currentPage': instance.currentPage,
    };
