import 'dart:developer';

import 'package:cb_demo/util/SimpleColor.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class GoodsCategoryPageView extends StatefulWidget {
  const GoodsCategoryPageView({super.key});

  @override
  State<GoodsCategoryPageView> createState() => _GoodsCategoryPageViewState();
}

class _GoodsCategoryPageViewState extends State<GoodsCategoryPageView> {
  final _bigCate = ["亚洲艺术", "西方艺术", "珠宝钟表", "家具装饰", "潮玩尚品", "珍茗佳酿", "其他类别"];
  int _bigCateSelectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            height: 46,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        "assets/images/home/home_appbar_search_bg2.png"))),
            child: GestureDetector(
              onTap: () => print("去搜索"),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.5),
                    child: Image.asset(
                      "assets/images/home/home_appbar_search_search.png",
                      width: 17.5,
                      height: 17.5,
                    ),
                  ),
                  const Text(
                    "搜索",
                    style: TextStyle(
                        color: Color(0xFFA1A3A6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )),
      ),
      body: Flex(
        direction: Axis.horizontal,
        children: [
          SizedBox(
            width: 100,
            height: double.infinity,
            child: ColoredBox(
                color: Colors.white,
                child: ListView.builder(
                  itemExtent: 48.5,
                  itemCount: _bigCate.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        _bigCateSelectIndex = index;
                      }),
                      child: ColoredBox(
                          color: _bigCateSelectIndex == index
                              ? const Color(0xFFF5F5F8)
                              : Colors.white,
                          child: Center(
                            child: Text(
                              _bigCate[index],
                              style: _bigCateSelectIndex == index
                                  ? semiBoldStyle(
                                      fontSize: 13, color: color333333)
                                  : mediumStyle(
                                      fontSize: 13, color: color666666),
                            ),
                          )),
                    );
                  },
                )),
          ),
          Expanded(
              child: Flex(
            direction: Axis.vertical,
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                        spacing: 5,
                        children: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                            .map((e) => ChoiceChip(
                                onSelected: (value) => log("选中 $e"),
                                padding: EdgeInsets.zero,
                                labelPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                selectedColor: Colors.transparent,
                                disabledColor: Colors.transparent,
                                label: Container(
                                    height: 20,
                                    width: 56,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF444445),
                                          Color(0xFF757577)
                                        ])),
                                    child: Center(
                                      child: Text(
                                        "西方绘画",
                                        style: mediumStyle(
                                            fontSize: 11, color: Colors.white),
                                      ),
                                    )),
                                selected: false))
                            .toList()),
                  ),
                ),
              ),
              Expanded(
                child: MasonryGridView.builder(
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: 6,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => test(context),
                      child: Stack(
                        children: [
                          Image.asset("assets/images/test/test_a_0.png"),
                          Positioned(
                              bottom: 9,
                              child: Center(
                                child: Text(
                                  "古典大师绘画",
                                  style: mediumStyle(
                                      fontSize: 11, color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  void test(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        builder: (context) {
          return TurnTableSheetView();
        });
  }
}

class TurnTableSheetController extends GetxController {
  final _segmentController1 = MaterialStatesController();
  final _segmentController2 = MaterialStatesController();

  MaterialStatesController get controller => _segmentController1;
  MaterialStatesController get controller2 => _segmentController2;

  @override
  void onInit() {
    _segmentController1.update(MaterialState.selected, true);
    super.onInit();
  }
}

class TurnTableSheetView extends StatelessWidget {
  TurnTableSheetView({super.key});

  final controller = Get.put(TurnTableSheetController());

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 375.0 / 570.0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF9A76FF), Color(0xFF586FFF)])),
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.controller
                          .update(MaterialState.selected, true);
                      controller.controller2
                          .update(MaterialState.selected, false);
                    },
                    style: ButtonStyle(
                        textStyle: const MaterialStatePropertyAll(TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                        foregroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFFFEFFFF);
                          }
                          return const Color(0xFFFEFFFF).withOpacity(0.6);
                        }),
                        splashFactory: NoSplash.splashFactory,
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.only(left: 0, right: 24))),
                    statesController: controller.controller,
                    child: const Text(
                      "普通排行榜",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.controller
                          .update(MaterialState.selected, false);
                      controller.controller2
                          .update(MaterialState.selected, true);
                    },
                    style: ButtonStyle(
                        textStyle: const MaterialStatePropertyAll(TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                        foregroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFFFEFFFF);
                          }
                          return const Color(0xFFFEFFFF).withOpacity(0.6);
                        }),
                        splashFactory: NoSplash.splashFactory,
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.only(left: 24, right: 0))),
                    statesController: controller.controller2,
                    child: const Text("高级排行榜"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12, top: 2, right: 12),
              height: 27,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.white.withOpacity(0),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0)
              ], stops: const [
                0,
                0.5,
                1
              ])),
              child: Text(
                "将在7:23:56后结榜",
                // textAlign: TextAlign.center,
                style: mediumStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            AspectRatio(
              aspectRatio: 375.0 / 222.0,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/test/test6.png"),
                        fit: BoxFit.fitWidth)),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Transform(
                          transform: Matrix4.translationValues(0, 71, 0),
                          child: Image.asset(
                            "assets/images/test/test5.png",
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                            child: Transform.translate(
                          offset: const Offset(0, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "这里是昵称昵称",
                                  style: mediumStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                              Text("幸运值：1442",
                                  style: mediumStyle(
                                      fontSize: 12, color: Colors.white))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Transform.translate(
                          offset: const Offset(0, -20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "这里是昵称昵称",
                                  style: mediumStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                              Text("幸运值：1442",
                                  style: mediumStyle(
                                      fontSize: 12, color: Colors.white))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Transform.translate(
                          offset: const Offset(0, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "这里是昵称昵称",
                                  style: mediumStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                              Text("幸运值：1442",
                                  style: mediumStyle(
                                      fontSize: 12, color: Colors.white))
                            ],
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: ColoredBox(
                  color: Colors.white,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: Text(
                              "$index",
                              style: regularStyle(
                                  fontSize: 14, color: color999999),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 6, right: 8),
                            child: CircleAvatar(),
                          ),
                          Text(
                            "这里是昵称啊",
                            style:
                                regularStyle(fontSize: 14, color: color333333),
                          ),
                          const Spacer(),
                          Text(
                            "1122幸运值",
                            style:
                                mediumStyle(fontSize: 12, color: color333333),
                          ),
                        ],
                      );
                    },
                    itemCount: 4,
                    itemExtent: 58,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
