import 'package:cb_demo/category/models/top_api.dart';
import 'package:cb_demo/category/models/top_banner_response/top_banner_response.dart';
import 'package:cb_demo/category/models/top_hot_video_response/top_hot_video_response.dart';
import '../models/top_category/datum.dart' as cd;
import '../models/top_hot_video_response/datum.dart' as vd;
import 'package:get/get.dart';

import '../models/top_banner_response/datum.dart';

class TopPageController extends GetxController {
  final _api = TopClient();

  var banners = RxList<Datum>();
  var cates = RxList<cd.Datum>();
  var videos = RxList<vd.Datum>();

  @override
  void onReady() {
    _api.getBanner(EmptyRequest()).then((data) {
      banners.value = data.data ?? [];
    }).catchError((err) {
      printError(info: err.toString());
    });

    _api.getCategory(EmptyRequest()).then((data) {
      cates.value = data.data ?? [];
    }).catchError((err) {
      printError(info: err.toString());
    });
    // "cityCode": "010", "lat": "39.9197300889757", "lng": "116.44113850911458", "currentPage": 1
    _api
        .getVideoList(TopHotVideoRequest(
            lat: "39.9197300889757",
            lng: "116.44113850911458",
            cityCode: "010",
            currentPage: 1))
        .then((data) {
      videos.value = data.data ?? [];
    }).catchError((err) {
      printError(info: err.toString());
    });
    super.onReady();
  }
}
