import 'package:cb_demo/category/models/top_banner_response/top_banner_response.dart';
import 'package:cb_demo/category/models/top_category/top_category.dart';
import 'package:cb_demo/category/models/top_hot_video_response/top_hot_video_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../util/net_util/base_dio.dart';

part 'top_api.g.dart';

@RestApi(baseUrl: "https://testa.onlinepk.cn")
abstract class TopClient {
  factory TopClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance()!.getDio();
    return _TopClient(dio, baseUrl: baseUrl);
  }

  @POST("/RanklistCarousel")
  Future<TopBannerResponse> getBanner(@Body() EmptyRequest task);

  @POST("/CourseRankCategory")
  Future<TopCategory> getCategory(@Body() EmptyRequest task);

  @POST("/HotVideoList")
  Future<TopHotVideoResponse> getVideoList(@Body() TopHotVideoRequest task);
}
