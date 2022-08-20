import 'package:flutter/material.dart';

class ImageTest extends StatefulWidget {
  const ImageTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image & Icon'),
        ),
        body: Column(
          children: [
            const Text(
              'Flutter 中，我们可以通过Image组件来加载并显示图片，Image的数据源可以是asset、文件、内存以及网络',
              maxLines: 2,
              style: TextStyle(color: Colors.cyan),
            ),
            const Text(
              'ImageProvider 是一个抽象类，主要定义了图片数据获取的接口load()，从不同的数据源获取图片需要实现不同的ImageProvider ，如AssetImage是实现了从Asset中加载图片的 ImageProvider，而NetworkImage 实现了从网络加载图片的 ImageProvider',
              maxLines: 2,
              style: TextStyle(color: Colors.cyanAccent),
            ),
            Column(
              children: [
                const Text('Image -> 从asset中加载图片'),
                Image(
                  image: const AssetImage('images/head.png'),
                  frameBuilder: (context, child, frame, wasAsyncLoad) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: child,
                    );
                  },
                  semanticLabel: 'semanticLabel', // 图像的语义描述
                  excludeFromSemantics: false, // 是否从语义中排除此图像
                  width: 100,
                  height: 120,
                  //color: Colors.black, // 图片的混合色值
                  // opacity: ,  // 透明动画
                  //colorBlendMode: BlendMode.srcIn, // 混合模式, 将 [color] 与此图像组合
                  fit: BoxFit.fitWidth, // 缩放模式
                  alignment: Alignment.bottomCenter, // 对齐方式
                  repeat: ImageRepeat.repeat, // 重复方式
                  //centerSlice: Rect.fromCenter(
                  //center: const Offset(0, 0), width: 10, height: 10),
                  //matchTextDirection: false, // 是否在 [TextDirection] 的方向上绘制图像。
                  gaplessPlayback:
                      false, //当图像提供者更改时，是否继续显示旧图像 (true) 或暂时不显示 (false)。 默认值为假。
                  isAntiAlias: false, //是否使用抗锯齿绘制图像。
                  filterQuality: FilterQuality.medium, // 图像的渲染质量。
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                    'Image -> 从网络加载图片, Image也提供了一个快捷的构造函数Image.network用于从网络加载、显示图片'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: const Image(
                        image: NetworkImage(
                            'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4',
                            scale: 1),
                        width: 100,
                      ),
                    ),
                    Image.network(
                      'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4',
                      width: 100,
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                    'ICON -> Flutter 中，可以像Web开发一样使用 iconfont，iconfont 即“字体图标”，它是将图标做成字体文件，然后通过指定不同的字符而显示不同的图片'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.accessible, color: Colors.green),
                    Icon(Icons.error, color: Colors.green),
                    Icon(Icons.fingerprint, color: Colors.green),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
