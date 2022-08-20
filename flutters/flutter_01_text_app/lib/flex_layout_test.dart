import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlexLayoutTest extends StatefulWidget {
  const FlexLayoutTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FlexLayoutTestState();
}

class _FlexLayoutTestState extends State<FlexLayoutTest> {
  /* 
    弹性布局允许子组件按照一定比例来分配父容器空间。弹性布局的概念在其他UI系统中也都存在，如 H5 中的弹性盒子布局，Android中 的FlexboxLayout等。Flutter 中的弹性布局主要通过Flex和Expanded来配合实现

    Flex组件可以沿着水平或垂直方向排列子组件，如果你知道主轴方向，使用Row或Column会方便一些，因为Row和Column都继承自Flex，参数基本相同，所以能使用Flex的地方基本上都可以使用Row或Column。Flex本身功能是很强大的，它也可以和Expanded组件配合实现弹性布局
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
                //Flex的两个子widget按1：2来占据水平空间
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 30.0,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 30.0,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 100,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 30.0,
                            color: Colors.red,
                          ),
                        ),
                        // Spacer的功能是占用指定比例的空间，实际上它只是Expanded的一个包装类
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 30.0,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
