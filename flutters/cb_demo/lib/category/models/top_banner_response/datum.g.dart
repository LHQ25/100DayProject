// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      img: json['img'] as String?,
      title: json['title'] as String?,
      info: json['info'] as String?,
      href: json['href'] as String?,
      id: json['id'] as int?,
      isLogin: json['is_login'] as int?,
      isShare: json['isShare'] as bool?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'img': instance.img,
      'title': instance.title,
      'info': instance.info,
      'href': instance.href,
      'id': instance.id,
      'is_login': instance.isLogin,
      'isShare': instance.isShare,
    };
