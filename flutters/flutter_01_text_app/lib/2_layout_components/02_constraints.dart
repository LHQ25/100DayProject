import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConstraintsTest extends StatefulWidget {
  const ConstraintsTest({Key? key}) : super(key: key);

  @override
  State<ConstraintsTest> createState() => _ConstraintsTestState();
}

class _ConstraintsTestState extends State<ConstraintsTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("盒约束"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8), 
              child: Column(
                children: const [
                  Text("MaterialApp 组件下约束信息MaterialApp 作为开发中必备的组件 ，其本身是 StatefulWidget ，所以它的本质是若干组件的集合体。其中集成了非常多的组件，来实现应用的基础需求"),
                  Text("集成 AnimatedTheme 、 Theme 、Localizations 组件处理应用主题和语言"),
                  Text("集成 ScrollConfiguration 、Directionality、 PageStorage 、PrimaryScrollController 、MediaQuery 等 InheritedWidget 组件为子级节点提供全局信息。"),
                  Text("集成 Navigator 与 Router 组件处理路由跳转。"),
                  Text("集成 WidgetInspector 、PerformanceOverlay 等调试信息组件。"),
                  Text("集成 Shortcuts 与 Actions 等组件处理桌面端快捷键。"),
                  
                  Text("在渲染树中，从 root 节点开始依次向子级传递 盒约束，期间 MaterialApp 内含的众多渲染对象，都没有对约束的大小进行修改，其值是向下层层传递的")
                ],
              ),
            ),
            const Divider(color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: const [
                  Text("Scaffold 组件 似乎 拥有解除紧约束的能力"),
                  Text("Scaffold 组件确实可以打破父级的 紧约束，为其下级提供一个松约束。在松约束下， ConstrainedBox 组件施加的紧约束就可以作用于 ColoredBox 组件 或 类似组件"),
                  Text("严格意义上来说，Scaffold 组件并非是 布局组件。它继承自 StatefulWidget ，就决定了它只是进行组合组件而已。 Scaffold 组件是一个组件集合体，本质上来说是它内部的某个 布局组件 拥有打破紧约束的能力。从布局信息树中也可以看出，将紧约束修改为宽松约束的组件是 CustomMultiChildLayout 。它属于上一章中提到的第三种方式：通过自定义布局修改盒约束"),
                ],
              ),
            ),
            const Divider(color: Colors.grey,),
            const Text("Flex 组件下的约束", style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.start,),
            const Text("Row 本质上是 direction: Axis.horizontal 的 Flex 组件；Column 本质上是 direction: vertical 的 Flex 组件"),
            Flex(
              direction: Axis.horizontal,
              children: [
                Container(
                  color: Colors.blue,
                  width: 100,
                  height: 100,
                  child: const Text("Flex 在父级是紧约束的情况下，会为孩子提高相对宽松的约束。也就是说 Flex 内部可以在 约束传递 过程中修改约束", overflow: TextOverflow.clip,),
                ),
                LayoutBuilder(builder: (context, constraints){
                  if (kDebugMode) {
                    print(constraints);
                  }
                  return Container(
                    color: Colors.red,
                    width: 100,
                    height: 100,
                    child: const Text("Flex 的 children 列表中的组件，所受到的约束都是一致的。", overflow: TextOverflow.clip,),
                  );
                })
              ],
            ),
            const Text("默认情况下，Flex 施加约束的特点: 在 [主轴] 方向上 [无限约束]，在 [交叉轴] 方向上 [放松约束]。"),
            const Divider(color: Colors.grey,),
            const Text("Wrap 组件下的约束", style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.start,),
            const Text("可以说 Flex 组件的布局很 执拗 ，脑子不会 “拐弯” 。如下左图，四个 100*100 的色块，通过水平方向的 Flex 摆放，就会超出边界。而水平方向 Wrap 会自己拐弯，排不下会自动换行，这些都可以通过约束来解释"),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: [
                Container(
                  color: Colors.red,
                  width: 100,
                  height: 100,
                ),
                Container(
                  color: Colors.green,
                  width: 100,
                  height: 100,
                ),
                Container(
                  color: Colors.blue,
                  width: 100,
                  height: 100,
                ),
                Container(
                  color: Colors.purple,
                  width: 100,
                  height: 100,
                )
              ],
            ),
            const Text("默认情况下，Wrap 施加约束的特点: 在 [主轴] 方向上 [放松约束] 也就是说可以自定义主轴上的大小，但是不能超过父级的大小，在 [交叉轴] 方向上 [无限约束]。"),
            const Text("Wrap 的 children 列表中的组件，所受到的约束都是一致的。"),

            const Divider(color: Colors.grey,),
            const Text("Stack 组件下的约束", style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.start,),
            const Text("Stack 组件可以将多个组件进行叠放"),
            Stack(
              fit: StackFit.loose,
              // StackFit.loose：提供宽松的约束；
              // StackFit.expand：Stack 会将自身受到约束的最大尺寸，作为强约束，施加给孩子们；
              // StackFit.passthrough ， Stack 会将自身受到的约束原封不动的施加给子级
              children: [
                Container(
                  color: Colors.red,
                  width: 150,
                  height: 150,
                ),
                Container(
                  color: Colors.green,
                  width: 130,
                  height: 130,
                ),
                Container(
                  color: Colors.blue,
                  width: 90,
                  height: 90,
                ),
                Container(
                  color: Colors.purple,
                  width: 60,
                  height: 60,
                )
              ],
            ),
            const Text("Stack 施加约束的特点: \n [1]: loose 下,  宽高尽可能 [放松约束]。\n [2]: expand 下,  施加 [强约束]，约束尺寸为自身受到约束的 [最大尺寸]。\n[3]: passthrough 下,  仅 [传递约束]，把自身受到的约束原封不动的施加给子级。\n[4]: Stack 的 children 列表中的组件，所受到的约束都是一致的。")
          ],
        ),
      ),
    );
  }
}


