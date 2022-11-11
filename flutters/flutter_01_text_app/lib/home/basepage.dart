import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/fluro_route/Routes.dart';
import 'package:flutter_01_text_app/main.dart';

class BaseComponentPageView extends StatefulWidget {
  const BaseComponentPageView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BaseComponentPageViewState();
}

class _BaseComponentPageViewState extends State<BaseComponentPageView> {
  List<Map<String, dynamic>> _sections = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _sections.add({
        'section': '基础组件',
        'items': [
          StudyBaseItem("文本及样式", Routes.textPageView),
          StudyBaseItem('按钮', Routes.buttonPageView),
          StudyBaseItem('图片和ICON', Routes.imageIconPageView),
          StudyBaseItem('单选开关和复选框', Routes.checkPageView),
          StudyBaseItem('输入框及表单', Routes.formPageView),
          StudyBaseItem('进度指示器', Routes.progressPageView),
        ]
      });

      _sections.add({
        'section': '布局探索',
        'items': [
          StudyBaseItem("我的商店", "MyMerchandisePageView"),
          StudyBaseItem('从打破紧约束开始说起', 'BoxConstraintsTest'),
          StudyBaseItem("常用组件下施加约束", "ConstraintsTest"),
          StudyBaseItem("Flex对布局结构的划分", Routes.flexPageView),
          StudyBaseItem("流式布局（Wrap、Flow）", Routes.flowPageView),
          StudyBaseItem("层叠布局（Stack、Positioned）", Routes.stackPageView),
          StudyBaseItem("对齐与相对定位（Align）", Routes.alignPageView),
          StudyBaseItem("LayoutBuilder", Routes.layoutBuilderPageView),
          StudyBaseItem("AfterLayoutTest", Routes.afterLayoutPageView)
        ]
      });

      _sections.add({
        'section': '第五章 容器类组件',
        'items': [
          StudyBaseItem('布局原理与约束（constraints）', Routes.constraintsPageView),
          StudyBaseItem('填充 padding', Routes.paddingPageView),
          StudyBaseItem('装饰容器 DecoratedBox', Routes.decoratedBoxPageView),
          StudyBaseItem('变换 Transform', Routes.transformPageView),
          StudyBaseItem('容器组件 Container', Routes.containerPageView),
          StudyBaseItem('剪裁 Clip', Routes.clipPageView),
          StudyBaseItem('空间适配 FittedBox', Routes.fittedBoxPageView),
          StudyBaseItem('页面骨架 Scaffold', Routes.scaffoldPageView)
        ]
      });
      _sections.add({
        'section': '第六章 可滚动组件',
        'items': [
          StudyBaseItem('SingleChildScrollView', Routes.singleScrollPageView),
          StudyBaseItem('ListView', Routes.listViewPageView),
          StudyBaseItem('滚动监听及控制', Routes.scrollControllerPageView),
          StudyBaseItem('AnimatedList', Routes.animatedListPageView),
          StudyBaseItem('GridView', Routes.gridViewPageView),
        ]
      });
      _sections.add({
        'section': '第七章 功能型组件',
        'items': [
          StudyBaseItem('导航返回拦截（WillPopScope）', 'WillPopScopeTest'),
          StudyBaseItem('数据共享（InheritedWidget）', 'InheritedWidgetTest'),
          StudyBaseItem('按需rebuild（ValueListenableBuilder）',
              'ValueListenanleBuilderTest'),
          StudyBaseItem('异步UI更新 FutureBuilder', 'FutureBuilderTest'),
          StudyBaseItem('异步UI更新 StreamBuilder', 'StreamBuilderTest'),
          StudyBaseItem('对话框详解', 'AlertAialogWidgetTest')
        ]
      });
      _sections.add({
        'section': '第八章 事件处理与通知',
        'items': [
          StudyBaseItem('原始指针事件处理', 'HitTest'),
          StudyBaseItem('处理手势的 GestureDetector', 'GestureDetectorTest'),
          StudyBaseItem('处理手势的 GestureRecognizer', 'GestureRecognizerTest'),
          StudyBaseItem('通知 Notification', 'NotificationTest'),
          StudyBaseItem('自定义通知', 'NotificationCustomTest'),
          StudyBaseItem('事件总线 EventBus', 'EventBusTest'),
        ]
      });

      _sections.add({
        'section': '第十一章 文件操作与网络请求',
        'items': [
          StudyBaseItem('Http 请求库 Dio', 'DioTest'),
        ]
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, index) {
            return _section(index);
          },
          itemCount: _sections.length,
        ));
  }

  Widget _section(int index) {
    var section = _sections[index];
    List<Widget> items = [];
    for (var t in (section['items'] as List<StudyBaseItem>)) {
      items.add(GestureDetector(
        onTap: () => Application.router.navigateTo(context, t.page,
            transition: TransitionType
                .cupertino), //Navigator.pushNamed(context, t.page),
        child: Container(
          height: 44,
          decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.rectangle),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.title),
              const Padding(
                padding: EdgeInsets.only(
                  top: 4,
                ),
                child: Divider(
                  height: 1,
                  color: Color.fromARGB(255, 145, 143, 143),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 44,
            alignment: Alignment.centerLeft,
            child: Text(_sections[index]['section']),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}

class StudyBaseItem {
  String title;
  String page;

  StudyBaseItem(this.title, this.page);
}
