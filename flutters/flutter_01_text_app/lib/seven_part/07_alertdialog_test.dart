import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertAialogWidgetTest extends StatefulWidget {
  const AlertAialogWidgetTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AlertAialogWidgetTestState();
}

class _AlertAialogWidgetTestState extends State<AlertAialogWidgetTest> {
  /* AlertDialog、SimpleDialog以及Dialog是Material组件库提供的三种对话框，旨在帮助开发者快速构建出符合Material设计规范的对话框，但读者完全可以自定义对话框样式，因此，我们仍然可以实现各种样式的对话框，这样即带来了易用性，又有很强的扩展性。 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlertAialog'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                bool? result = await alertdialog1(context);
              },
              child: const Text('SimpleDialog')),
          ElevatedButton(
              onPressed: () async {
                await simpleDialog();
              },
              child: const Text('List Dialog')),
          ElevatedButton(
              onPressed: () async {
                await listDialog();
              },
              child: const Text('list dialog')),
          ElevatedButton(
              onPressed: () async {
                await showcustomDialog();
              },
              child: const Text('custom dialog')),
          ElevatedButton(
              onPressed: () async {
                await showLoadingDialog();
              },
              child: const Text('Looding')),
          ElevatedButton(
              onPressed: () async {
                await _showDatePicker1();
              },
              child: const Text('日历')),
          ElevatedButton(
              onPressed: () async {
                await _showDatePicker2();
              },
              child: const Text('iOS 日历')),
        ],
      ),
    );
  }

  /// Material库中的AlertDialog组件
  Future<bool?> alertdialog1(BuildContext context) {
    return showDialog<bool>(
        barrierDismissible: true, // 点击遮罩是否消失
        barrierColor: Colors.red.withAlpha(20), //遮罩颜色
        barrierLabel: 'barrierLabel',
        useRootNavigator: true,
        useSafeArea: true,
        routeSettings: null,
        context: context,
        anchorPoint: const Offset(30, 30),
        builder: (ctx) {
          return AlertDialog(
            title: const Text('提示'),
            titlePadding: const EdgeInsets.all(8),
            titleTextStyle: const TextStyle(
                color: Colors.cyan, fontWeight: FontWeight.bold),
            content: const Text('提示内容'),
            contentPadding: const EdgeInsets.all(12),
            contentTextStyle: const TextStyle(color: Colors.blue),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消')),
              ElevatedButton(
                  // Navigator.of(context).pop(…)方法来关闭对话框的，这和路由返回的方式是一致的，并且都可以返回一个结果数据
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('确定'))
            ],
            actionsPadding: const EdgeInsets.all(8),
            actionsAlignment: MainAxisAlignment.spaceAround,
          );
        });
  }

  Future<void> simpleDialog() async {
    int? i = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('请选择语言'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // 返回1
                Navigator.pop(context, 1);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text('中文简体'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 返回2
                Navigator.pop(context, 2);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text('美国英语'),
              ),
            ),
          ],
        );
      },
    );
    if (i != null) {
      print("选择了：${i == 1 ? "中文简体" : "美国英语"}");
    }
  }

  // 嵌套 listView，只能使用 dialog 基类
  Future<void> listDialog() async {
    int? index = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        var child = Column(
          children: <Widget>[
            const ListTile(title: Text("请选择")),
            Expanded(
                child: ListView.builder(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("$index"),
                  onTap: () => Navigator.of(context).pop(index),
                );
              },
            )),
          ],
        );
        //使用AlertDialog会报错
        //return AlertDialog(content: child);
        return Dialog(child: child);
      },
    );
    if (index != null) {
      print("点击了：$index");
    }
  }

  // 自定义这些外部样式
  Future<T?> showCustomDialog<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    required WidgetBuilder builder,
    ThemeData? theme,
  }) {
    final ThemeData theme = Theme.of(context);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87, // 自定义遮罩颜色
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // 使用缩放动画
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  Future<bool?> showcustomDialog() async {
    return showCustomDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("您确定要删除当前文件吗?"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("删除"),
              onPressed: () {
                // 执行删除操作
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  // 底部菜单列表
  // 弹出底部菜单列表模态对话框
  Future<int?> _showModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("$index"),
              onTap: () => Navigator.of(context).pop(index),
            );
          },
        );
      },
    );
  }

  // Loading框
  /*
  如果我们嫌Loading框太宽，想自定义对话框宽度，这时只使用SizedBox或ConstrainedBox是不行的，原因是showDialog中已经给对话框设置了最小宽度约束，根据我们在第五章“尺寸限制类容器”一节中所述，我们可以使用UnconstrainedBox先抵消showDialog对宽度的约束，然后再使用SizedBox指定宽度*/
  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 26.0),
                child: Text("正在加载，请稍后..."),
              )
            ],
          ),
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker1() {
    var date = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: date.add(
        //未来30天可选
        Duration(days: 30),
      ),
    );
  }

  Future<DateTime?> _showDatePicker2() {
    var date = DateTime.now();
    return showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: date,
            maximumDate: date.add(
              Duration(days: 30),
            ),
            maximumYear: date.year + 1,
            onDateTimeChanged: (DateTime value) {
              print(value);
            },
          ),
        );
      },
    );
  }
}
