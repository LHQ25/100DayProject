import 'package:english_words/english_words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomSliverTest extends StatefulWidget {
  const CustomSliverTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CustomSliverTestState();
}

class _CustomSliverTestState extends State<CustomSliverTest> {
  /* 
    
  */

  @override
  void initState() {
    super.initState();
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
        title: const Text('Custom ScrollView'),
      ),
      // body: buildTwoListView()))
      // body: explame(),
      body: sliverPersistentHeader_Test(),
    ));
  }

  Widget sliverFlexibleHeader() {
    /* 
      默认情况下顶部图片只显示一部分，当用户向下拽时图片的剩余部分会逐渐显示
     */
    var listView = SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return ListTile(
            title: Text('$index'),
          );
        }, childCount: 10),
        itemExtent: 50 //列表项高度固定
        );

    // CustomScrollView 的主要功能是提供一个公共的的 Scrollable 和 Viewport，来组合多个 Sliver
    return CustomScrollView(
      //为了能使CustomScrollView拉到顶部时还能继续往下拉，必须让 physics 支持弹性效果
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // SliverFlexibleHeader()
        listView
      ],
    );

    /* 
    Flutter 中常用的 Sliver

    Sliver名称	                 功能	                           对应的可滚动组件
    SliverList	                列表	                          ListView
    SliverFixedExtentList	      高度固定的列表	                  ListView，指定itemExtent时
    SliverAnimatedList	        添加/删除列表项可以执行动画	        AnimatedList
    SliverGrid	                网格	                          GridView
    SliverPrototypeExtentList	  根据原型生成高度固定的列表	        ListView，指定prototypeItem 时
    SliverFillViewport	        包含多个子组件，每个都可以填满屏幕	  PageView

    除了和列表对应的 Sliver 之外还有一些用于对 Sliver 进行布局、装饰的组件，它们的子组件必须是 Sliver，我们列举几个常用的：

    Sliver名称	                          对应 RenderBox
    SliverPadding	                        Padding
    SliverVisibility、SliverOpacity	      Visibility、Opacity
    SliverFadeTransition	                FadeTransition
    SliverLayoutBuilder                   LayoutBuilder

    还有一些其他常用的 Sliver：

    Sliver名称	                 说明
    SliverAppBar	              对应 AppBar，主要是为了在 CustomScrollView 中使用。
    SliverToBoxAdapter	        一个适配器，可以将 RenderBox 适配为 Sliver，后面介绍。
    SliverPersistentHeader	    滑动到顶部时可以固定住，后面介绍。
    */
  }

  Widget explame() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          // AppBar，包含一个导航栏.
          pinned: true, // 滑动到顶端时会固定住
          expandedHeight: 250,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('App bar'),
            background: Image.asset(
              'images/11.png',
              fit: BoxFit.none,
            ),
          ),
        ),

        /* 
        在实际布局中，我们通常需要往 CustomScrollView 中添加一些自定义的组件，而这些组件并非都有 Sliver 版本，为此 Flutter 提供了一个 SliverToBoxAdapter 组件，它是一个适配器：可以将 RenderBox 适配为 Sliver。比如我们想在列表顶部添加一个可以横向滑动的 PageView，可以使用 SliverToBoxAdapter 来配置 
        
        如果 CustomScrollView 有孩子也是一个完整的可滚动组件且它们的滑动方向一致，则 CustomScrollView 不能正常工作。要解决这个问题，可以使用 NestedScrollView
        */
        sliverToBoxAdapter_test(),
        SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 4),
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.cyan[100 * (index % 9)],
                  child: Text('grid item $index'),
                );
              }, childCount: 20),
            )),
        SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(((context, index) {
              //创建列表项
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('list item $index'),
              );
            })),
            itemExtent: 50)
      ],
    );
  }

  SliverToBoxAdapter sliverToBoxAdapter_test() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: PageView(
          children: const [Text("1"), Text("2")],
        ),
      ),
    );
  }

  /* SliverPersistentHeader 的功能是当滑动到 CustomScrollView 的顶部时，可以将组件固定在顶部 */
  Widget sliverPersistentHeader_Test() {
    return CustomScrollView(
      slivers: [
        buildSliverList(25),
        SliverPersistentHeader(
          floating:
              true, // floating 的做用是：pinned 为 false 时 ，则 header 可以滑出可视区域（CustomScrollView 的 Viewport）（不会固定到顶部），当用户再次向下滑动时，此时不管 header 已经被滑出了多远，它都会立即出现在可视区域顶部并固定住，直到继续下滑到 header 在列表中原来的位置时，header 才会重新回到原来的位置（不再固定在顶部）
          pinned: false,
          delegate: SliverHeaderDelegate(
            //有最大和最小高度
            maxHeight: 80,
            minHeight: 50,
            child: buildHeader(1),
          ),
        ),
        buildSliverList(5),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate(
            //有最大和最小高度
            maxHeight: 80,
            minHeight: 50,
            child: buildHeader(1),
          ),
        ),
        buildSliverList(15),
      ],
    );
  }

  // 构建固定高度的SliverList，count为列表项属相
  Widget buildSliverList([int count = 5]) {
    return SliverFixedExtentList(
      itemExtent: 50,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(title: Text('$index'));
        },
        childCount: count,
      ),
    );
  }

  // 构建 header
  Widget buildHeader(int i) {
    return Container(
      color: Colors.lightBlue.shade200,
      alignment: Alignment.centerLeft,
      child: Text("PersistentHeader $i"),
    );
  }
}

typedef SliverHeaderBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  // child 为 header
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  //最大和最小高度相同
  SliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  //需要自定义builder时使用
  SliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    //测试代码：如果在调试模式，且子组件设置了key，则打印日志
    assert(() {
      if (child.key != null) {
        print('${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate old) {
    return old.maxExtent != maxExtent || old.minExtent != minExtent;
  }
}
