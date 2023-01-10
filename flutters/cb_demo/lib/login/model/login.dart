import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginRequest {
  String? scene;
  String? client;
  String? phone;
  String? token;
  bool? cancelClose;
  String? smsCode;
  String? YDtoken;

  //{"scene":"phone","client":"2","phone":"18637683265","token":"","cancelClose":false,"smsCode":"424588","YDtoken":""}

  LoginRequest(
      {this.scene,
      this.client,
      this.phone,
      this.token,
      this.cancelClose,
      this.smsCode,
      this.YDtoken});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'data')
  Data data;

  LoginResponse(
    this.code,
    this.message,
    this.data,
  );

  factory LoginResponse.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  String toString() {
    return "$code $message $data";
  }
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'appToken')
  String appToken;

  @JsonKey(name: 'imToken')
  String imToken;

  @JsonKey(name: 'userId')
  int userId;

  @JsonKey(name: 'sex')
  int sex;

  @JsonKey(name: 'area')
  String area;

  @JsonKey(name: 'isRealname')
  bool isRealname;

  @JsonKey(name: 'isPayPwd')
  bool isPayPwd;

  @JsonKey(name: 'head')
  String head;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'account')
  String account;

  @JsonKey(name: 'mark')
  int mark;

  @JsonKey(name: 'bindTel')
  String bindTel;

  @JsonKey(name: 'isLogin')
  bool isLogin;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'identity')
  List<Identity> identity;

  Data(
    this.appToken,
    this.imToken,
    this.userId,
    this.sex,
    this.area,
    this.isRealname,
    this.isPayPwd,
    this.head,
    this.nickname,
    this.account,
    this.mark,
    this.bindTel,
    this.isLogin,
    this.status,
    this.identity,
  );

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  @override
  String toString() {
    return "$userId $nickname";
  }
}

@JsonSerializable()
class Identity {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'tag')
  List<Tag> tag;

  Identity(
    this.id,
    this.name,
    this.icon,
    this.tag,
  );

  factory Identity.fromJson(Map<String, dynamic> srcJson) =>
      _$IdentityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$IdentityToJson(this);
}

@JsonSerializable()
class Tag {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  Tag(this.id, this.name);

  factory Tag.fromJson(Map<String, dynamic> srcJson) => _$TagFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
