import 'package:flutter/material.dart';

class RadioCheckBoxTest extends StatefulWidget {
  const RadioCheckBoxTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RadioCheckBoxTestState();
}

class _RadioCheckBoxTestState extends State<RadioCheckBoxTest> {
  bool _switchSelected = true; //维护单选开关状态
  bool? _checkboxSelected = true; //维护复选框状态

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Switch和复选框Checkbox'),
        ),
        body: Column(
          children: [
            const Text(
              '虽然它们都是继承自StatefulWidget，但它们本身不会保存当前选中状态，选中状态都是由父组件来管理的。当Switch或Checkbox被点击时，会触发它们的onChanged回调，我们可以在此回调中处理选中状态改变逻辑',
              maxLines: 2,
              style: TextStyle(color: Colors.cyan),
            ),
            Column(
              children: [
                Switch(
                    value: _switchSelected,
                    onChanged: (value) {
                      setState(() {
                        _switchSelected = value;
                      });
                    }),
                Checkbox(
                    value: _checkboxSelected,
                    onChanged: (value) {
                      setState(() {
                        _checkboxSelected = value;
                      });
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
