import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DioTest extends StatefulWidget {
  const DioTest({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _DioTestState();
}

class _DioTestState extends State<DioTest> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio'),
      ),
      body: const Center(
        child: Text('Dio'),
      ),
    );
  }
}

typedef T? RequestCallBack<T>(Type t);
class HttpWork {
  // 私有构造函数
  HttpWork._internal();

  // 保存单例
  static final HttpWork _singleton = HttpWork._internal();

  // 工厂构造函数
  factory HttpWork() => _singleton;

  final Dio _dio = Dio();

  Future<RequestCallBack> request<T>(urlString, Map<String, dynamic>? parameters) async {

    _dio.interceptors.add(MyInterceptor());

    Response<T> response = await _dio.post(urlString, data: parameters) as Response<T>;
    if (response.statusCode == HttpStatus.ok) {
      return (t){
           return response;
      };
    }else{
      return (t){
        return null;
      };
    }
  }
}

class MyInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
