import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StackPositionedLayoutTest extends StatefulWidget {
  const StackPositionedLayoutTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StackPositionedLayoutTestState();
}

class _StackPositionedLayoutTestState extends State<StackPositionedLayoutTest> {
  /* 
    层叠布局（Stack、Positioned）
    层叠布局和 Web 中的绝对定位、Android 中的 Frame 布局是相似的，子组件可以根据距父容器四个角的位置来确定自身的位置。层叠布局允许子组件按照代码中声明的顺序堆叠起来。Flutter中使用Stack和Positioned这两个组件来配合实现绝对定位。Stack允许子组件堆叠，而Positioned用于根据Stack的四个角来确定子组件的位置。
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
            body: //通过ConstrainedBox来确保Stack占满屏幕
                ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Stack(
                alignment: Alignment
                    .center, // 此参数决定如何去对齐没有定位（没有使用Positioned）或部分定位的子组件。所谓部分定位，在这里特指没有在某一个轴上定位：left、right为横轴，top、bottom为纵轴，只要包含某个轴上的一个定位属性就算在该轴上有定位。
                // textDirection: , // 则alignment的start代表左，end代表右，即从左往右的顺序；textDirection的值为TextDirection.rtl，则alignment的start代表右，end代表左，即从右往左的顺序。
                fit: StackFit
                    .expand, // 此参数用于确定没有定位的子组件如何去适应Stack的大小。StackFit.loose表示使用子组件的大小，StackFit.expand表示扩伸到Stack的大小。
                clipBehavior: Clip
                    .none, // 此属性决定对超出Stack显示空间的部分如何剪裁，Clip枚举类中定义了剪裁的方式，Clip.hardEdge 表示直接剪裁，不应用抗锯齿
                children: <Widget>[
                  // 由于第二个子文本组件没有定位，所以fit属性会对它起作用，就会占满Stack。由于Stack子元素是堆叠的，所以第一个子文本组件被第二个遮住了，而第三个在最上层，所以可以正常显示
                  Container(
                    child: Text("Hello world",
                        style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                  ),
                  const Positioned(
                    left: 18.0,
                    child: Text("I am Jack"),
                  ),
                  const Positioned(
                    top: 18.0,
                    child: Text("Your friend"),
                  )
                ],
              ),
            )));
  }
}
