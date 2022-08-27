import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/06_10_custom_scrollview_test.dart';

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
        'section': '第五章 容器类组件',
        'items': [
          StudyBaseItem('填充 padding', 'PaddingTest'),
          StudyBaseItem('装饰容器 DecoratedBox', 'DecoratedBoxTest'),
          StudyBaseItem('变换 Transform', 'TransformTest'),
          StudyBaseItem('容器组件 Container', 'ContainerTest'),
          StudyBaseItem('剪裁 Clip', 'ClipTest'),
          StudyBaseItem('空间适配 FittedBox', 'DecoratedBoxTest'),
          StudyBaseItem('页面骨架 Scaffold', 'ScaffoldTest')
        ]
      });
      _sections.add({
        'section': '第六章 可滚动组件',
        'items': [
          StudyBaseItem('SingleChildScrollView', 'SingleChildScrollViewTest'),
          StudyBaseItem('ListView', 'ListViewTest')
        ]
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return _section(index);
      },
      itemCount: _sections.length,
    );
  }

  Widget _section(int index) {
    var section = _sections[index];
    List<Widget> items = [];
    for (var t in (section['items'] as List<StudyBaseItem>)) {
      items.add(GestureDetector(
        onTap: () => Navigator.pushNamed(context, t.page),
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
