import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContraintsTest extends StatefulWidget {
  const ContraintsTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ContraintsTestState();
}

class _ContraintsTestState extends State<ContraintsTest> {
  /* 
    尺寸限制类容器用于限制容器大小，Flutter中提供了多种这样的容器，如ConstrainedBox、SizedBox、UnconstrainedBox、AspectRatio 等.
    Flutter 中有两种布局模型：

      基于 RenderBox 的盒模型布局。
      基于 Sliver ( RenderSliver ) 按需加载列表布局。
    两种布局方式在细节上略有差异，但大体流程相同，布局流程如下：

      上层组件向下层组件传递约束（constraints）条件。
      下层组件确定自己的大小，然后告诉上层组件。注意下层组件的大小必须符合父组件的约束。
      上层组件确定下层组件相对于自身的偏移和确定自身的大小（大多数情况下会根据子组件的大小来确定自身的大小）。
  */

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('布局原理与约束 constraints '),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('ConstrainedBox -> 实现一个最小高度为50，宽度尽可能大的红色容器'),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 50,
                    ),
                    child: const DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red)),
                  ),
                  const Text('SizedBox -> 用于给子元素指定固定的宽高'),
                  const SizedBox(
                    width: 80,
                    height: 80,
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red)),
                  ),
                  const Text('实际上SizedBox只是ConstrainedBox的一个定制'),
                  ConstrainedBox(
                    // constraints: const BoxConstraints.tightFor(width: 80, height: 80), // 也等价于
                    constraints: const BoxConstraints(
                        minHeight: 80.0,
                        maxHeight: 80.0,
                        minWidth: 80.0,
                        maxWidth: 80.0),
                    child: const DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red)),
                  ),
                  const Text(
                      '多重限制 -> 如果某一个组件有多个父级ConstrainedBox限制，那么最终会是哪个生效?'),
                  // 有多重限制时，对于minWidth和minHeight来说，是取父子中相应数值较大的。实际上，只有这样才能保证父限制与子限制不冲突。
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                        minWidth: 60.0, minHeight: 60.0), //父
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: 90.0, minHeight: 20.0), //子
                      child: const DecoratedBox(
                          decoration: BoxDecoration(color: Colors.red)),
                    ),
                  ),
                  const Text(
                      'UnconstrainedBox -> 如果某一个组件有多个父级ConstrainedBox限制，那么最终会是哪个生效?'),
                  // 虽然任何时候子组件都必须遵守其父组件的约束，但前提条件是它们必须是父子关系，假如有一个组件 A，它的子组件是B，B 的子组件是 C，则 C 必须遵守 B 的约束，同时 B 必须遵守 A 的约束，但是 A 的约束不会直接约束到 C，除非B将A对它自己的约束透传给了C
                  ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: 60.0, minHeight: 100.0), //父
                      child: UnconstrainedBox(
                        //“去除”父级限制
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: 90.0, minHeight: 20.0), //子
                          child: const DecoratedBox(
                              decoration: BoxDecoration(color: Colors.red)),
                        ),
                      )),
                  // 请注意，UnconstrainedBox对父组件限制的“去除”并非是真正的去除：上面例子中虽然红色区域大小是90×20，但上方仍然有80的空白空间。也就是说父限制的minHeight(100.0)仍然是生效的，只不过它不影响最终子元素redBox的大小，但仍然还是占有相应的空间，可以认为此时的父ConstrainedBox是作用于子UnconstrainedBox上，而redBox只受子ConstrainedBox限制，这一点请读者务必注意

                  // 有什么方法可以彻底去除父ConstrainedBox的限制吗？答案是否定的！请牢记，任何时候子组件都必须遵守其父组件的约束，所以在此提示读者，在定义一个通用的组件时，如果要对子组件指定约束，那么一定要注意，因为一旦指定约束条件，子组件自身就不能违反约束

                  // 在实际开发中，当我们发现已经使用 SizedBox 或 ConstrainedBox 给子元素指定了固定宽高，但是仍然没有效果时，几乎可以断定：已经有父组件指定了约束！举个例子，如 Material 组件库中的AppBar（导航栏）的右侧菜单中，我们使用SizedBox指定了 loading 按钮的大小

                  // 会发现右侧loading按钮大小并没有发生变化！这正是因为AppBar中已经指定了actions按钮的约束条件，所以我们要自定义loading按钮大小，就必须通过UnconstrainedBox来 “去除” 父元素的限制

                  // 生效了！实际上将 UnconstrainedBox 换成 Center 或者 Align 也是可以的。

                  // 另外，需要注意，UnconstrainedBox 虽然在其子组件布局时可以取消约束（子组件可以为无限大），但是 UnconstrainedBox 自身是受其父组件约束的，所以当 UnconstrainedBox 随着其子组件变大后，如果UnconstrainedBox 的大小超过它父组件约束时，也会导致溢出报错

                  const Text('LimitedBox -> 用于指定最大宽高'),
                  const LimitedBox(
                    maxWidth: 50,
                    maxHeight: 50,
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red)),
                  ),
                  const Text('AspectRatio -> 指定子组件的长宽比'),
                  // const FractionallySizedBox(
                  //   widthFactor: 3,
                  //   heightFactor: 4,
                  //   child: DecoratedBox(
                  //       decoration: BoxDecoration(color: Colors.red)),
                  // ),
                  const Text('AspectRatio -> 指定子组件的长宽比'),
                  const AspectRatio(
                    aspectRatio: 3 / 4,
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red)),
                  ),
                ],
              ),
            )));
  }
}
