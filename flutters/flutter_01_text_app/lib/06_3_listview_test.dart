import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListViewTest extends StatefulWidget {
  const ListViewTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ListViewTestState();
}

class _ListViewTestState extends State<ListViewTest> {
  /* 
  ListView是最常用的可滚动组件之一，它可以沿一个方向线性排布所有子组件，并且它也支持列表项懒加载
  */

  static const loading = '##loading##';
  var _world = <String>[loading];

  @override
  void initState() {
    super.initState();

    _retrievData();
  }

  void _retrievData() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        _world.insertAll(
          _world.length - 1,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //下划线widget预定义以供复用。
    Widget divider1 = const Divider(
      color: Colors.blue,
    );
    Widget divider2 = const Divider(color: Colors.green);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('SingleChildScrollView'),
            ),
            // body: ListView(
            //   scrollDirection: Axis.vertical,
            //   reverse: false,
            // controller: null,  滚动控制
            // primary: true,
            // physics: null,   // 物理效果
            // shrinkWrap: true, // 该属性表示是否根据子组件的总长度来设置ListView的长度，默认值为false 。默认情况下，ListView会在滚动方向尽可能多的占用空间。当ListView在一个无边界(滚动方向上)的容器中时，shrinkWrap必须为true。
            // padding: const EdgeInsets.all(8),

            //该参数如果不为null，则会强制children的“长度”为itemExtent的值；这里的“长度”是指滚动方向上子组件的长度，也就是说如果滚动方向是垂直方向，则itemExtent代表子组件的高度；如果滚动方向为水平方向，则itemExtent就代表子组件的宽度。在ListView中，指定itemExtent比让子组件自己决定自身长度会有更好的性能，这是因为指定itemExtent后，滚动系统可以提前知道列表的长度，而无需每次构建子组件时都去再计算一下，尤其是在滚动位置频繁变化时（滚动系统需要频繁去计算列表高度）。
            //itemExtent: 15,

            // 此构造函数适用于具有少量子项的列表视图，因为构造 [List] 需要为可能显示在列表视图中的每个子项执行工作，而不仅仅是那些实际可见的子项。
            // cacheExtent: 4,

            // prototypeItem: SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent), // 如果我们知道列表中的所有列表项长度都相同但不知道具体是多少，这时我们可以指定一个列表项，该列表项被称为 prototypeItem（列表项原型）。指定 prototypeItem 后，可滚动组件会在 layout 时计算一次它延主轴方向的长度，这样也就预先知道了所有列表项的延主轴方向的长度，所以和指定 itemExtent 一样，指定 prototypeItem 会有更好的性能。注意，itemExtent 和prototypeItem 互斥，不能同时指定它们。

            // addAutomaticKeepAlives: true,
            // 该属性表示是否将列表项（子组件）包裹在RepaintBoundary组件中。RepaintBoundary 读者可以先简单理解为它是一个”绘制边界“，将列表项包裹在RepaintBoundary中可以避免列表项不必要的重绘，但是当列表项重绘的开销非常小（如一个颜色块，或者一个较短的文本）时，不添加RepaintBoundary反而会更高效（具体原因会在本书后面 Flutter 绘制原理相关章节中介绍）。如果列表项自身来维护是否需要添加绘制边界组件，则此参数应该指定为 false。
            // addRepaintBoundaries: true,

            // 从显式 [List] 创建一个可滚动的线性小部件数组。
            // addSemanticIndexes: true,
            // semanticChildCount: 0,

            // 这种方式适合只有少量的子组件数量已知且比较少的情况，反之则应该使用ListView.builder 按需动态构建列表项
            // children: [
            //   const Text('I\'m dedicating every day to you'),
            //   const Text('Domestic life was never quite my style'),
            //   const Text('When you smile, you knock me out, I fall apart'),
            //   const Text('And I thought I was so smart'),
            // ],
            // )

            // ListView.builder适合列表项比较多或者列表项不确定的情况
            // body: ListView.builder(
            //     itemCount: 100,
            //     itemExtent: 50, // 高度
            //     itemBuilder: (ctx, index) {
            //       return ListTile(
            //         title: Text('$index'),
            //       );
            //     }),

            // ListView.separated可以在生成的列表项之间添加一个分割组件，它比ListView.builder多了一个separatorBuilder参数，该参数是一个分割组件生成器。
            // body: ListView.separated(
            //     itemBuilder: (ctx, index) {
            //       return ListTile(
            //         title: Text('$index'),
            //       );
            //     },
            //     separatorBuilder: (ctx, index) {
            //       return index % 2 == 0 ? divider1 : divider2;
            //     },
            //     itemCount: 100),

            // 固定高度列表
            // 前面说过，给列表指定 itemExtent 或 prototypeItem 会有更高的性能，所以当我们知道列表项的高度都相同时，强烈建议指定 itemExtent 或 prototypeItem
            // body: ListView.builder(
            //   prototypeItem: ListTile(title: Text("1")),
            //   //itemExtent: 56,
            //   itemBuilder: (context, index) {
            //     //LayoutLogPrint是一个自定义组件，在布局时可以打印当前上下文中父组件给子组件的约束信息
            //     return ListTile(title: Text("$index"));
            //   },
            // )

            // 无限加载列表
            //假设我们要从数据源异步分批拉取一些数据，然后用ListView展示，当我们滑动到列表末尾时，判断是否需要再去拉取数据，如果是，则去拉取，拉取过程中在表尾显示一个loading，拉取成功后将数据插入列表；如果不需要再去拉取，则在表尾提示"没有更多"
            // body: ListView.separated(
            //     itemBuilder: (ctx, index) {
            //       if (_world[index] == loading) {
            //         if (_world.length - 1 < 100) {
            //           _retrievData();
            //           return Container(
            //             padding: const EdgeInsets.all(16),
            //             child: const SizedBox(
            //               width: 24,
            //               height: 24,
            //               child: CircularProgressIndicator(
            //                 strokeWidth: 2,
            //               ),
            //             ),
            //           );
            //         } else {
            //           //已经加载了100条数据，不再获取数据。
            //           return Container(
            //             alignment: Alignment.center,
            //             padding: EdgeInsets.all(16.0),
            //             child: const Text(
            //               "没有更多了",
            //               style: TextStyle(color: Colors.grey),
            //             ),
            //           );
            //         }
            //       }
            //       return ListTile(title: Text(_world[index]));
            //     },
            //     separatorBuilder: (ctx, index) {
            //       return const Divider(
            //         height: 1,
            //         color: Colors.red,
            //       );
            //     },
            //     itemCount: _world.length),

            // 添加固定列表头
            body: Column(children: <Widget>[
              ListTile(title: Text("商品列表")),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text("$index"));
                }),
              ),
            ])));
  }
}
