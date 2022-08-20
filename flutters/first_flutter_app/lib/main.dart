// 导包
import 'package:flutter/material.dart';     // 导入了 Material UI 组件库

void main() {     
  // Flutter 应用中 main 函数为应用程序的入口。
  // main 函数中调用了runApp 方法，它的功能是启动Flutter应用。
  // runApp它接受一个 Widget参数，在本示例中它是一个MyApp对象，MyApp()是 Flutter 应用的根组件
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// MyHomePage 是应用的首页，它继承自StatefulWidget类，表示它是一个有状态的组件（Stateful widget）
// 至少由两个类组成：
  // 一个StatefulWidget类。
  // 一个 State类； StatefulWidget类本身是不变的，但是State类中持有的状态在 widget 生命周期中可能会发生变化
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// _MyHomePageState类是MyHomePage类对应的状态类。
// 和MyApp 类不同， MyHomePage类中并没有build方法，取而代之的是，build方法被挪到了_MyHomePageState方法中

// State类
class _MyHomePageState extends State<MyHomePage> {
  // 组件的状态。
  // 由于我们只需要维护一个点击次数计数器，所以定义一个_counter状态
  int _counter = 0;

  // 设置状态的自增函数
  void _incrementCounter() {
    setState(() {
      // 当按钮点击时，会调用此函数，该函数的作用是先自增_counter，然后调用setState 方法。
      // setState方法的作用是通知 Flutter 框架，有状态发生了改变，Flutter 框架收到通知后，会执行 build 方法来根据新的状态重新构建界面， 
      // Flutter 对此方法做了优化，使重新执行变的很快，所以你可以重新构建任何需要更新的东西，而无需分别去修改各个 widget。
      _counter++;
    });
  }

  // 构建UI界面的build方法
  // 构建UI界面的逻辑在 build 方法中，当MyHomePage第一次创建时，_MyHomePageState类会被创建，
  // 当初始化完成后，Flutter框架会调用 widget 的build方法来构建 widget 树，最终将 widget 树渲染到设备屏幕上
  @override
  Widget build(BuildContext context) {
    return Scaffold(   // 是 Material 库中提供的页面脚手架，它提供了默认的导航栏、标题和包含主屏幕 widget 树（后同“组件树”或“部件树”）的body属性，组件树可以很复杂
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // 组件树中包含了一个Center 组件，Center 可以将其子组件树对齐到屏幕中心。
      // 此例中， Center 子组件是一个Column 组件，Column的作用是将其所有子组件沿屏幕垂直方向依次排列； 
      //    此例中Column子组件是两个 Text ，第一个Text 显示固定文本 “You have pushed the button this many times:”，
      //    第二个Text 显示_counter状态的数值
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      // floatingActionButton是页面右下角的带“+”的悬浮按钮，它的onPressed属性接受一个回调函数，代表它被点击后的处理器，
      // 本例中直接将_incrementCounter方法作为其处理函数
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
