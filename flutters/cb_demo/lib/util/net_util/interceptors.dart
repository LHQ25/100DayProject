import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:platform_device_id/platform_device_id.dart';

class HeaderInterceptor extends Interceptor {
  final saltKey =
      "28C0+4749/8921426c/8f60=9d217/Ea8a4Fe6161EC217a5244B9+A1B0f=D89e5d04=A+71D67+8317acE527300A60E0e7D7A986fF1E6922aD=cDBE++C6DDbF1880844eBd3=1B37D8b3D64600d7+0970f6e15929e3C78D54734ace6F55/5c7+7555D947EFB584EA3c9=+8CC672489A6e0EB7C=5682/d8032E4Fee5760=0ac814";

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Map<String, dynamic> headers = options.headers;

    final key = utf8.encode(saltKey);
    final hmac = Hmac(sha256, key);
    var d = JsonUtf8Encoder();
    var l = d.convert(options.data);
    final sign = hmac.convert(l).toString();

    print("- 0 -> , $l $sign");
    headers['Sign'] = sign;

    headers['Accept'] = 'application/vnd.byapp.v1+json';
    headers['Platform'] = 'iOS';

    var deviceId = await PlatformDeviceId.getDeviceId;
    headers['deviceId'] = deviceId ?? '';

    headers['idfa'] = AdvertisingId.id(true);
    headers['BundleId'] = 'com.app.zytest';
    headers['Accept-Language'] = 'zh-Hans-CN;q=1.0, ja-CN;q=0.9, ko-CN;q=0.8';

    headers['Sign'] =
        '7c8bde09068abae5f5c0a73740498ab3359b0fe418da84e9872be176f26e485f';

    headers['Version'] = '2.0.7';
    headers['Channel'] = 'iOS';
    headers['Accept-Encoding'] = 'br;q=1.0, gzip;q=0.9, deflate;q=0.8';

    var time = DateTime.now().millisecondsSinceEpoch;
    headers['Timestamp'] = time.toString();

    headers['Content-Type'] = 'application/json';
    headers['User-Agent'] =
        'BreathLive/2.0.7 (com.app.zytest; build:202; iOS 14.8.1) Alamofire/5.6.2';
    options.headers = headers;

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // response.headers.set("Content-Type", "application/json");
    if (response.data is String) {
      response.data = jsonDecode(response.data);
    }
    handler.next(response);
    // super.onResponse(response, handler);
  }
}
