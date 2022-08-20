import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/05_1_padding_test.dart';
import 'package:flutter_01_text_app/05_4_container_test.dart';
import 'package:flutter_01_text_app/05_5_clip_test.dart';
import 'package:flutter_01_text_app/05_7_Scaffold_test.dart';
import 'package:flutter_01_text_app/06_2_SingleChildScrollView_test.dart';
import 'package:flutter_01_text_app/06_3_listview_test.dart';
import 'package:flutter_01_text_app/06_9_tabbarbiew_test.dart';
import 'package:flutter_01_text_app/align_center_layout.dart';
import 'package:flutter_01_text_app/05_2_decoratedbox_test.dart';
import 'package:flutter_01_text_app/flex_layout_test.dart';
import 'package:flutter_01_text_app/form_test.dart';
import 'package:flutter_01_text_app/image&icon_test.dart';
import 'package:flutter_01_text_app/progress_indicator.dart';
import 'package:flutter_01_text_app/radio_checkbox_test.dart';
import 'package:flutter_01_text_app/stack_positioned_layout.dart';
import 'package:flutter_01_text_app/textfield_test.dart';
import 'package:flutter_01_text_app/05_3_transform_test.dart';
import 'package:flutter_01_text_app/wrap_flow_layout_test.dart';

import 'button_test.dart';
import 'contraint_test.dart';
import 'row_colum_test.dart';

///Text
// void main() {
//   runApp(const MyApp());
// }

// /// Button
// void main() {
//   runApp(const ButtonTest());
// }

/// Image & Icon
// void main() {
//   runApp(const ImageTest());
// }

// Radio CheckBox
// void main() {
//   runApp(const RadioCheckBoxTest());
// }

/// TextField
// void main() {
//   runApp(const TextFieldTest());
// }

// / form
// void main() {
//   runApp(const FormTest());
// }

// / form
// void main() {
//   runApp(const ProgressIndicatorTest());
// }

// / Contraints Layout
// void main() {
//   runApp(const ContraintsTest());
// }

// Layout Row & Column
// void main() {
//   runApp(const RowColoumTest());
// }

// Layout Flex
// void main() {
//   runApp(const FlexLayoutTest());
// }

/// Layout -> Wrap Flow
// void main() {
//   runApp(const WrapFlowLayoutTest());
// }

/// Layout -> Stack Positioned
// void main() {
//   runApp(const StackPositionedLayoutTest());
// }

/// Layout -> Align Center
// void main() {
//   runApp(const AlignCenterLayoutTest());
// }

// Padding
// void main() {
//   runApp(const PaddingTest());
// }

/// DecoratedBox
// void main() {
//   runApp(const DecoratedBoxTest());
// }

/// Tansform
// void main() {
//   runApp(const TransformTest());
// }

/// Container
// void main() {
//   runApp(const ContainerTest());
// }

/// Clip
// void main() {
//   runApp(const ClipTest());
// }

/// ScaffoldTest
// void main() {
//   runApp(const ScaffoldTest());
// }

/// SingleChildScrollViewTest
// void main() {
//   runApp(const SingleChildScrollViewTest());
// }

/// ListView
void main() {
  runApp(const ListViewTest());
}

//TabBarView
// void main() {
//   runApp(const TabBarViewTest());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'hello world, hello world, hello world, hello world, hello world, hello world',
              style: TextStyle(
                color: Colors.red, // 字体颜色
                backgroundColor: Colors.cyan, // 背景颜色
                fontSize: 12, // 字体大小
                fontWeight: FontWeight.bold, // 字体粗细
                fontStyle: FontStyle.normal, // 倾斜字体
                letterSpacing: 2, // 字母之间的间距
                wordSpacing: 3, // 字符间距
                textBaseline: TextBaseline
                    .alphabetic, // 文本跨度与其父文本跨度之间对齐的公共基线，或者对于根文本跨度，应与行框对齐
                height: 1, // 文本的高度，作为字体大小的倍数
                leadingDistribution:
                    TextLeadingDistribution.proportional, // 搭配 height 一起使用
                locale: Locale('zh'), // 地区化
                // foreground: ,
                // background:
                shadows: [
                  Shadow(
                      color: Colors.blue, offset: Offset(1, 1), blurRadius: 4)
                ], // 阴影
                fontFeatures: [
                  FontFeature.alternativeFractions()
                ], // 影响字体如何选择字形的 [FontFeature] 列表。
                decoration: TextDecoration.underline, // 装饰
                decorationStyle: TextDecorationStyle.dashed, // 装饰类型
                decorationColor: Colors.black, // 装饰线颜色
                decorationThickness: 0.5, // 装饰线粗细
                fontFamily:
                    "PingFangSC-Regular", // 字体是在包中定义的，package必须为非空。 它与 fontFamily 参数结合来设置 [fontFamily] 属性。
                // fontFamilyFallback: ['PingFangSC-Regular'], // 多个 fontFamily 的集合
                // package: ,
                overflow: TextOverflow.ellipsis, // 裁剪
              ),
              // strutStyle: StrutStyle(), // 要使用的支柱样式。 Strut 样式定义了设置最小垂直布局度量的 strut。
              textAlign: TextAlign.center, // 对齐方式
              textDirection: TextDirection.ltr, // 文字方向
              // locale: , // 本地化
              softWrap: true, // 文本是否应该在软换行符处换行。
              overflow: TextOverflow.ellipsis, // 裁剪
              textScaleFactor:
                  1.5, // 当前字体大小的缩放因子，相对于去设置文本的样式style属性的fontSize，它是调整字体大小的一个快捷方式。该属性的默认值可以通过MediaQueryData.textScaleFactor获得，如果没有MediaQuery，那么会默认值将为1.0
              maxLines: 2,
              semanticsLabel: 'abc-cba', // 替代语义标签。
              textWidthBasis: TextWidthBasis.parent, // 如何测量渲染文本的宽度
              textHeightBehavior:
                  TextHeightBehavior(), // 如何在文本上方和下方应用 [TextStyle.height]
            ),
            RichText(
              text: const TextSpan(
                  text:
                      'Text 的所有文本内容只能按同一种样式，如果我们需要对一个 Text 内容的不同部分按照不同的样式显示，这时就可以使用TextSpan，它代表文本的一个“片段”。',
                  children: [
                    TextSpan(text: "Home: "),
                    TextSpan(
                      text: "https://flutterchina.club",
                      style: TextStyle(color: Colors.blue),
                      //recognizer: _tapRecognizer
                    ),
                  ],
                  style: TextStyle(color: Color.fromARGB(255, 109, 82, 81))),
            ),
            DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.0),
                textAlign: TextAlign.left,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DefaultTextStyle'),
                    Text(
                        '在 Widget 树中，文本的样式默认是可以被继承的（子类文本类组件未指定具体样式时可以使用 Widget 树中父级设置的默认样式）'),
                    Text(
                        '果在 Widget 树的某一个节点处设置一个默认的文本样式，那么该节点的子树中所有文本都会默认使用这个样式，而DefaultTextStyle正是用于设置默认文本样式的'),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  final _tapRecognizer = TapGestureRecognizer();
  // void _tapRecognizer(GestureRecognizer? ges) {

  // }
}
