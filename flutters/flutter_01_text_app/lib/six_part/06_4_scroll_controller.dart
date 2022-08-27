import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollControllerTest extends StatefulWidget {
  const ScrollControllerTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ScrollControllerTestState();
}

class _ScrollControllerTestState extends State<ScrollControllerTest> {
  /* 
    ScrollController常用的属性和方法：

offset：可滚动组件当前的滚动位置。
jumpTo(double offset)、animateTo(double offset,...)：这两个方法用于跳转到指定的位置，它们不同之处在于，后者在跳转时会执行一个动画，而前者不会
  */

  final ScrollController _scrollController =
      ScrollController(debugLabel: 'ScrollController');

  var showToTopBtn = false;

  final _scrollKey = PageStorageKey("MyList");

  @override
  void initState() {
    super.initState();

// 滚动箭头
    _scrollController.addListener(() {
      print(_scrollController.offset);
      if (_scrollController.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 1000 && !showToTopBtn) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });

    /*
      滚动位置恢复
      PageStorage是一个用于保存页面(路由)相关数据的组件，它并不会影响子树的UI外观，其实，PageStorage是一个功能型组件，它拥有一个存储桶（bucket），子树中的Widget可以通过指定不同的PageStorageKey来存储各自的数据或状态。

      每次滚动结束，可滚动组件都会将滚动位置offset存储到PageStorage中，当可滚动组件重新创建时再恢复。
      如果ScrollController.keepScrollOffset为false，则滚动位置将不会被存储，可滚动组件重新创建时会使用ScrollController.initialScrollOffset；ScrollController.keepScrollOffset为true时，可滚动组件在第一次创建时，会滚动到initialScrollOffset处，因为这时还没有存储过滚动位置。
      在接下来的滚动中就会存储、恢复滚动位置，而initialScrollOffset会被忽略.

      当一个路由中包含多个可滚动组件时，如果你发现在进行一些跳转或切换操作后，滚动位置不能正确恢复，这时你可以通过显式指定PageStorageKey来分别跟踪不同的可滚动组件的位置
    */
    // _scrollController.keepScrollOffset = true;

    /*
      ScrollPosition： 是用来保存可滚动组件的滚动位置的。
      一个ScrollController对象可以同时被多个可滚动组件使用，ScrollController会为每一个可滚动组件创建一个ScrollPosition对象，这些ScrollPosition保存在ScrollController的positions属性中（List<ScrollPosition>）。ScrollPosition是真正保存滑动位置信息的对象，offset只是一个便捷属性：
    */
    // var position = _scrollController.positions.first.pixels;
    /*
      一个ScrollController虽然可以对应多个可滚动组件，但是有一些操作，如读取滚动位置offset，则需要一对一！
      但是我们仍然可以在一对多的情况下，通过其他方法读取滚动位置，
      举个例子，假设一个ScrollController同时被两个可滚动组件使用，那么我们可以通过如下方式分别读取他们的滚动位置：
        controller.positions.elementAt(0).pixels
        controller.positions.elementAt(1).pixels    

      ScrollPosition的方法
        ScrollPosition有两个常用方法：animateTo() 和 jumpTo()，它们是真正来控制跳转滚动位置的方法，ScrollController的这两个同名方法，内部最终都会调用ScrollPosition的 
    */

    /*
    滚动监听
      #1. 滚动通知
        Flutter Widget树中子Widget可以通过发送通知（Notification）与父(包括祖先)Widget通信。父级组件可以通过NotificationListener组件来监听自己关注的通知，这种通信方式类似于Web开发中浏览器的事件冒泡。

        可滚动组件在滚动时会发送ScrollNotification类型的通知，ScrollBar正是通过监听滚动通知来实现的。通过NotificationListener监听滚动事件和通过ScrollController有两个主要的不同：
          通过NotificationListener可以在从可滚动组件到widget树根之间任意位置都能监听。而ScrollController只能和具体的可滚动组件关联后才可以。
          收到滚动事件后获得的信息不同；NotificationListener在收到滚动事件时，通知中会携带当前滚动位置和ViewPort的一些信息，而ScrollController只能获取当前滚动位置。
    */
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('滚动控制'),
            ),
            floatingActionButton: !showToTopBtn
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      _scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease);
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
            // ListView.builder适合列表项比较多或者列表项不确定的情况
            // body: ListView.builder(
            //     key: _scrollKey,
            //     itemCount: 100,
            //     itemExtent: 50, // 高度
            //     controller: _scrollController,
            //     itemBuilder: (ctx, index) {
            //       return ListTile(
            //         title: Text('$index'),
            //       );
            //     }),
            body: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                var offset = notification.metrics.pixels;
                print('另一种方式实现上边的效果：$offset');
                if (offset < 1000 && showToTopBtn) {
                  setState(() {
                    showToTopBtn = false;
                  });
                } else if (offset >= 1000 && !showToTopBtn) {
                  setState(() {
                    showToTopBtn = true;
                  });
                }
                return true;
              },
              child: ListView.builder(
                  key: _scrollKey,
                  itemCount: 100,
                  itemExtent: 50, // 高度
                  // controller: _scrollController,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text('$index'),
                    );
                  }),
            )));
  }
}
