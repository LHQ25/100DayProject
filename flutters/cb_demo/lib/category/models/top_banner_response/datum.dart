import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  String? img;
  String? title;
  String? info;
  String? href;
  int? id;
  @JsonKey(name: 'is_login')
  int? isLogin;
  bool? isShare;

  Datum({
    this.img,
    this.title,
    this.info,
    this.href,
    this.id,
    this.isLogin,
    this.isShare,
  });

  @override
  String toString() {
    return 'Datum(img: $img, title: $title, info: $info, href: $href, id: $id, isLogin: $isLogin, isShare: $isShare)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
