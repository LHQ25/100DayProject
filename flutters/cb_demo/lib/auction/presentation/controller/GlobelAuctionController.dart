import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GlobelAuctionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var tabs = ["1", "2"];

  late TabController tab_controller;

  @override
  void onInit() {
    tab_controller = TabController(length: tabs.length, vsync: this);

    super.onInit();
  }
}
