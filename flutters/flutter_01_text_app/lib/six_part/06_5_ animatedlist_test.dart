import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnimatedListTest extends StatefulWidget {
  const AnimatedListTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AnimatedListTestState();
}

class _AnimatedListTestState extends State<AnimatedListTest> {
  /* 
    AnimatedList 和 ListView 的功能大体相似，不同的是， AnimatedList 可以在列表中插入或删除节点时执行一个动画，在需要添加或删除列表项的场景中会提高用户体验。
    AnimatedList 是一个 StatefulWidget，它对应的 State 类型为 AnimatedListState，添加和删除元素的方法位于 AnimatedListState 中
  */

  var data = <String>[];
  int counter = 5;

  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    for (var i = 0; i < counter; i++) {
      data.add('${i + 1}');
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedList'),
        ),
        body: Stack(
          children: [
            AnimatedList(
              key: globalKey,
              itemBuilder: (ctx, index, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: buildItem(context, index),
                );
              },
              initialItemCount: counter,
            ),
            buildAddButton(),
          ],
        ));
  }

  Widget buildAddButton() {
    return Positioned(
        left: 30,
        top: 30,
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // 添加一个列表项
            data.add('${++counter}');
            // 告诉列表项有新添加的列表项
            globalKey.currentState?.insertItem(data.length - 1);
            debugPrint("添加 $counter");
          },
        ));
  }

  Widget buildItem(context, index) {
    String char = data[index];
    return ListTile(
      key: ValueKey(char),
      title: Text(char),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(context, index),
      ),
    );
  }

  void onDelete(context, index) {
    // 数据是单独在 data 中维护的，调用 AnimatedListState 的插入和移除方法知识相当于一个通知：在什么位置执行插入或移除动画，仍然是数据驱动的（响应式并非命令式）。
    setState(() {
      globalKey.currentState!.removeItem(
        index,
        (context, animation) {
          // 删除过程执行的是反向动画，animation.value 会从1变为0
          var item = buildItem(context, index);
          debugPrint('删除 ${data[index]}');
          data.removeAt(index);
          // 删除动画是一个合成动画：渐隐 + 缩小列表项告诉
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              //让透明度变化的更快一些
              curve: const Interval(0.5, 1.0),
            ),
            // 不断缩小列表项的高度
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: 0.0,
              child: item,
            ),
          );
        },
        duration: const Duration(milliseconds: 200), // 动画时间为 200 ms
      );
    });
  }
}
