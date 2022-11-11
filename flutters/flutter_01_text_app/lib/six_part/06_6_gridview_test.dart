import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GridViewTest extends StatefulWidget {
  const GridViewTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _GridViewTestState();
}

class _GridViewTestState extends State<GridViewTest> {
  List<IconData> _icons = []; //保存Icon数据

  //模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(const Duration(milliseconds: 200)).then((e) {
      setState(() {
        _icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast,
        ]);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _retrieveIcons();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList'),
      ),
      // -> SliverGridDelegateWithFixedCrossAxisCount
      // body: GridView(
      //     // 该子类实现了一个横轴为固定数量子元素的layout算法
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount:
      //           3, // 横轴子元素的数量。此属性值确定后子元素在横轴的长度就确定了，即ViewPort横轴长度除以crossAxisCount的商。
      //       mainAxisSpacing: 8, // 主轴方向的间距。
      //       crossAxisSpacing: 8, // 横轴方向子元素的间距。
      //       // 子元素的大小是通过crossAxisCount和childAspectRatio两个参数共同决定的。注意，这里的子元素指的是子组件的最大显示空间，注意确保子组件的实际大小不要超出子元素的空间
      //       childAspectRatio:
      //           1, // 子元素在横轴长度和主轴长度的比例。由于crossAxisCount指定后，子元素横轴长度就确定了，然后通过此参数值就可以确定子元素在主轴的长度。
      //       // 主轴上每个图块的范围。 如果提供，它将定义主轴中每个图块所采用的逻辑像素。如果为 null，则改为使用 [childAspectRatio]。
      //       mainAxisExtent: null,
      //     ),
      //     children: const <Widget>[
      //       Icon(Icons.ac_unit),
      //       Icon(Icons.airport_shuttle),
      //       Icon(Icons.all_inclusive),
      //       Icon(Icons.beach_access),
      //       Icon(Icons.cake),
      //       Icon(Icons.free_breakfast)
      //     ])

      // -> SliverGridDelegateWithMaxCrossAxisExtent
      // body: GridView(
      //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //       maxCrossAxisExtent: 120,  // maxCrossAxisExtent为子元素在横轴上的最大长度，之所以是“最大”长度，是因为横轴方向每个子元素的长度仍然是等分的
      //       childAspectRatio: 2,  // //宽高比为2
      //     ),
      //     children: const <Widget>[
      //       Icon(Icons.ac_unit),
      //       Icon(Icons.airport_shuttle),
      //       Icon(Icons.all_inclusive),
      //       Icon(Icons.beach_access),
      //       Icon(Icons.cake),
      //       Icon(Icons.free_breakfast)
      //     ])

      // -> GridView.count  等效于使用 SliverGridDelegateWithFixedCrossAxisCount。 其实也是内部的实现
      // body: GridView.count(
      //     crossAxisCount: 3,
      //     childAspectRatio: 1.0,
      //     children: const <Widget>[
      //       Icon(Icons.ac_unit),
      //       Icon(Icons.airport_shuttle),
      //       Icon(Icons.all_inclusive),
      //       Icon(Icons.beach_access),
      //       Icon(Icons.cake),
      //       Icon(Icons.free_breakfast)
      //     ])

      // -> GridView.extent  等效于使用 SliverGridDelegateWithMaxCrossAxisExtent 其实也是内部的实现
      // body: GridView.extent(
      //     maxCrossAxisExtent: 120,
      //     childAspectRatio: 2.0,
      //     children: const <Widget>[
      //       Icon(Icons.ac_unit),
      //       Icon(Icons.airport_shuttle),
      //       Icon(Icons.all_inclusive),
      //       Icon(Icons.beach_access),
      //       Icon(Icons.cake),
      //       Icon(Icons.free_breakfast)
      //     ])

      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.0),
        itemBuilder: (context, index) {
          if (index == _icons.length - 1 && _icons.length < 200) {
            _retrieveIcons();
          }
          return Icon(_icons[index]);
        },
        itemCount: _icons.length,
      ),
    ));
  }
}
