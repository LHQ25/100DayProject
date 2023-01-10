// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopCategory _$TopCategoryFromJson(Map<String, dynamic> json) => TopCategory(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopCategoryToJson(TopCategory instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
