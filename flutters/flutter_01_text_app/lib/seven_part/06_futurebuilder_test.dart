import 'package:flutter/material.dart';

class FutureBuilderTest extends StatefulWidget {
  const FutureBuilderTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FutureBuilderTestState();
}

class _FutureBuilderTestState extends State<FutureBuilderTest> {
/* 
我们会依赖一些异步数据来动态更新UI，比如在打开一个页面时我们需要先从互联网上获取数据，在获取数据的过程中我们显示一个加载框，等获取到数据时我们再渲染页面；
又比如我们想展示Stream（比如文件流、互联网数据接收流）的进度。
通过 StatefulWidget 我们完全可以实现上述这些功能。
但由于在实际开发中依赖异步数据更新UI的这种场景非常常见，因此Flutter专门提供了FutureBuilder和StreamBuilder两个组件来快速实现这种功能
*/

  Future<String> mockNetWorkData() async {
    return Future.delayed(const Duration(seconds: 2), () => '网络数据');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FutureBuilder'),
        ),
        body: Center(
          // FutureBuilder会依赖一个Future，它会根据所依赖的Future的状态来动态构建自身
          child: FutureBuilder(
              future: mockNetWorkData(), //FutureBuilder依赖的Future，通常是一个异步耗时任务。
              initialData: null, // 初始数据，用户设置默认数据
              builder: ((context, snapshot) {
                // Widget构建器；该构建器会在Future执行的不同阶段被多次调用
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('错误');
                  }
                  return Text('显示数据 ${snapshot.data}');
                } else {
                  // 请求未结束，显示loading
                  return const CircularProgressIndicator();
                }
              })),
        ));
  }
}
