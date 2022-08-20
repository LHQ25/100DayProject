import 'package:flutter/material.dart';

class ButtonTest extends StatefulWidget {
  const ButtonTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ButtonTestState();
}

class _ButtonTestState extends State<ButtonTest> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Button'),
        ),
        body: Column(
          children: [
            const Text(
              'Material 组件库中提供了多种按钮组件如ElevatedButton、TextButton、OutlineButton等,它们都是直接或间接对RawMaterialButton组件的包装定制,所以他们大多数属性都和RawMaterialButton一样。在介绍各个按钮时我们先介绍其默认外观,而按钮的外观大都可以通过属性来自定义,我们在后面统一介绍这些属性',
              maxLines: 10,
              style: TextStyle(color: Colors.cyan),
            ),
            Column(
              children: [
                const Text(
                    'ElevatedButton: ElevatedButton 即"漂浮"按钮，它默认带有阴影和灰色背景。按下后，阴影会变大'),
                ElevatedButton(
                    onPressed: () => print('ElevatedButton'),
                    onLongPress: () => print("long press"),
                    onHover: ((value) => print('$value onHover')),
                    onFocusChange: (value) => print('$value onFocusChange'),
                    // style: ButtonStyle(),
                    focusNode: FocusNode(debugLabel: 'Debug button'),
                    autofocus: false,
                    clipBehavior: Clip.none,
                    child: const Text('ElevatedButton'))
              ],
            ),
            Column(
              children: [
                const Text('TextButton即文本按钮，默认背景透明并不带阴影。按下后，会有背景色'),
                TextButton(
                    onPressed: () => print('TextButton'),
                    child: const Text('TextButton'))
              ],
            ),
            Column(
              children: [
                const Text(
                    'OutlineButton默认有一个边框，不带阴影且背景透明。按下后，边框颜色会变亮、同时出现背景和阴影(较弱)'),
                OutlinedButton(
                    onPressed: () => print('OutlinedButton'),
                    child: const Text('OutlinedButton'))
              ],
            ),
            Column(
              children: [
                const Text(
                    'ElevatedButton、TextButton、OutlineButton都有一个icon 构造函数，通过它可以轻松创建带图标的按钮'),
                IconButton(
                  iconSize: 24,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  splashRadius: 8,
                  color: Colors.black,
                  focusColor: Colors.black38,
                  hoverColor: Colors.amber,
                  highlightColor: Colors.blue,
                  disabledColor: Colors.red,
                  onPressed: () => print('OutlinedButton'),
                  tooltip: 'OutlinedButton -> tooltip',
                  enableFeedback: true,
                  constraints: const BoxConstraints(maxWidth: 100),
                  icon: const Icon(Icons.thumb_up),
                ),
                TextButton.icon(
                    onPressed: () => print('TextButton'),
                    icon: const Icon(Icons.thumb_up),
                    label: const Text('TextButton')),
                ElevatedButton.icon(
                    onPressed: () => print('ElevatedButton'),
                    icon: const Icon(Icons.thumb_up),
                    label: const Text('ElevatedButton')),
                OutlinedButton.icon(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () => print('OutlinedButton'),
                    label: const Text('OutlinedButton'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
