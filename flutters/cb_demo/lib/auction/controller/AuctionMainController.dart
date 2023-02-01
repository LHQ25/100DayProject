import 'dart:math';

import 'package:cb_demo/login/model/login.dart';
import 'package:cb_demo/login/model/login_api.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class AuctionMainController extends GetxController with GetSingleTickerProviderStateMixin {
  var navAlpha = RxDouble(0);
  final images = ["assets/images/banner/1.png", "assets/images/banner/2.png"];
  final tabTitles = ["为你推荐", "陶瓷玉器", "艺术品", "书画篆刻", "玉翠珠宝"];
  late ScrollController scrollController;
  late TabController tabController;
  var isVer = false.obs;
  final client = LoginClient();

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      double offset = scrollController.offset;
      navAlpha.value = min(1, max(0, (offset / 300)));
    });

    tabController = TabController(length: tabTitles.length, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    var response = client.getTasks(LoginRequest(
        scene: "phone",
        client: "2",
        phone: "18637683269",
        token: "",
        cancelClose: false,
        smsCode: "424588",
        YDtoken: ""));
    response.then((value) => debugPrint(value.message)).catchError((
      err,
    ) {
        debugPrint("--1--> $err");
    });
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
