import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScaffoldTest extends StatefulWidget {
  const ScaffoldTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ScaffoldTestState();
}

class _ScaffoldTestState extends State<ScaffoldTest> {
  /* 
  */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 头像
    Widget avatar = Image.asset(
      "images/head.png",
      width: 60.0,
    );

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        // 如果给Scaffold添加了抽屉菜单，默认情况下Scaffold会自动将AppBar的leading设置为菜单按钮（如上面截图所示），点击它便可打开抽屉菜单。如果我们想自定义菜单图标，可以手动来设置leading
        leading: SizedBox(
            width: 44,
            height: 44,
            child: UnconstrainedBox(
              alignment: Alignment.center,
              child: Builder(builder: (ctx) {
                return IconButton(
                    onPressed: () {
                      // 打开抽屉菜单
                      Scaffold.of(ctx).openDrawer();
                    },
                    icon: const Icon(Icons.dashboard));
              }),
            )),
        automaticallyImplyLeading: false, // 不默认实现 Leading 按钮
        title: const Text('Scaffold'),
        // 在 [title] 小部件之后连续显示的小部件列表。
        actions: [
          IconButton(
              onPressed: () => print('object'),
              icon: const Icon(Icons.abc_sharp)),
          IconButton(
              onPressed: () => print('object'),
              icon: const Icon(Icons.access_alarm))
        ],
        // 此小部件堆叠在工具栏和选项卡栏的后面。 它的高度将与应用栏的整体高度相同。
        flexibleSpace: const FlexibleSpaceBar(
          title: Text('FlexibleSpaceBar'),
        ),
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 1),
            child: Container(color: Colors.yellow)),
        elevation:
            4, // 将此应用栏相对于其父级放置的 z 坐标。如果 [shadowColor] 不为空，此属性控制应用栏下方阴影的大小。
        scrolledUnderElevation: 4, // 如果此应用栏下方有滚动内容，将使用的高度。
        shadowColor: Colors.red,
        surfaceTintColor:
            Colors.white, // 应用于应用栏背景颜色以指示高度的表面色调叠加层的颜色。如果为 null，则不会应用覆盖。
        // 应用栏的 [Material] 形状及其阴影。
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        backgroundColor: Colors.lightGreen, // 背景色
        foregroundColor: Colors.yellow, // 前景色
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () => print(''),
              icon: const Icon(Icons.open_in_full_outlined))
        ],
      ),
      // FloatingActionButton是Material设计规范中的一种特殊Button，通常悬浮在页面的某一个位置作为某种常用动作的快捷入口，如本节示例中页面右下角的"➕"号按钮。我们可以通过Scaffold的floatingActionButton属性来设置一个FloatingActionButton，同时通过floatingActionButtonLocation属性来指定其在页面中悬浮的位置
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('FloatingActionButton'),
        child: const Text('+'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      persistentFooterButtons: [
        // 一组显示在脚手架底部的按钮。
        TextButton.icon(
            onPressed: () => print('home'),
            icon: const Icon(Icons.home),
            label: const Text('Home')),
        TextButton.icon(
            onPressed: () => print('UI'),
            icon: const Icon(Icons.list),
            label: const Text('UI')),
        TextButton.icon(
            onPressed: () => print('Demo'),
            icon: const Icon(Icons.developer_mode),
            label: const Text('Demo'))
      ],
      drawerDragStartBehavior: DragStartBehavior.start, // 确定处理拖动开始行为的方式
      drawerScrimColor: Colors.red.shade800,
      drawerEdgeDragWidth: 40,
      drawerEnableOpenDragGesture: true,
      drawer: const Drawer(
        backgroundColor: Colors.red,
        elevation: 20, // 阴影
        child: Text('Drawer'),
      ),
      onDrawerChanged: (isOpened) => print("Draw $isOpened"),
      endDrawerEnableOpenDragGesture: true,
      endDrawer: const Drawer(
        child: Text('End Drawer'),
      ),
      onEndDrawerChanged: (isOpened) => print("End Draw $isOpened"),
      // 通过Scaffold的bottomNavigationBar属性来设置底部导航，如本节开始示例所示，我们通过Material组件库提供的BottomNavigationBar和BottomNavigationBarItem两种组件来实现Material风格的底部导航栏, 打洞的位置取决于FloatingActionButton的位置
      // BottomAppBar的shape属性决定洞的外形，CircularNotchedRectangle实现了一个圆形的外形，我们也可以自定义外形
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_sharp), label: "List")
      ]),
      bottomSheet: BottomSheet(
          onClosing: () => print('onClosing'),
          builder: (ctx) {
            return const Text('data');
          }),
      backgroundColor: const Color.fromARGB(255, 41, 35, 38),
      resizeToAvoidBottomInset: true,
      primary: true, // 此脚手架是否显示在屏幕顶部。
      extendBody:
          false, // 如果为 true，并且指定了 [bottomNavigationBar] 或 [persistentFooterButtons]，则 [body] 延伸到 Scaffold 的底部，而不是仅延伸到 [bottomNavigationBar] 或 [persistentFooterButtons] 的顶部。
      extendBodyBehindAppBar:
          false, // 如果为 true，并且指定了 [appBar]，则 [body] 的高度将扩展为包括应用栏的高度，并且主体的顶部与应用栏的顶部对齐。
      restorationId: 'MainScaffoal',
    ));
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Image.asset(
                        "imgs/avatar.png",
                        width: 80,
                      ),
                    ),
                  ),
                  const Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add account'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
