import 'package:flutter/material.dart';

class ValueListenanleBuilderTest extends StatefulWidget {
  const ValueListenanleBuilderTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ValueListenanleBuilderTestState();
}

class _ValueListenanleBuilderTestState
    extends State<ValueListenanleBuilderTest> {
/* 
InheritedWidget 提供一种在 widget 树中从上到下共享数据的方式，但是也有很多场景数据流向并非从上到下，比如从下到上或者横向等。
为了解决这个问题，Flutter 提供了一个 ValueListenableBuilder 组件，它的功能是监听一个数据源，如果数据源发生变化，则会重新执行其 builde
*/

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  static const double textScaleFactor = 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FutureBuilder'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _counter.value += 1,
        ),
        body: Center(
            // FutureBuilder会依赖一个Future，它会根据所依赖的Future的状态来动态构建自身
            child: ValueListenableBuilder(
          valueListenable: _counter, //类型为 ValueListenable<T>，表示一个可监听的数据源
          builder: (context, value, child) {
            // 数据源发生变化通知时，会重新调用 builder 重新 build 子组件树
            return Row(
              children: [
                child!,
                Text('$value 次', textScaleFactor: textScaleFactor),
              ],
            );
          },
          // 当子组件不依赖变化的数据，且子组件收件开销比较大时，指定 child 属性来缓存子组件非常有用
          child: const Text('点击了 ',
              textScaleFactor:
                  textScaleFactor), // builder 中每次都会重新构建整个子组件树，如果子组件树中有一些不变的部分，可以传递给child，child 会作为builder的第三个参数传递给 builder，通过这种方式就可以实现组件缓存，原理和AnimatedBuilder 第三个 child 相同
        )));
  }
}
