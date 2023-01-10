// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      scene: json['scene'] as String?,
      client: json['client'] as String?,
      phone: json['phone'] as String?,
      token: json['token'] as String?,
      cancelClose: json['cancelClose'] as bool?,
      smsCode: json['smsCode'] as String?,
      YDtoken: json['YDtoken'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'scene': instance.scene,
      'client': instance.client,
      'phone': instance.phone,
      'token': instance.token,
      'cancelClose': instance.cancelClose,
      'smsCode': instance.smsCode,
      'YDtoken': instance.YDtoken,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      json['code'] as int,
      json['message'] as String,
      Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['appToken'] as String,
      json['imToken'] as String,
      json['userId'] as int,
      json['sex'] as int,
      json['area'] as String,
      json['isRealname'] as bool,
      json['isPayPwd'] as bool,
      json['head'] as String,
      json['nickname'] as String,
      json['account'] as String,
      json['mark'] as int,
      json['bindTel'] as String,
      json['isLogin'] as bool,
      json['status'] as int,
      (json['identity'] as List<dynamic>)
          .map((e) => Identity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'appToken': instance.appToken,
      'imToken': instance.imToken,
      'userId': instance.userId,
      'sex': instance.sex,
      'area': instance.area,
      'isRealname': instance.isRealname,
      'isPayPwd': instance.isPayPwd,
      'head': instance.head,
      'nickname': instance.nickname,
      'account': instance.account,
      'mark': instance.mark,
      'bindTel': instance.bindTel,
      'isLogin': instance.isLogin,
      'status': instance.status,
      'identity': instance.identity,
    };

Identity _$IdentityFromJson(Map<String, dynamic> json) => Identity(
      json['id'] as int,
      json['name'] as String,
      json['icon'] as String,
      (json['tag'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IdentityToJson(Identity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'tag': instance.tag,
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      json['id'] as int,
      json['name'] as String,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
