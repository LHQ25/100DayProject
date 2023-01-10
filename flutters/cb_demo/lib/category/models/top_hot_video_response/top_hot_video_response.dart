import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'top_hot_video_response.g.dart';

@JsonSerializable()
class TopHotVideoResponse {
  int? code;
  String? message;
  List<Datum>? data;

  TopHotVideoResponse({this.code, this.message, this.data});

  @override
  String toString() {
    return 'TopHotVideoResponse(code: $code, message: $message, data: $data)';
  }

  factory TopHotVideoResponse.fromJson(Map<String, dynamic> json) {
    return _$TopHotVideoResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TopHotVideoResponseToJson(this);
}

@JsonSerializable()
class TopHotVideoRequest {
  String? lat;
  String? lng;
  String? cityCode;
  int? currentPage;
  // "cityCode": "010", "lat": "39.9197300889757", "lng": "116.44113850911458", "currentPage": 1

  TopHotVideoRequest({this.lat, this.lng, this.cityCode, this.currentPage});

  factory TopHotVideoRequest.fromJson(Map<String, dynamic> json) {
    return _$TopHotVideoRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TopHotVideoRequestToJson(this);
}
