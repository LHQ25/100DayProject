import 'package:flutter/material.dart';

class ClipTest extends StatefulWidget {
  const ClipTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ClipTestState();
}

class _ClipTestState extends State<ClipTest> {
  /* 
  剪裁类组件
    Flutter中提供了一些剪裁组件，用于对组件进行剪裁。

    剪裁Widget	默认行为
    ClipOval	子组件为正方形时剪裁成内贴圆形；为矩形时，剪裁成内贴椭圆
    ClipRRect	将子组件剪裁为圆角矩形
    ClipRect	默认剪裁掉子组件布局空间之外的绘制内容（溢出部分剪裁）
    ClipPath	按照自定义的路径剪裁
  */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 头像
    Widget avatar = Image.asset(
      "images/head.png",
      width: 60.0,
    );

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Clip'),
            ),
            body: Center(
              child: Column(
                children: [
                  const Text('Clip -> 不剪裁'),
                  avatar,
                  const Text('Clip -> 圆形'),
                  ClipOval(
                    child: avatar,
                  ),
                  const Text('Clip -> 圆矩形'),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: avatar,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        widthFactor: .5, //宽度设为原来宽度一半，另一半会溢出
                        child: avatar,
                      ),
                      const Text(
                        "你好世界",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRect(
                        //将溢出部分剪裁
                        child: Align(
                          alignment: Alignment.topLeft,
                          widthFactor: .5, //宽度设为原来宽度一半，另一半会溢出
                          child: avatar,
                        ),
                      ),
                      const Text("你好世界", style: TextStyle(color: Colors.green))
                    ],
                  ),
                  const Text("自定义裁剪（CustomClipper）",
                      style: TextStyle(color: Colors.green)),
                  DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.red),
                    child: ClipRect(
                        clipper: MyClipper(), //使用自定义的clipper
                        child: avatar),
                  ),

                  // ClipPath 可以按照自定义的路径实现剪裁，它需要自定义一个CustomClipper<Path> 类型的 Clipper，定义方式和 MyClipper 类似，只不过 getClip 需要返回一个 Path
                ],
              ),
            )));
  }
}

class MyClipper extends CustomClipper<Rect> {
  // getClip()是用于获取剪裁区域的接口，由于图片大小是60×60，我们返回剪裁区域为Rect.fromLTWH(10.0, 15.0, 40.0, 30.0)，即图片中部40×30像素的范围。
  @override
  Rect getClip(Size size) => const Rect.fromLTWH(10, 15, 40, 30);

  // shouldReclip() 接口决定是否重新剪裁。如果在应用中，剪裁区域始终不会发生变化时应该返回false，这样就不会触发重新剪裁，避免不必要的性能开销。如果剪裁区域会发生变化（比如在对剪裁区域执行一个动画），那么变化后应该返回true来重新执行剪裁。
  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
