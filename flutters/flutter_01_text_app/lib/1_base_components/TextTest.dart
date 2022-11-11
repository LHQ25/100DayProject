import 'dart:ui';

import 'package:flutter/material.dart';

class TextTest extends StatefulWidget {
  const TextTest({Key? key}) : super(key: key);

  @override
  State<TextTest> createState() => _TextTestState();
}

class _TextTestState extends State<TextTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text"),
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
                style: const TextStyle(color: Colors.red, fontSize: 20.0),
                textAlign: TextAlign.left,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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
}
