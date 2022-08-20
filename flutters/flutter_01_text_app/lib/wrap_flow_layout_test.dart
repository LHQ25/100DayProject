import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WrapFlowLayoutTest extends StatefulWidget {
  const WrapFlowLayoutTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WrapFlowLayoutTestState();
}

class _WrapFlowLayoutTestState extends State<WrapFlowLayoutTest> {
  /* 
    Row 和 Colum 时，如果子 widget 超出屏幕范围，则会报溢出错误

    把超出屏幕显示范围会自动折行的布局称为流式布局。Flutter中通过Wrap和Flow来支持流式布局，
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    spacing: 8, // 主轴(水平)方向间距
                    runAlignment: WrapAlignment.start,
                    runSpacing: 4, // 纵轴（垂直）方向间距
                    crossAxisAlignment: WrapCrossAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: const [
                      Chip(
                        avatar: CircleAvatar(
                            backgroundColor: Colors.blue, child: Text('A')),
                        label: Text('Hamilton'),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                            backgroundColor: Colors.blue, child: Text('M')),
                        label: Text('Lafayette'),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                            backgroundColor: Colors.blue, child: Text('H')),
                        label: Text('Mulligan'),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                            backgroundColor: Colors.blue, child: Text('J')),
                        label: Text('Laurens'),
                      ),
                    ],
                  ),
                  /* 
                  Flow
                  一般很少会使用Flow，因为其过于复杂，需要自己实现子 widget 的位置转换，在很多场景下首先要考虑的是Wrap是否满足需求。Flow主要用于一些需要自定义布局策略或性能要求较高(如动画中)的场景。Flow有如下优点：

                    性能好；Flow是一个对子组件尺寸以及位置调整非常高效的控件，Flow用转换矩阵在对子组件进行位置调整的时候进行了优化：在Flow定位过后，如果子组件的尺寸或者位置发生了变化，在FlowDelegate中的paintChildren()方法中调用context.paintChild 进行重绘，而context.paintChild在重绘时使用了转换矩阵，并没有实际调整组件位置。
                    灵活；由于我们需要自己实现FlowDelegate的paintChildren()方法，所以我们需要自己计算每一个组件的位置，因此，可以自定义布局策略。
                  缺点：

                    使用复杂。
                    Flow 不能自适应子组件大小，必须通过指定父容器大小或实现TestFlowDelegate的getSize返回固定大小。
                  */
                  Flow(
                    delegate:
                        TestFlowDelegate(margin: const EdgeInsets.all(10)),
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 80.0,
                        height: 80.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 80.0,
                        height: 80.0,
                        color: Colors.blue,
                      ),
                      Container(
                        width: 80.0,
                        height: 80.0,
                        color: Colors.yellow,
                      ),
                      Container(
                        width: 80.0,
                        height: 80.0,
                        color: Colors.brown,
                      ),
                      Container(
                        width: 80.0,
                        height: 80.0,
                        color: Colors.purple,
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin;
  double width = 0;
  double height = 0;
  TestFlowDelegate({this.margin = EdgeInsets.zero});

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i)!.width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i)!.height + margin.top + margin.bottom;
        //绘制子widget(有优化)
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + margin.left + margin.right;
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // 指定Flow的大小，简单起见我们让宽度竟可能大，但高度指定为200，
    // 实际开发中我们需要根据子元素所占用的具体宽高来设置Flow大小
    return Size(double.infinity, 200.0);
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
