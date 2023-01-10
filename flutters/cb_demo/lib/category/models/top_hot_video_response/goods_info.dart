import 'package:json_annotation/json_annotation.dart';

part 'goods_info.g.dart';

@JsonSerializable()
class GoodsInfo {
  int? goodsId;
  String? goodsName;
  String? mainPics;
  String? marketPrice;

  GoodsInfo({
    this.goodsId,
    this.goodsName,
    this.mainPics,
    this.marketPrice,
  });

  @override
  String toString() {
    return 'GoodsInfo(goodsId: $goodsId, goodsName: $goodsName, mainPics: $mainPics, marketPrice: $marketPrice)';
  }

  factory GoodsInfo.fromJson(Map<String, dynamic> json) {
    return _$GoodsInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GoodsInfoToJson(this);
}
