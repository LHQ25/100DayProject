import 'dart:convert';

import 'package:advertising_id/advertising_id.dart';
import 'package:crypto/crypto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 生成的文件名
part 'RestClient.g.dart';

class Apis {
  static const String getShopOrderStatistic = '/order/getShopOrderStatistic';
}

@RestApi(baseUrl: "https://tmall.exampleol.cn")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST(Apis.getShopOrderStatistic)
  Future<List<Task>> getShopOrderStatistic();
}

class HttpWork {
  final Dio _dio = Dio();

  // 私有构造函数 -> 命名构造函数
  HttpWork._internal() {
    _dio.interceptors.add(MyInterceptor());
  }

  // 保存单例
  static final HttpWork _singleton = HttpWork._internal();

  // 工厂构造函数
  factory HttpWork() => _singleton;

  T request<T extends RestClient>(T api) {
    return api;
  }
}

class MyInterceptor extends Interceptor {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final saltKey =
      "28C0+4749/8921426c/8f60=9d217/Ea8a4Fe6161EC217a5244B9+A1B0f=D89e5d04=A+71D67+8317acE527300A60E0e7D7A986fF1E6922aD=cDBE++C6DDbF1880844eBd3=1B37D8b3D64600d7+0970f6e15929e3C78D54734ace6F55/5c7+7555D947EFB584EA3c9=+8CC672489A6e0EB7C=5682/d8032E4Fee5760=0ac814";
  String apiVersion = 'v1';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var header = options.headers;
    if (options.data == null) {
      String? appToken =
          _prefs.then((value) => value.getString('appToken')) as String?;
      if ((appToken?.length ?? 0) > 5) {
        options.headers['token'] = appToken;
        handler.next(options);
      } else {
        super.onRequest(options, handler);
      }
    }

    final key = utf8.encode(saltKey);
    final hmac = Hmac(sha256, key);
    final sign = hmac.convert(options.data).toString();
    header['Sign'] = sign;

    header['token'] =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJCYW5nWWFuZ0FwcCIsImlhdCI6MTY2NjM0OTMxOSwiZXhwIjoxNjgxOTAxMzE5LCJuYmYiOjE2NjYzNDkzMTksInN1YiI6IiIsImp0aSI6IjhhZmFhNjViMDUyZmRlZDVhYmM5ZGMzMGMwMzQwNDI4IiwiZGV2aWNlSWQiOiIzMjVEMTBEMC04Qjc5LTRDODktQTM3NC1BQkVGNEU3RDg0NzQiLCJhY2NvdW50IjoiMTczNDAxNzk0OCIsImlkIjozMTAzN30.R5ZckwPy7MQL4MZbwCtm4-aFl2WT4aUCVKnIEUW8jts';

    header['idfa'] = AdvertisingId.id(true);

    var date = DateTime.now();
    header['Timestamp'] = date.millisecond;
    header['Platform'] = 'iOS';
    header['Channel'] = 'iOS';

    header['Accept'] = "application/vnd.byapp.$apiVersion+json";

    header['Version'] = '1.6.0';
    header['Accept-Encoding'] = 'br;q=1.0, gzip;q=0.9, deflate;q=0.8';
    header['Accept-Language'] = 'zh-Hans-CN;q=1.0';
    header['User-Agent'] =
        'BreathLive/1.6.0 (com.app.zytest; build:201; iOS 14.8.1) Alamofire/5.6.2';
    header['Content-Type'] = 'application/json';

    header['deviceId'] = '325D10D0-8B79-4C89-A374-ABEF4E7D8474';
    header['BundleId'] = 'com.app.zytest';

    options.headers = header;

    options.connectTimeout = 15;

    handler.next(options);
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

// 命令： flutter pub run build_runner build -> 生成API
// 命令： dart pub run build_runner build   -> 生成模型

@JsonSerializable()
class Task {
  int? orderStatus;
  int? num;

  Task({this.orderStatus, this.num});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
