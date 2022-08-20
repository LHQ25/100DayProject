import 'package:flutter/material.dart';
import 'dart:math' as math;

class TransformTest extends StatefulWidget {
  const TransformTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TransformTestState();
}

class _TransformTestState extends State<TransformTest> {
  /* 
  Transform可以在其子组件绘制时对其应用一些矩阵变换来实现一些特效
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
            body: Column(
              children: [
                const Text('Transform -> Matrix4是一个4D矩阵'),
                Container(
                  color: Colors.black,
                  child: Transform(
                    alignment: Alignment.topRight, // 相对于坐标系原点的对齐方式
                    transform: Matrix4.skewY(0.3), // 沿Y轴倾斜0.3弧度
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.deepOrange,
                      child: const Text('Apartment for rent!'),
                    ),
                  ),
                ),
                const Text('Transform -> 平移'),
                DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.red),
                    // 默认原点为左上角，左移20像素，向上平移5像素
                    child: Transform.translate(
                      offset: const Offset(-20, -5),
                      child: const Text('Hello World'),
                    )),
                const Text('Transform -> 旋转'),
                DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.red),
                    // 默认原点为左上角，左移20像素，向上平移5像素
                    child: Transform.rotate(
                      angle: math.pi / 2.0,
                      child: const Text('Hello World'),
                    )),
                const Text('Transform -> 缩放'),
                DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.red),
                    // 默认原点为左上角，左移20像素，向上平移5像素
                    child: Transform.scale(
                      scale: 1.5,
                      child: const Text('Hello World'),
                    )),
                const Text(
                  'Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段，所以无论对子组件应用何种变化，其占用空间的大小和在屏幕上的位置都是固定不变的，因为这些是在布局阶段就确定的',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const Text('RotatedBox'),
                // RotatedBox和Transform.rotate功能相似，它们都可以对子组件进行旋转变换，但是有一点不同：RotatedBox的变换是在layout阶段，会影响在子组件的位置和大小
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.red),
                        // 默认原点为左上角，左移20像素，向上平移5像素
                        child: Transform.scale(
                          scale: 1.5,
                          child: const RotatedBox(
                            quarterTurns: 1, // //旋转90度(1/4圈)
                            child: Text('Hello World'),
                          ),
                        )),
                    const Text(
                      "你好",
                      style: TextStyle(color: Colors.green, fontSize: 18.0),
                    )
                    // 由于RotatedBox是作用于layout阶段，所以子组件会旋转90度（而不只是绘制的内容），decoration会作用到子组件所占用的实际空间上，所以最终就是上图的效果
                  ],
                )
              ],
            )));
  }
}
