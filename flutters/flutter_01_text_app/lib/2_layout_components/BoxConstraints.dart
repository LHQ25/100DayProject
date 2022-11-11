import 'package:flutter/material.dart';

class BoxConstraintsTest extends StatefulWidget {

  const BoxConstraintsTest({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _BoxConstraintsTestState();
}

class _BoxConstraintsTestState extends State<BoxConstraintsTest> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("什么是紧约束"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("紧约束 一词来自于 BoxConstraints 类中的 tight 构造。我们知道，通过 BoxConstraints 约束可以设置宽高的取值区间"),
            Container(
              color: Colors.red,
              constraints: BoxConstraints.tight(const Size(200, 200)),
              child: const SizedBox(
                width: 150,
                height: 150,
                child: ColoredBox(
                  color: Colors.cyan,
                  child: Center(
                    child: Text("BoxConstraints, minWidth: 200, minHeight: 200, ColoredBox的大小和BoxConstraints约束的是一样的, ColoredBox限制的约束不起作用： 在父级是紧约束的条件下，SizedBox 无法对子级的尺寸进行修改",
                      maxLines: 13,
                      textAlign: TextAlign.center,),
                  ),
                ),
              )
            ),
            const Text("如何打破紧约束"),
            const Text("通过 UnconstrainedBox [解除约束]，让自身约束变为 [无约束]"),
            Container(
                color: Colors.red,
                constraints: BoxConstraints.tight(const Size(200, 200)),
                child: const UnconstrainedBox(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: ColoredBox(
                      color: Colors.cyan,
                      child: Center(
                        child: Text("UnconstrainedBox: 解除父级的约束，但是本身的大小是父级的大小， SizedBox可以自由设置大小",
                          maxLines: 13,
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                )
            ),
            const Text("通过 Align、Flex 等组件 [放松约束]，让自身约束变为 [松约束]"),
            const Text("除了 Align 组件有放宽约束的能力之外，还有如 Flex 、 Column、Row、 Wrap 、Stack 等组件可以让父级的紧约束在一定程度上变得宽松"),
            Container(
                color: Colors.red,
                constraints: BoxConstraints.tight(const Size(200, 200)),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: ColoredBox(
                      color: Colors.cyan,
                      child: Center(
                        child: Text("UnconstrainedBox: 解除父级的约束，但是本身的大小是父级的大小， SizedBox可以自由设置大小",
                          maxLines: 13,
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                )
            ),
            const Text("3. 自定义布局重新设置约束"),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("前面的两种方式是在原紧约束下，解除 或 放松 约束。有没有一种方式，可以让我们自由地改变子级的约束，改成什么约束就是什么约束？不像 SizedBox 那样，添加个强约束，还要看父级约束的 脸色 "),
            ),
            const Text("过 CustomSingleChildLayout 组件进行实现。如下，自定义 DiyLayoutDelegate ，通过覆写 getConstraintsForChild 方法可以随意修改子级的约束"),
            Container(
                color: Colors.red,
                constraints: BoxConstraints.tight(const Size(200, 200)),
                child: CustomSingleChildLayout(
                  delegate: DiyLayoutDelegate(),
                  child: const ColoredBox(
                      color: Colors.cyan,
                      child: Center(
                        child: Text("UnconstrainedBox: 解除父级的约束，但是本身的大小是父级的大小， SizedBox可以自由设置大小",
                          maxLines: 13,
                          textAlign: TextAlign.center,),
                      ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class DiyLayoutDelegate extends SingleChildLayoutDelegate {

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => false;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {

    return BoxConstraints.tight(const Size(180, 180));
  }

}