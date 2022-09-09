import 'package:flutter/material.dart';

class StreamBuilderTest extends StatefulWidget {
  const StreamBuilderTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StreamBuilderTestState();
}

class _StreamBuilderTestState extends State<StreamBuilderTest> {
/* 
和Future 不同的是，它可以接收多个异步操作的结果，它常用于会多次读取数据的异步任务场景，如网络内容下载、文件读写等。
StreamBuilder正是用于配合Stream来展示流上事件（数据）变化的UI组件
*/

  Stream<int> counter() {
    return Stream.periodic(Duration(seconds: 1), (i) {
      return i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FutureBuilder'),
        ),
        body: Center(
            // FutureBuilder会依赖一个Future，它会根据所依赖的Future的状态来动态构建自身
            child: StreamBuilder(
                stream: counter(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('No Stream');
                    case ConnectionState.waiting:
                      return const Text('等待数据...');
                    case ConnectionState.active:
                      return Text('active: ${snapshot.data}');
                    case ConnectionState.done:
                      return const Text('Stream 已关闭');
                  }
                })));
  }
}
