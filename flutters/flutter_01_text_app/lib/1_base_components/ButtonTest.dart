import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/elevent_part/RestClient.dart';

class ButtonTest extends StatefulWidget {
  const ButtonTest({Key? key}) : super(key: key);

  @override
  State<ButtonTest> createState() => _ButtonTestState();
}

class _ButtonTestState extends State<ButtonTest> {
  final _stateController = MaterialStatesController();

  @override
  void initState() {
    super.initState();

    // HttpWork()
    // ..request(Api.);

    // 更新状态
    // _stateController.update(MaterialState.selected, true);
    final states = _stateController.value;
    debugPrint("按钮状态 $states");

    _stateController.addListener(() {
      debugPrint("按钮状态 ${_stateController.value}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Button'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Material 组件库中提供了多种按钮组件如ElevatedButton、TextButton、OutlineButton等,它们都是直接或间接对RawMaterialButton组件的包装定制,'
                '所以他们大多数属性都和RawMaterialButton一样。在介绍各个按钮时我们先介绍其默认外观,而按钮的外观大都可以通过属性来自定义,我们在后面统一介绍这些属性',
                maxLines: 10,
                style: TextStyle(color: Colors.cyan),
              ),
              const Text(
                  'ElevatedButton: ElevatedButton 即"漂浮"按钮，它默认带有阴影和灰色背景。按下后，阴影会变大'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () =>
                          _stateController.update(MaterialState.selected, true),
                      onLongPress: () => print("long press"),
                      onHover: ((value) => print('$value onHover')),
                      onFocusChange: (value) => print('$value onFocusChange'),
                      style: ButtonStyle(
                          // Button 样式 自定义
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(8)),
                          backgroundColor: const MaterialStatePropertyAll(
                              Colors.red)), // (Colors.green)),
                      focusNode: FocusNode(debugLabel: 'Debug button'),
                      autofocus: false, // 获得焦点
                      clipBehavior: Clip.none, // 裁剪
                      statesController: _stateController,
                      child: const Text('ElevatedButton')),
                  ElevatedButton.icon(
                    onPressed: () => print('ElevatedButton'),
                    icon: const Icon(Icons.thumb_up),
                    label: const Text('ElevatedButton'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.redAccent),
                  ),
                ],
              ),
              const Text('TextButton即文本按钮，默认背景透明并不带阴影。按下后，会有背景色'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () => print('TextButton'),
                      statesController: _stateController,
                      child: const Text('TextButton')),
                  TextButton.icon(
                    onPressed: () => print('TextButton'),
                    icon: const Icon(Icons.thumb_up),
                    label: const Text('TextButton'),
                    style: TextButton.styleFrom(foregroundColor: Colors.cyan),
                  ),
                ],
              ),
              const Text(
                  'OutlineButton默认有一个边框，不带阴影且背景透明。按下后，边框颜色会变亮、同时出现背景和阴影(较弱)'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: () => print('OutlinedButton'),
                      statesController: _stateController,
                      child: const Text('OutlinedButton')),
                  OutlinedButton.icon(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () => print('OutlinedButton'),
                      label: const Text('OutlinedButton'))
                ],
              ),
              const Text('ToggleButtons'),
              ToggleButtons(
                isSelected: const [false, true, false],
                selectedColor: Colors.red,
                children: const [
                  Icon(Icons.import_contacts_sharp),
                  Icon(Icons.abc),
                  Icon(Icons.add)
                ],
              ),
              const Text(
                  'ElevatedButton、TextButton、OutlineButton都有一个icon 构造函数，通过它可以轻松创建带图标的按钮'),
              IconButton(
                iconSize: 24,
                visualDensity: VisualDensity.comfortable,
                padding: const EdgeInsets.all(18),
                alignment: Alignment.center,
                splashRadius: 8,
                color: Colors.red,
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
              const Text('CloseButton'),
              const CloseButton(
                color: Colors.purple,
                onPressed: null,
              ),
              const Text('BackButton'),
              const BackButton(
                color: Colors.purple,
                onPressed: null,
              ),
            ],
          ),
        ));
  }
}

class MyButton extends ButtonStyleButton {
  const MyButton(
      {super.key,
      required super.onPressed,
      required super.onLongPress,
      required super.onHover,
      required super.onFocusChange,
      required super.style,
      required super.focusNode,
      required super.autofocus,
      required super.clipBehavior,
      required super.child});

  @override
  State<ButtonStyleButton> createState() => _MyButtonState();

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    return const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.redAccent));
  }

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    return null;
  }
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(
          Icons.sunny,
          size: 20,
        ),
        Text("data")
      ],
    );
  }
}
