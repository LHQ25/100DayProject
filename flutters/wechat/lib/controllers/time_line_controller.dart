import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeLineControlle extends GetxController
    with GetSingleTickerProviderStateMixin {
  OverlayState? overlayState;

  // 更多按钮位置 offset
  // var btnOffset = Offset.zero.obs;
  RxDouble w = 0.0.obs;
  RxDouble h = 0.0.obs;

  RxDouble opacity = 0.0.obs;

  // 动画控制器
  late AnimationController animationController;
  // 动画 tween
  late Animation<double> sizeTween;

  late ScrollController scrollController;

  OverlayState buildOverLayer(BuildContext context) {
    return overlayState ??= Overlay.of(context);
  }

  // 获取组件屏幕位置 offset
  void getOffset(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final Offset offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    w.value = offset.dx;
    h.value = offset.dy;
  }

  @override
  void onInit() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    sizeTween = Tween(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    scrollController = ScrollController();
    scrollController.addListener(() {
      print(0);
      double o = 0;
      if (scrollController.offset > 300) {
        o = 1;
      } else {
        o = max(0.1, (scrollController.offset - 200) / 200.0);
      }

      opacity.value = o;
      // update();
    });

    super.onInit();
  }

  @override
  void onClose() {
    overlayState?.dispose();
    animationController.dispose();
    super.onClose();
  }
}
