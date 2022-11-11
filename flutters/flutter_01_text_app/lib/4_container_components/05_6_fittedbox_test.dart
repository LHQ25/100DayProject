import 'package:flutter/material.dart';

class FittedBoxTest extends StatefulWidget {
  const FittedBoxTest({Key? key}) : super(key: key);

  @override
  State<FittedBoxTest> createState() => _FittedBoxTestState();
}

class _FittedBoxTestState extends State<FittedBoxTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FittedBox"),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 30.0),
            //   child: Row(children: [
            //     Text(
            //       '子组件大小超出了父组件大小时，如果不经过处理的话 Flutter 中就会显示一个溢出警告并在控制台打印错误日志' *
            //           30,
            //     )
            //   ]), //文本长度超出 Row 的最大宽度会溢出
            // ),
            Column(
              children: [
                const Text('BoxFit.none'),
                wContainer(BoxFit.none),
                const Text('BoxFit.fill'),
                wContainer(BoxFit.fill),
                const Text('BoxFit.fitWidth'),
                wContainer(BoxFit.fitWidth),
                const Text('BoxFit.fitHeight'),
                wContainer(BoxFit.fitHeight),
                const Text('BoxFit.contain'),
                wContainer(BoxFit.contain),
                const Text('BoxFit.cover'),
                wContainer(BoxFit.cover),
                const Text('BoxFit.scaleDown'),
                wContainer(BoxFit.scaleDown),
              ],
            )
          ],
        ),
      ),
    );
  }

  wContainer(BoxFit boxFit) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.redAccent,
      child: FittedBox(
        fit: boxFit,
        // 子容器超过父容器大小
        child: Container(
            width: 60, height: 70, color: Colors.blue.withOpacity(0.5)),
      ),
    );
  }
}
