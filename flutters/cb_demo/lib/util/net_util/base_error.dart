abstract class BaseError {
  final int? code;
  final String? message;

  BaseError({this.code, this.message});
}

class NeedLogin implements BaseError {
  @override
  int get code => 401;

  @override
  String get message => "请先登录";
}

class OtherError implements BaseError {
  final int? statusCode;
  final String? statusMessage;

  OtherError({this.statusCode, this.statusMessage});

  @override
  int? get code => statusCode;

  @override
  String? get message => statusMessage;
}
