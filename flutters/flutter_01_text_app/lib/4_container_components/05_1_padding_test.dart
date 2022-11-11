import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaddingTest extends StatefulWidget {
  const PaddingTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PaddingTestState();
}

class _PaddingTestState extends State<PaddingTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Padding'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //显式指定对齐方式为左对齐，排除对齐干扰
            children: const [
              //左边添加8像素补白
              Padding(
                padding: EdgeInsets.only(left: 8, right: 0, top: 0, bottom: 0),
                child: Text('左边添加8像素补白'),
              ),
              //上下各添加8像素补白
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('上下各添加8像素补白'),
              ),
              // 分别指定四个方向的补白
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Text('分别指定四个方向的补白'),
              )
            ],
          ),
        ));
  }
}
