import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class AuctionController extends StatefulWidget {
  const AuctionController({super.key});

  @override
  State<AuctionController> createState() => _AuctionControllerState();
}

class _AuctionControllerState extends State<AuctionController> {
  double _navAlpha = 0;
  final _images = ["assets/images/banner/1.png", "assets/images/banner/2.png"];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {
          double offset = _scrollController.offset;
          _navAlpha = min(255, (offset / 300) * 255);
        }));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, value) {
              return _createHeaderView();
            },
            body: ListView()),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white.withAlpha(_navAlpha.toInt()),
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
                          padding:
                              const EdgeInsets.only(left: 21.5, right: 12.5),
                          child: Image.asset(
                            "assets/images/home/home_appbar_search_msg.png",
                            width: 17.5,
                            height: 17.5,
                          ),
                        ),
                        const SizedBox(
                          width: 1,
                          height: 10,
                          child: ColoredBox(color: Color(0xFFE6E6E8)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.5),
                          child: Image.asset(
                            "assets/images/home/home_appbar_search_search.png",
                            width: 17.5,
                            height: 17.5,
                          ),
                        ),
                        const Text(
                          "搜索更多拍品、场次",
                          style: TextStyle(
                              color: Color(0xFFA1A3A6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )),
            )),
      ],
    );
  }

  List<Widget> _createHeaderView() {
    return [
      SliverToBoxAdapter(
        child: SizedBox(
          width: double.infinity,
          height: 358,
          child: Swiper(
            containerHeight: 358,
            containerWidth: double.infinity,
            autoplay: true,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.fitWidth,
              );
            },
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Image.asset(
                    "assets/images/home/home_auction.png",
                    width: 66,
                    height: 66,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      "拍卖行",
                      style: mediumStyle(
                          fontSize: 11, color: const Color(0xFF6B6B6E)),
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Image.asset(
                    "assets/images/home/home_pai.png",
                    width: 66,
                    height: 66,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      "拍卖结果",
                      style: mediumStyle(
                          fontSize: 11, color: const Color(0xFF6B6B6E)),
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Image.asset(
                    "assets/images/home/home_calendar.png",
                    width: 66,
                    height: 66,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      "拍卖日历",
                      style: mediumStyle(
                          fontSize: 11, color: const Color(0xFF6B6B6E)),
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Image.asset(
                    "assets/images/home/home_wait.png",
                    width: 66,
                    height: 66,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      "送拍",
                      style: mediumStyle(
                          fontSize: 11, color: const Color(0xFF6B6B6E)),
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Image.asset(
                    "assets/images/home/home_wait.png",
                    width: 66,
                    height: 66,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      "鉴定",
                      style: mediumStyle(
                          fontSize: 11, color: const Color(0xFF6B6B6E)),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
          child: Container(
        // height: 30,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
        child: Column(
          children: [
            SizedBox.fromSize(
              size: const Size(double.infinity, 1),
              child: const ColoredBox(color: Color(0xFFE6E6E8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/home/home_zx.png",
                    width: 66.5,
                    height: 16.5,
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "2020年全球当代艺术市场报告——新时代吹响…",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF4F4F51)),
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/images/home/home_more.png",
                    width: 15,
                    height: 15,
                  ),
                ],
              ),
            ),
            SizedBox.fromSize(
              size: const Size(double.infinity, 1),
              child: const ColoredBox(color: Color(0xFFE6E6E8)),
            ),
            // PageView(
            //   children: const [Text("data")],
            // )
          ],
        ),
      )),
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 22, 14, 0),
          child: Column(
            children: [
              Container(
                height: 30,
                child: Row(
                  children: const [
                    Text(
                      "全球拍",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222222),
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      "查看更多",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      " >",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                height: 105,
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border:
                        Border.all(color: const Color(0xFFE6E6E8), width: 0.5)),
                child: PageView.builder(
                    clipBehavior: Clip.none,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 105,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 128.5,
                              height: 105,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/test/test1.png",
                                    width: 128.5,
                                    height: 105,
                                  ),
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4),
                                                bottomRight:
                                                    Radius.circular(4)),
                                            color: Color(0xFF27258F)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 2, 4, 2),
                                          child: Text(
                                            "全球拍",
                                            style: mediumStyle(
                                                fontSize: 9,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: SizedBox(
                                        height: 16.5,
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                    const Color(0xFFF72800),
                                                    const Color(0xFFF72800)
                                                        .withAlpha(25)
                                                  ])),
                                              width: 55.5,
                                              child: Text(
                                                "直播中",
                                                style: mediumStyle(
                                                    fontSize: 9,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              color:
                                                  Colors.black.withAlpha(127),
                                              width: 55.5,
                                              child: Text(
                                                "2330次围观",
                                                style: mediumStyle(
                                                    fontSize: 9,
                                                    color: Colors.white),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 4, 10, 0),
                                  child: Text(
                                    "中国嘉德2021春季拍卖会 瓷器及古董珍玩集萃",
                                    maxLines: 2,
                                    style: mediumStyle(
                                        fontSize: 13,
                                        color: const Color(0xFF111111)),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(10, 14, 10, 0),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2.5)),
                                    child: LinearProgressIndicator(
                                      value: 0.5,
                                      color: Colors.red,
                                      backgroundColor: Color(0xFFE7E7ED),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(
                                    "第102件/345件",
                                    style: semiboldStyle(
                                        fontSize: 11,
                                        color: const Color(0xFF333333)),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 6, 10, 0),
                                  child: Text(
                                    "藏宝拍卖",
                                    style: regularStyle(
                                        fontSize: 11,
                                        color: const Color(0xFF666666)),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 22, 14, 0),
          child: Column(
            children: [
              Container(
                height: 30,
                child: Row(
                  children: const [
                    Text(
                      "专场拍",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222222),
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      "查看更多",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      " >",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border:
                        Border.all(color: const Color(0xFFE6E6E8), width: 0.5)),
                child: PageView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.red,
                        child: Column(
                          children: [
                            Container(
                              constraints: const BoxConstraints(minHeight: 129),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/test/test2.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(4)),
                                            color: Colors.black.withAlpha(127)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 2, 4, 2),
                                          child: Text(
                                            "距开拍 16 天",
                                            style: mediumStyle(
                                                fontSize: 9,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //     height: 50,
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Row(
                            //           children: [Text("data")],
                            //         )
                            //       ],
                            //     ))
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    ];
  }
}

TextStyle regularStyle({required double fontSize, required Color color}) =>
    TextStyle(fontWeight: FontWeight.w400, fontSize: fontSize, color: color);

TextStyle mediumStyle({required double fontSize, required Color color}) =>
    TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize, color: color);

TextStyle semiboldStyle({required double fontSize, required Color color}) =>
    TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize, color: color);
