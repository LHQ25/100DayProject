import 'package:flutter/material.dart';

import '../five_part/05_1_padding_test.dart';
import '../five_part/05_2_decoratedbox_test.dart';
import '../five_part/05_3_transform_test.dart';
import '../five_part/05_4_container_test.dart';
import '../five_part/05_5_clip_test.dart';
import '../five_part/05_7_Scaffold_test.dart';
import '../six_part/06_2_SingleChildScrollView_test.dart';
import '../six_part/06_3_listview_test.dart';
import '../home/homepage.dart';

class TabbarController extends StatefulWidget {
  const TabbarController({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabbarControllerState();
}

class _TabbarControllerState extends State<TabbarController> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // onUnknownRoute: _unKnowRoute(setting),
      routes: routes(),
    );
  }

  // Route _unKnowRoute(RouteSettings settings) {

  // }
}

Map<String, WidgetBuilder> routes() {
  return {
    "/": (BuildContext context) => const HomePageView(),
    // 第五章
    'PaddingTest': (context) => const PaddingTest(),
    'DecoratedBoxTest': (context) => const DecoratedBoxTest(),
    'TransformTest': (context) => const TransformTest(),
    'ContainerTest': (context) => const ContainerTest(),
    'ClipTest': (context) => const ClipTest(),
    'ScaffoldTest': (context) => const ScaffoldTest(),
    // 第六章
    'SingleChildScrollViewTest': (context) => const SingleChildScrollViewTest(),
    'ListViewTest': (context) => const ListViewTest()
  };
}
