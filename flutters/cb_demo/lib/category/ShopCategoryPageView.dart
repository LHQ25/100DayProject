import 'dart:developer';
import 'dart:ffi';

import 'package:cb_demo/util/SimpleColor.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                  padding: EdgeInsets.symmetric(horizontal: 15),
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
                    return Stack(
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
}
