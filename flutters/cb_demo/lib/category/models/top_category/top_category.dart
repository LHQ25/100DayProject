import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'top_category.g.dart';

@JsonSerializable()
class TopCategory {
  int? code;
  String? message;
  List<Datum>? data;

  TopCategory({this.code, this.message, this.data});

  @override
  String toString() {
    return 'TopCategory(code: $code, message: $message, data: $data)';
  }

  factory TopCategory.fromJson(Map<String, dynamic> json) {
    return _$TopCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TopCategoryToJson(this);
}
