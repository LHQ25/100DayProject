import 'package:flutter/material.dart';

class AfterLayoutTest extends StatefulWidget {
  const AfterLayoutTest({Key? key}) : super(key: key);

  @override
  State<AfterLayoutTest> createState() => _AfterLayoutTestState();
}

class _AfterLayoutTestState extends State<AfterLayoutTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AfterLayout"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Text(
                "Flutter 是响应式UI框架，而命令式UI框架最大的不同就是：大多数情况下开发者只需要关注数据的变化，数据变化后框架会自动重新构建UI而不需要开发者手动去操作每一个组件，所以我们会发现 Widget 会被定义为不可变的（immutable），并且没有提供任何操作组件的 API，因此如果我们想在 Flutter 中获取某个组件的大小和位置就会很困难，当然大多数情况下不会有这个需求，但总有一些场景会需要，而在命令式UI框架中是不会存在这个问题的。"),
            Text(
                "AfterLayout 组件，它可以在子组件布局完成后执行一个回调，并同时将 RenderObject 对象作为参数传递"),
          ],
        ),
      ),
    );
  }
}
