import 'package:flutter/material.dart';

class ContainerTest extends StatefulWidget {
  const ContainerTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ContainerTestState();
}

class _ContainerTestState extends State<ContainerTest> {
  /* 
  Container是一个组合类容器，它本身不对应具体的RenderObject，它是DecoratedBox、ConstrainedBox、Transform、Padding、Align等组件组合的一个多功能容器，所以我们只需通过一个Container组件可以实现同时需要装饰、变换、限制的场景

    容器的大小可以通过width、height属性来指定，也可以通过constraints来指定；如果它们同时存在时，width、height优先。实际上Container内部会根据width、height来生成一个constraints。
    color和decoration是互斥的，如果同时设置它们则会报错！实际上，当指定color时，Container内会自动创建一个decoration
  */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('布局原理与约束 constraints '),
        ),
        body: Column(
          children: [
            const Text('Transform -> Matrix4是一个4D矩阵'),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              // color: Colors.black,  // 互斥
              decoration: const BoxDecoration(
                  gradient: RadialGradient(
                      colors: [Colors.red, Colors.orange],
                      center: Alignment.topLeft,
                      radius: .98),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4.0)
                  ]),
              // foregroundDecoration: ,
              // width: ,
              // height: ,
              constraints:
                  const BoxConstraints.tightFor(width: 200, height: 150),
              margin: const EdgeInsets.only(top: 20),
              child: Transform(
                alignment: Alignment.center, // 卡片内文字居中
                transform: Matrix4.rotationZ(.2), // 卡片倾斜变换
                child: const Text(
                  //卡片文字
                  "5.20",
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                ),
              ),
            ),
          ],
        ));
  }
}
