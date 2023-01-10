import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  int? id;
  int? type;
  int? videoRankType;
  String? title;
  String? cover;

  Datum({this.id, this.type, this.videoRankType, this.title, this.cover});

  @override
  String toString() {
    return 'Datum(id: $id, type: $type, videoRankType: $videoRankType, title: $title, cover: $cover)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
