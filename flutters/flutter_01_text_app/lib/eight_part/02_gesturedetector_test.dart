import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

class GestureDetectorTest extends StatefulWidget {
  const GestureDetectorTest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GestureDetectorTestState();
}

class _GestureDetectorTestState extends State<GestureDetectorTest> {
  String _operation = "No Gesture detected!"; //保存事件名

  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移

  double _width = 200.0; //通过修改图片宽度来达到缩放效果

  @override
  void initState() {
    /*
    GestureDetector是一个用于手势识别的功能性组件，我们通过它可以来识别各种手势。GestureDetector 内部封装了 Listener，用以识别语义化的手势
     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('EventBus'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 300,
              height: 110,
              child: Center(
                child: GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blue,
                    width: 200,
                    height: 100,
                    child: Text(_operation),
                  ),
                  onTap: () => updateText("点击"),
                  onDoubleTap: () => updateText("双击"),
                  onLongPress: () => updateText("长按"),
                ),
              ),
            ),

            /*
            拖动、滑动
            一次完整的手势过程是指用户手指按下到抬起的整个过程，期间，用户按下手指后可能会移动，也可能不会移动。
            GestureDetector对于拖动和滑动事件是没有区分的，他们本质上是一样的。
            GestureDetector会将要监听的组件的原点（左上角）作为本次手势的原点，当用户在监听的组件上按下手指时，手势识别就会开始
             */
            Container(
                padding: EdgeInsets.zero,
                width: 300,
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                        top: _top,
                        left: _left,
                        child: GestureDetector(
                          child: const CircleAvatar(
                            child: Text('A'),
                          ),
                          onPanDown: (e) {
                            //打印手指按下的位置(相对于屏幕)
                            print("用户手指按下：${e.globalPosition}");
                          },
                          // //手指滑动时会触发此回调
                          onPanUpdate: (e) {
                            // e.globalPosition：当用户按下时，此属性为用户按下的位置相对于屏幕（而非父组件）原点(左上角)的偏移。
                            // e.delta：当用户在屏幕上滑动时，会触发多次Update事件，delta指一次Update事件的滑动的偏移量。
                            // e.velocity：该属性代表用户抬起手指时的滑动速度(包含x、y两个轴的），示例中并没有处理手指抬起时的速度，常见的效果是根据用户抬起手指时的速度做一个减速动画。

                            //用户手指滑动时，更新偏移，重新构建
                            setState(() {
                              _left += e.delta.dx;
                              _top += e.delta.dy;
                              _left = max(0, _left);
                              _top = max(0, _top);
                            });
                          },
                          onPanEnd: (e) {
                            //打印滑动结束时在x、y轴上的速度
                            print(e.velocity);
                          },
                        )),
                  ],
                )),
            // 单一方向拖动
            // 在上例中，是可以朝任意方向拖动的，但是在很多场景，我们只需要沿一个方向来拖动，如一个垂直方向的列表，GestureDetector可以只识别特定方向的手势事件
            Container(
                padding: EdgeInsets.zero,
                width: 300,
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                        top: _top,
                        left: _left,
                        child: GestureDetector(
                          child: const CircleAvatar(
                            child: Text('A'),
                          ),
                          //垂直方向拖动事件  类似的还有其它手势
                          onHorizontalDragUpdate: (e) {
                            //用户手指滑动时，更新偏移，重新构建
                            setState(() {
                              _left += e.delta.dx;
                              _left = max(0, _left);
                            });
                          },
                        )),
                  ],
                )),
            Container(
                padding: EdgeInsets.zero,
                width: 300,
                height: 200,
                child: GestureDetector(
                  child: Image.network('https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201809%2F01%2F20180901214613_VXdRf.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1664865435&t=3cc8efef6f3737a7f5bfb7bebfe98775',
                    width: _width,),
                  //指定宽度，高度自适应
                  onScaleUpdate: (details) {
                    setState(() {
                      //缩放倍数在0.8到10倍之间
                      _width=200*details.scale.clamp(.8, 10.0);
                    });
                  },
                ))
          ],
        ));
  }

  void updateText(String txt) {
    setState(() {
      _operation = txt;
    });
  }
}
