// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsInfo _$GoodsInfoFromJson(Map<String, dynamic> json) => GoodsInfo(
      goodsId: json['goodsId'] as int?,
      goodsName: json['goodsName'] as String?,
      mainPics: json['mainPics'] as String?,
      marketPrice: json['marketPrice'] as String?,
    );

Map<String, dynamic> _$GoodsInfoToJson(GoodsInfo instance) => <String, dynamic>{
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'mainPics': instance.mainPics,
      'marketPrice': instance.marketPrice,
    };
