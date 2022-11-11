import 'package:flutter/material.dart';

class LayoutBuilderTest extends StatefulWidget {
  const LayoutBuilderTest({Key? key}) : super(key: key);

  @override
  State<LayoutBuilderTest> createState() => _LayoutBuilderTestState();
}

class _LayoutBuilderTestState extends State<LayoutBuilderTest> {
  @override
  Widget build(BuildContext context) {
    var children = List.filled(6, const Text("A"));
    // Column在本示例中在水平方向的最大宽度为屏幕的宽度

    return Scaffold(
      appBar: AppBar(
        title: const Text("LayoutBuilder"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                "通过 LayoutBuilder，我们可以在布局过程中拿到父组件传递的约束信息，然后我们可以根据约束信息动态的构建不同的布局"),
            // 限制宽度为190，小于 200
            SizedBox(width: 190, child: ResponsiveColumn(children: children)),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            ResponsiveColumn(children: children),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveColumn extends StatelessWidget {
  const ResponsiveColumn({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // 通过 LayoutBuilder 拿到父组件传递的约束，然后判断 maxWidth 是否小于200
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 200) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      } else {
        // 大于200，显示双列
        var children = <Widget>[];
        for (var i = 0; i < this.children.length; i += 2) {
          if (i + 1 < this.children.length) {
            children.add(Row(
              mainAxisSize: MainAxisSize.min,
              children: [this.children[i], this.children[i + 1]],
            ));
          } else {
            children.add(this.children[i]);
          }
        }
        return Column(mainAxisSize: MainAxisSize.min, children: children);
      }
    });
  }
}
