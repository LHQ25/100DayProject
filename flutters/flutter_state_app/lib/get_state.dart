import 'dart:html';

import 'package:flutter/material.dart';

class GetStateTest extends StatefulWidget {
  const GetStateTest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GetStateTestState();
}

class _GetStateTestState extends State<GetStateTest> {
  // //定义一个globalKey, 由于GlobalKey要保持全局唯一性，我们使用静态变量存储
  static GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('子树中获取State对象'),
        ),
        drawer: Drawer(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        body: Center(
          child: Column(
            children: [
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      /* ----------------- 通过Context获取 ----------------- */
                      // context对象有一个findAncestorStateOfType()方法，该方法可以从当前节点沿着 widget 树向上查找指定类型的 StatefulWidget 对应的 State 对象
                      // 查找父级最近的Scaffold对应的ScaffoldState对象
                      ScaffoldState _state =
                          context.findAncestorStateOfType<ScaffoldState>()!;
                      // 打开抽屉
                      _state.openDrawer();
                    },
                    child: Text('打开抽屉菜单1'));
              }),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      /* ----------------- 通过 of 获取 ----------------- */
                      // 在 Flutter 开发中便有了一个默认的约定：如果 StatefulWidget 的状态是希望暴露出的，应当在 StatefulWidget 中提供一个of 静态方法来获取其 State 对象，开发者便可直接通过该方法来获取；如果 State不希望暴露，则不提供of方法。这个约定在 Flutter SDK 里随处可见。所以，上面示例中的Scaffold也提供了一个of方法，可以直接调用它
                      ScaffoldState _state = Scaffold.of(context);
                      // 打开抽屉
                      _state.openDrawer();
                    },
                    child: Text('打开抽屉菜单2'));
              }),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      /* ----------------- 想显示 snack bar 的话可以通过下面代码调用----------------- */
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('showSnackBar')));
                    },
                    child: Text('snack bar'));
              }),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      /* ----------------- 通过 GlobalKey 获取 ----------------- */
                      // Flutter还有一种通用的获取State对象的方法——通过GlobalKey来获取！ 步骤分两步：
                      //    给目标StatefulWidget添加GlobalKey
                      _globalKey.currentState?.openDrawer();
                      // GlobalKey 是 Flutter 提供的一种在整个 App 中引用 element 的机制。如果一个 widget 设置了GlobalKey，那么我们便可以通过globalKey.currentWidget 获得该 widget 对象、globalKey.currentElement来获得 widget 对应的element对象，如果当前 widget 是StatefulWidget，则可以通过globalKey.currentState来获得该 widget 对应的state对象
                    },
                    child: Text('打开抽屉菜单3'));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
