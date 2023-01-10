import 'package:dio/dio.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

import 'base_error.dart';
import 'interceptors.dart';

class BaseDio {
  BaseDio._(); // 把构造方法私有化

  static BaseDio? _instance;

  static BaseDio? getInstance() {
    // 通过 getInstance 获取实例
    _instance ??= BaseDio._();

    return _instance;
  }

  Dio getDio() {
    final Dio dio = Dio()
      ..options = BaseOptions(
          receiveTimeout: 55000, connectTimeout: 66000); // 设置超时时间等 ...
    dio.interceptors.add(HeaderInterceptor()); // 添加拦截器，如 token之类，需要全局使用的参数
    dio.interceptors.add(PrettyDioLogger(
        // 添加日志格式化工具类
        requestHeader: true,
        requestBody: true,
        responseBody: true));

    return dio;
  }

  BaseError getDioError(Object obj) {
    // 这里封装了一个 BaseError 类，会根据后端返回的code返回不同的错误类
    switch (obj.runtimeType) {
      case DioError:
        if ((obj as DioError).type == DioErrorType.response) {
          final response = obj.response;
          if (response!.statusCode == 401) {
            return NeedLogin();
          } else {
            return OtherError(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
            );
          }
        }
    }

    return OtherError();
  }
}
