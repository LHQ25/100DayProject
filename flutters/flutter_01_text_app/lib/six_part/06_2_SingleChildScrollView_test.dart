import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SingleChildScrollViewTest extends StatefulWidget {
  const SingleChildScrollViewTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SingleChildScrollViewTestState();
}

class _SingleChildScrollViewTestState extends State<SingleChildScrollViewTest> {
  /* 
  SingleChildScrollView类似于Android中的ScrollView，它只能接收一个子组件

  重点primary属性：它表示是否使用 widget 树中默认的PrimaryScrollController（MaterialApp 组件树中已经默认包含一个 PrimaryScrollController 了）；当滑动方向为垂直方向（scrollDirection值为Axis.vertical）并且没有指定controller时，primary默认为true。

  需要注意的是，通常SingleChildScrollView只应在期望的内容不会超过屏幕太多时使用，这是因为SingleChildScrollView不支持基于 Sliver 的延迟加载模型，所以如果预计视口可能包含超出屏幕尺寸太多的内容时，那么使用SingleChildScrollView将会非常昂贵（性能差），此时应该使用一些支持Sliver延迟加载的可滚动组件，如ListView
  */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scaffold(
        appBar: AppBar(
          title: const Text('SingleChildScrollView'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: false,
          padding: const EdgeInsets.all(8),
          primary: true,
          dragStartBehavior: DragStartBehavior.start,
          clipBehavior: Clip.hardEdge,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          // physics: null,
          // controller: null,
          child: Column(
            children: [
              const Text(
                  "通常SingleChildScrollView只应在期望的内容不会超过屏幕太多时使用，这是因为SingleChildScrollView不支持基于 Sliver 的延迟加载模型，所以如果预计视口可能包含超出屏幕尺寸太多的内容时，那么使用SingleChildScrollView将会非常昂贵（性能差），此时应该使用一些支持Sliver延迟加载的可滚动组件，如ListView"),
              Column(
                //动态创建一个List<Widget>
                children: str
                    .split("")
                    //每一个字母都用一个Text显示,字体为原来的两倍
                    .map((c) => Text(
                          c,
                          textScaleFactor: 2.0,
                        ))
                    .toList(),
              )
            ],
          ),
        ));
  }
}
