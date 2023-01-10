import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ArticPageViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final images = ["assets/images/banner/1.png", "assets/images/banner/2.png"];
  final tabTitles = ["为你推荐", "文章", "视频"];
  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: tabTitles.length, vsync: this);

    super.onInit();
  }
}
