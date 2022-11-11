import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RowColoumTest extends StatefulWidget {
  const RowColoumTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RowColoumTestState();
}

class _RowColoumTestState extends State<RowColoumTest> {
  /* 
    所谓线性布局，即指沿水平或垂直方向排列子组件。Flutter 中通过Row和Column来实现线性布局，类似于Android 中的LinearLayout控件。Row和Column都继承自Flex

    主轴和纵轴
    对于线性布局，有主轴和纵轴之分，如果布局是沿水平方向，那么主轴就是指水平方向，而纵轴即垂直方向；如果布局沿垂直方向，那么主轴就是指垂直方向，而纵轴就是水平方向。在线性布局中，有两个定义对齐方式的枚举类MainAxisAlignment和CrossAxisAlignment，分别代表主轴对齐和纵轴对齐。
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
              //测试Row对齐方式，排除Column默认居中对齐的干扰
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(" hello world "),
                    Text(" I am Jack "),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(" hello world "),
                    Text(" I am Jack "),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.rtl,
                  children: const <Widget>[
                    Text(" hello world "),
                    Text(" I am Jack "),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalDirection: VerticalDirection.up,
                  children: const <Widget>[
                    Text(
                      " hello world ",
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Text(" I am Jack "),
                  ],
                ),
                const Text('Column'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Text("hi"),
                    Text("world"),
                  ],
                ),
                //  特殊情况
                // 如果Row里面嵌套Row，或者Column里面再嵌套Column，那么只有最外面的Row或Column会占用尽可能大的空间，里面Row或Column所占用的空间为实际大小

                // 如果要让里面的Column占满外部Column，可以使用Expanded 组件
                // Expanded(child: )
                Container(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max, //有效，外层Colum高度为整个屏幕
                      children: <Widget>[
                        Container(
                          color: Colors.red,
                          child: Column(
                            mainAxisSize: MainAxisSize.max, //无效，内层Colum高度为实际高度
                            children: const <Widget>[
                              Text("hello world "),
                              Text("I am Jack "),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ))));
  }
}
