import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../login/model/login.dart';
import 'base_dio.dart';

part 'rest_api.g.dart'; //必须配置，否则无法生成.g文件

@RestApi(baseUrl: "https://testa.onlinepk.cn")
abstract class RestClient {
  factory RestClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance()!.getDio();
    return _RestClient(dio, baseUrl: baseUrl);
  }
}
