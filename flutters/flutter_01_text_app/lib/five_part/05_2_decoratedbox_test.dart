import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecoratedBoxTest extends StatefulWidget {
  const DecoratedBoxTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DecoratedBoxTestState();
}

class _DecoratedBoxTestState extends State<DecoratedBoxTest> {
  /* 
    DecoratedBox可以在其子组件绘制前(或后)绘制一些装饰（Decoration），如背景、边框、渐变等
  */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('布局原理与约束 constraints '),
        ),
        body: Column(
          children: [
            const Text('BoxDecoration'),
            Padding(
              padding: const EdgeInsets.all(20),
              child: DecoratedBox(
                // decoration：代表将要绘制的装饰，它的类型为Decoration。Decoration是一个抽象类，它定义了一个接口 createBoxPainter()，子类的主要职责是需要通过实现它来创建一个画笔，该画笔用于绘制装饰。
                decoration: BoxDecoration(
                    color: Colors.black54,
                    // image: DecorationImage(image: Icon(Icons.person)),  //图片
                    // border: BorderSide(color: Colors.cyan, width: 1), //边框
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.orange.shade700]),
                    borderRadius: BorderRadius.circular(8), //圆角
                    // boxShadow: const [
                    //   BoxShadow(
                    //       offset: Offset(2, 2),
                    //       blurRadius: 3,
                    //       blurStyle: BlurStyle.normal)
                    // ], // //阴影,可以指定多个
                    // backgroundBlendMode: BlendMode.color,  //背景混合模式
                    shape: BoxShape.rectangle // //形状
                    ),
                // 决定在哪里绘制Decoration，它接收DecorationPosition的枚举类型
                position: DecorationPosition.background,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 18),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
