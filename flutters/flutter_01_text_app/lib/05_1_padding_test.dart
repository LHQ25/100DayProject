import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaddingTest extends StatefulWidget {
  const PaddingTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PaddingTestState();
}

class _PaddingTestState extends State<PaddingTest> {
  /* 
    通过Stack和Positioned，我们可以指定一个或多个子元素相对于父元素各个边的精确偏移，并且可以重叠。但如果我们只想简单的调整一个子元素在父元素中的位置的话，使用Align组件会更简单一些
  */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('布局原理与约束 constraints '),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, //显式指定对齐方式为左对齐，排除对齐干扰
                children: const [
                  //左边添加8像素补白
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('hello world'),
                  ),
                  //上下各添加8像素补白
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('hello world'),
                  ),
                  // 分别指定四个方向的补白
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text('hello world'),
                  )
                ],
              ),
            )));
  }
}
