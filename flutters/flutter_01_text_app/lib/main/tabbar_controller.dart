
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/eight_part/01_hit_test.dart';
import 'package:flutter_01_text_app/eight_part/02_gestureRecognizer_test.dart';
import 'package:flutter_01_text_app/eight_part/02_gesturedetector_test.dart';
import 'package:flutter_01_text_app/elevent_part/03_dio_test.dart';
import 'package:flutter_01_text_app/seven_part/02_inheritedwidget_test.dart';

import '../eight_part/05_eventbus_test.dart';
import '../eight_part/06_notificaiton_custom.dart';
import '../eight_part/06_notification_test.dart';
import '../five_part/05_1_padding_test.dart';
import '../five_part/05_2_decoratedbox_test.dart';
import '../five_part/05_3_transform_test.dart';
import '../five_part/05_4_container_test.dart';
import '../five_part/05_5_clip_test.dart';
import '../five_part/05_7_Scaffold_test.dart';
import '../seven_part/01_willpopscope.dart';
import '../seven_part/05_valuelistenablebuilder_test.dart';
import '../seven_part/06_futurebuilder_test.dart';
import '../seven_part/06_streambuilder_test.dart';
import '../seven_part/07_alertdialog_test.dart';
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
    'ListViewTest': (context) => const ListViewTest(),
    // 第七章
    'WillPopScopeTest': (context) => const WillPopScopeTest(),
    'InheritedWidgetTest': (context) => const InheritedWidgetTest(),
    'AlertAialogWidgetTest': (context) => const AlertAialogWidgetTest(),
    'ValueListenanleBuilderTest': (context) =>
        const ValueListenanleBuilderTest(),
    'FutureBuilderTest': (context) => const FutureBuilderTest(),
    'StreamBuilderTest': (context) => const StreamBuilderTest(),

    //第八章
    'HitTest': (context) => const HitTest(),
    'GestureDetectorTest': (context) => const GestureDetectorTest(),
    'GestureRecognizerTest': (context) => const GestureRecognizerTest(),
    'EventBusTest': (context) => const EventBusTest(),
    'NotificationTest': (context) => const NotificationTest(),
    'NotificationCustomTest': (context) => const NotificationCustomTest(),

    // 第十一章
    'DioTest': (context) => const DioTest(),
  };
}
