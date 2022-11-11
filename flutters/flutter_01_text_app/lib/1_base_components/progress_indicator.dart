import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProgressIndicatorTest extends StatefulWidget {
  const ProgressIndicatorTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProgressIndicatorTestState();
}

class _ProgressIndicatorTestState extends State<ProgressIndicatorTest>
    with SingleTickerProviderStateMixin {
  /* 
    Material 组件库中提供了两种进度指示器：LinearProgressIndicator和CircularProgressIndicator，它们都可以同时用于精确的进度指示和模糊的进度指示。精确进度通常用于任务进度可以计算和预估的情况，比如文件下载；而模糊进度则用户任务进度无法准确获得的情况，如下拉刷新，数据提交等。
  */

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync:
            this, // //注意State类需要混入SingleTickerProviderStateMixin（提供动画帧计时/触发器）
        duration: const Duration(seconds: 3));

    _animationController.forward();
    _animationController.addListener(() => setState(() {}));

    // 自定义进度指示器样式
    // 定制进度指示器风格样式，可以通过CustomPainter Widget 来自定义绘制逻辑，实际上LinearProgressIndicator和CircularProgressIndicator也正是通过CustomPainter来实现外观绘制的。关于CustomPainter，我们将在后面“自定义Widget”一章中详细介绍。

    // flutter_spinkit 包提供了多种风格的模糊进度指示器
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('进度指示器'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              const LinearProgressIndicator(
                value: .5,
                backgroundColor: Colors.grey,
                color: Colors.cyan,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                minHeight: 5,
                semanticsLabel: 'semanticsLabel',
                semanticsValue: '100',
              ),
              const CircularProgressIndicator(
                value: .5,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                strokeWidth: 5,
                semanticsLabel: 'semanticsLabel',
                semanticsValue: '0.5',
              ),
              const Text(' 线性进度条高度指定为3'),
              const SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  value: .5,
                  backgroundColor: Colors.grey,
                  color: Colors.cyan,
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  minHeight: 5,
                  semanticsLabel: 'semanticsLabel',
                  semanticsValue: '100',
                ),
              ),
              // 圆形进度条直径指定为100
              const SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .7,
                ),
              ),
              // 宽高不等, 显示为椭圆
              const SizedBox(
                height: 100,
                width: 130,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .7,
                ),
              ),
              Text('进度色动画'),
              Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: ColorTween(begin: Colors.grey, end: Colors.blue)
                      .animate(_animationController), // 从灰色变成蓝色
                  value: _animationController.value,
                ),
              )
            ])));
  }
}
