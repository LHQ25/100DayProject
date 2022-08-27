import 'package:english_words/english_words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PageViewTest extends StatefulWidget {
  const PageViewTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PageViewTestState();
}

class _PageViewTestState extends State<PageViewTest> {
  /* 
    如果要实现页面切换和 Tab 布局，我们可以使用 PageView 组件。需要注意，PageView 是一个非常重要的组件，因为在移动端开发中很常用，比如大多数 App 都包含 Tab 换页效果、图片轮动以及抖音上下滑页切换视频功能等等，这些都可以通过 PageView 轻松实现。
  */

  late final PageController _contoller;

  @override
  void initState() {
    super.initState();

    _contoller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    // 生成 6 个 Tab 页
    for (int i = 0; i < 6; ++i) {
      children.add(Page(text: '$i'));
    }

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList'),
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        reverse: false,
        controller: _contoller,
        physics: null,
        pageSnapping: true, // 每次滑动是否强制切换整个页面，如果为false，则会根据实际的滑动距离显示页面
        onPageChanged: (value) => print('onPageChanged'),
        children: children,
        dragStartBehavior: DragStartBehavior.start,
        allowImplicitScrolling:
            false, // allowImplicitScrolling 为 true 时设置了预渲染区域，注意，此时的缓存类型为 CacheExtentStyle.viewport，则 cacheExtent 则表示缓存的长度是几个 Viewport 的宽度，cacheExtent 为 1.0，则代表前后各缓存一个页面宽度，即前后各一页。 发现PageView 中设置 cacheExtent 会和 iOS 中 辅助功能有冲突
        padEnds: true,

        // PageView 默认并没有缓存功能，一旦页面滑出屏幕它就会被销毁
      ),
    ));
  }
}

// Tab 页面
class Page extends StatefulWidget {
  const Page({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    print("build ${widget.text}");
    return Center(child: Text("${widget.text}", textScaleFactor: 5));
  }
}
