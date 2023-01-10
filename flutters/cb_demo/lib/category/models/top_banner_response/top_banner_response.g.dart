// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_banner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmptyRequest _$EmptyRequestFromJson(Map<String, dynamic> json) =>
    EmptyRequest();

Map<String, dynamic> _$EmptyRequestToJson(EmptyRequest instance) =>
    <String, dynamic>{};

TopBannerResponse _$TopBannerResponseFromJson(Map<String, dynamic> json) =>
    TopBannerResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopBannerResponseToJson(TopBannerResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
