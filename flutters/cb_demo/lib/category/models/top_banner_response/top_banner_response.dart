import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'top_banner_response.g.dart';

@JsonSerializable()
class EmptyRequest {
  EmptyRequest();
  factory EmptyRequest.fromJson(Map<String, dynamic> json) {
    return _$EmptyRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EmptyRequestToJson(this);
}

@JsonSerializable()
class TopBannerResponse {
  int? code;
  String? message;
  List<Datum>? data;

  TopBannerResponse({this.code, this.message, this.data});

  @override
  String toString() {
    return 'TopBannerResponse(code: $code, message: $message, data: $data)';
  }

  factory TopBannerResponse.fromJson(Map<String, dynamic> json) {
    return _$TopBannerResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TopBannerResponseToJson(this);
}
