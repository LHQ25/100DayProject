import 'package:cb_demo/util/net_util/rest_api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../util/net_util/base_dio.dart';
import 'login.dart';

part 'login_api.g.dart';

@RestApi(baseUrl: "https://testa.onlinepk.cn")
abstract class LoginClient {
  factory LoginClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance()!.getDio();
    return _LoginClient(dio, baseUrl: baseUrl);
  }

  @POST("/Login")
  Future<LoginResponse> getTasks(@Body() LoginRequest task);
}
