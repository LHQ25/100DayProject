import 'dart:ffi';

import 'package:flutter/material.dart';

class FlexTest extends StatefulWidget {
  const FlexTest({Key? key}) : super(key: key);

  @override
  State<FlexTest> createState() => _FlexTestState();
}

class _FlexTestState extends State<FlexTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flex 布局"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                "Flex组件可以沿着水平或垂直方向排列子组件，如果你知道主轴方向，使用Row或Column会方便一些，因为Row和Column都继承自Flex，参数基本相同，所以能使用Flex的地方基本上都可以使用Row或Column。Flex本身功能是很强大的，它也可以和Expanded组件配合实现弹性布局"),
            Container(
              color: Colors.black,
              margin: const EdgeInsets.all(10),
              height: 200,
              child: Flex(
                direction: Axis.horizontal,
                children: const [
                  SizedBox(
                    width: 50, // 主轴上 宽松约束
                    height: double.infinity, // 纵轴上 严格约束，不能超过父级
                    child: ColoredBox(color: Colors.red),
                  ),
                  Expanded(
                      child: SizedBox(
                    height: double.infinity,
                    child: ColoredBox(
                      color: Colors.cyan,
                      child: Center(
                        child: Text("剩下全部空间"),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  const Text("Expanded"),
                  const Text(
                      "Expanded 只能作为 Flex 的孩子（否则会报错），它可以按比例“扩伸”Flex子组件所占用的空间。因为 Row和Column 都继承自 Flex，所以 Expanded 也可以作为它们的孩子\n"),
                  const Text(
                      "flex参数为弹性系数，如果为 0 或null，则child是没有弹性的，即不会被扩伸占用的空间。如果大于0，所有的Expanded按照其 flex 的比例来分割主轴的全部空闲空间\n"),
                  Flex(
                    direction: Axis.horizontal,
                    children: const [
                      Expanded(
                          flex: 2,
                          child: SizedBox(
                            child: ColoredBox(
                              color: Colors.green,
                              child: Center(
                                child: Text("Flex : 2"),
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: SizedBox(
                            child: ColoredBox(
                              color: Colors.red,
                              child: Center(
                                child: Text("Flex : 2"),
                              ),
                            ),
                          )),
                      Expanded(
                          child: SizedBox(
                        child: ColoredBox(
                          color: Colors.blue,
                          child: Center(
                            child: Text("Flex : 1"),
                          ),
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  const Text("Expanded"),
                  const Text("\t\tSpacer的功能是占用指定比例的空间，实际上它只是Expanded的一个包装类"),
                  Flex(
                    direction: Axis.horizontal,
                    children: const [
                      Expanded(
                          flex: 2,
                          child: SizedBox(
                            child: ColoredBox(
                              color: Colors.green,
                              child: Center(
                                child: Text("Flex : 2"),
                              ),
                            ),
                          )),
                      Spacer(
                        flex: 2,
                      ),
                      Expanded(
                          flex: 2,
                          child: SizedBox(
                            child: ColoredBox(
                              color: Colors.red,
                              child: Center(
                                child: Text("Flex : 2"),
                              ),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
