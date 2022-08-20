import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlignCenterLayoutTest extends StatefulWidget {
  const AlignCenterLayoutTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AlignCenterLayoutTestState();
}

class _AlignCenterLayoutTestState extends State<AlignCenterLayoutTest> {
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Alignment'),
                Container(
                  height: 120,
                  width: 120,
                  color: Colors.blue.shade50,
                  child: const Align(
                    alignment: Alignment
                        .topRight, // 需要一个AlignmentGeometry类型的值，表示子组件在父组件中的起始位置。AlignmentGeometry 是一个抽象类，它有两个常用的子类：Alignment和 FractionalOffset
                    widthFactor:
                        1.5, // 用于确定Align 组件本身宽高的属性；它们是两个缩放因子，会分别乘以子元素的宽、高，最终的结果就是Align 组件的宽高。如果值为null，则组件的宽高将会占用尽可能多的空间。
                    heightFactor: 1.5,
                    child: FlutterLogo(
                      size: 60,
                    ),
                  ),
                ),
                // Alignment继承自AlignmentGeometry，表示矩形内的一个点，他有两个属性x、y，分别表示在水平和垂直方向的偏移
                const Text('Alignment'),
                Container(
                  height: 120,
                  width: 120,
                  color: Colors.blue.shade50,
                  child: const Align(
                    alignment: Alignment(1,
                        0), // Alignment Widget会以矩形的中心点作为坐标原点，即Alignment(0.0, 0.0) 。x、y的值从-1到1分别代表矩形左边到右边的距离和顶部到底边的距离，因此2个水平（或垂直）单位则等于矩形的宽（或高），如Alignment(-1.0, -1.0) 代表矩形的左侧顶点，而Alignment(1.0, 1.0)代表右侧底部终点，而Alignment(1.0, -1.0) 则正是右侧顶点，即Alignment.topRight。为了使用方便，矩形的原点、四个顶点，以及四条边的终点在Alignment类中都已经定义为了静态常量。
                    child: FlutterLogo(
                      size: 60,
                    ),
                  ),
                ),
                const Text('FractionalOffset'),
                // FractionalOffset 继承自 Alignment ，它和 Alignment 唯一的区别就是坐标原点不同！FractionalOffset 的坐标原点为矩形的左侧顶点，这和布局系统的一致
                Container(
                  height: 120.0,
                  width: 120.0,
                  color: Colors.blue[50],
                  child: const Align(
                    alignment: FractionalOffset(0.2, 0.6),
                    child: FlutterLogo(
                      size: 60,
                    ),
                  ),
                ),
                /*
                Align和Stack对比
                可以看到，Align和Stack/Positioned都可以用于指定子元素相对于父元素的偏移，但它们还是有两个主要区别：

                  定位参考系统不同；Stack/Positioned定位的的参考系可以是父容器矩形的四个顶点；而Align则需要先通过alignment 参数来确定坐标原点，不同的alignment会对应不同原点，最终的偏移是需要通过alignment的转换公式来计算出。
                  Stack可以有多个子元素，并且子元素可以堆叠，而Align只能有一个子元素，不存在堆叠。
                */
                const Text('Center'),
                // 可以看到Center继承自Align，它比Align只少了一个alignment 参数；由于Align的构造函数中alignment 值为Alignment.center，所以，我们可以认为Center组件其实是对齐方式确定（Alignment.center）了的Align
                const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Text('xxx'),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Text('xxx'),
                  ),
                )
              ],
            )));
  }
}
