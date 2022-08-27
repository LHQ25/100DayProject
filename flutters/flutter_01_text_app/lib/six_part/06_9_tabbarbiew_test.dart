import 'package:flutter/material.dart';

class TabBarViewTest extends StatefulWidget {
  const TabBarViewTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TabBarViewTestState();
}

class _TabBarViewTestState extends State<TabBarViewTest>
    with SingleTickerProviderStateMixin {
  /* 
  */
  List<String> tatabs = ['新闻', '历史', '图片'];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tatabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: const Text('TabBarViewTest'),
          bottom: TabBar(
              controller: _tabController,
              tabs: tatabs.map((e) => Tab(text: e)).toList())),
      body: _createTabBarViewTest(context),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //   BottomNavigationBarItem(icon: Icon(Icons.list_alt_sharp), label: "List")
      // ]),
    ));
  }

  Widget _createTabBarViewTest(BuildContext context) {
    return TabBarView(
        controller: _tabController,
        children: tatabs.map((e) {
          return KeepAlive(
            keepAlive: true,
            child: Container(
              alignment: Alignment.center,
              child: Text(e, textScaleFactor: 5),
            ),
          );
        }).toList());
  }
}
