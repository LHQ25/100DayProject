
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GestureRecognizerTest extends StatefulWidget {
  const GestureRecognizerTest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GestureRecognizerTestState();
}

class _GestureRecognizerTestState extends State<GestureRecognizerTest> {
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  bool _toggle = false; //变色开关

  @override
  void initState() {
    /*
    GestureDetector内部是使用一个或多个GestureRecognizer来识别各种手势的，
    而GestureRecognizer的作用就是通过Listener来将原始指针事件转换为语义手势，GestureDetector直接可以接收一个子widget。G
    estureRecognizer是一个抽象类，一种手势的识别器对应一个GestureRecognizer的子类，Flutter实现了丰富的手势识别器，我们可以直接使用。
     */

    _tapGestureRecognizer.onTap = () {
      print("点击");
      setState(() {
        _toggle = !_toggle;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GestureRecognizer'),
        ),
        body: Center(
          child: Text.rich(TextSpan(children: [
            const TextSpan(text: "你好世界"),
            TextSpan(
                text: '点我变色',
                style: TextStyle(
                  fontSize: 30,
                  color: _toggle ? Colors.blue : Colors.red,
                ),
                recognizer: _tapGestureRecognizer),
            const TextSpan(text: "你好世界"),
          ])),
        ));
  }
}
