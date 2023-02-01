import 'dart:developer' as dev show log;
import 'package:cb_demo/auction/controller/AuctionMainController.dart';
import 'package:cb_demo/auction/views/gloabel_auction_view.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';

import '../../../custom_view/UnderlineGradientTabIndicator.dart';
import '../../../util/TextStyle.dart';
import 'AuctionListPageView.dart';

class AuctionMainView extends StatelessWidget {
  AuctionMainView({super.key});

  final _controller = Get.put(AuctionMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(_controller.navAlpha.value),
          automaticallyImplyLeading: false,
          title: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              height: 46,
              decoration: const BoxDecoration(
                  image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/images/home/home_appbar_search_bg2.png"))),
              child: GestureDetector(
                onTap: () => dev.log("去搜索"),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 21.5, right: 12.5),
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
                      style: TextStyle(color: Color(0xFFA1A3A6), fontSize: 13, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )),
        ),
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
            controller: _controller.scrollController,
            headerSliverBuilder: (context, value) {
              return _createHeaderView();
            },
            body: Obx(() => TabBarView(
                controller: _controller.tabController,
                children: _controller.isVer.value == false
                    ? const [
                        AuctionGridPageView(),
                        AuctionGridPageView(),
                        AuctionGridPageView(),
                        AuctionGridPageView(),
                        AuctionGridPageView(),
                      ]
                    : const [
                        AuctionListPageView(),
                        AuctionListPageView(),
                        AuctionListPageView(),
                        AuctionListPageView(),
                        AuctionListPageView(),
                      ]))));
  }

  List<Widget> _createHeaderView() {
    return [
      // SliverPersistentHeader(
      //   pinned: true,
      //   delegate: SliverHeaderDelegate.fixedHeight(
      //       height: 88,
      //       child: ),
      // ),

      /// Banner
      SliverToBoxAdapter(
        child: SizedBox(
          width: double.infinity,
          height: 358,
          child: Swiper(
            containerHeight: 358,
            containerWidth: double.infinity,
            autoplay: true,
            itemCount: _controller.images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _controller.images[index],
                fit: BoxFit.fitWidth,
              );
            },
          ),
        ),
      ),

      /// 分类
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
                      style: mediumStyle(fontSize: 11, color: const Color(0xFF6B6B6E)),
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
                      style: mediumStyle(fontSize: 11, color: const Color(0xFF6B6B6E)),
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
                      style: mediumStyle(fontSize: 11, color: const Color(0xFF6B6B6E)),
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
                      style: mediumStyle(fontSize: 11, color: const Color(0xFF6B6B6E)),
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
                      style: mediumStyle(fontSize: 11, color: const Color(0xFF6B6B6E)),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),

      /// 直播
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
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF4F4F51)),
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

      /// 拍1
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 22, 14, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Get.to(() => GlobelAuctionView()),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: const [
                      Text(
                        "全球拍1",
                        style: TextStyle(fontSize: 16, color: Color(0xFF222222), fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        "查看更多",
                        style: TextStyle(fontSize: 11, color: Color(0xFF999999), fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " >",
                        style: TextStyle(fontSize: 11, color: Color(0xFF888888), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 115,
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: const Color(0xFFE6E6E8), width: 0.5)),
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
                                            borderRadius:
                                                BorderRadius.only(topLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                                            color: Color(0xFF27258F)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                          child: Text(
                                            "全球拍",
                                            style: mediumStyle(fontSize: 9, color: Colors.white),
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
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [const Color(0xFFF72800), const Color(0xFFF72800).withAlpha(25)])),
                                              width: 55.5,
                                              child: Text(
                                                "直播中",
                                                style: mediumStyle(fontSize: 9, color: Colors.white),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              color: Colors.black.withAlpha(127),
                                              width: 55.5,
                                              child: Text(
                                                "2330次围观",
                                                style: mediumStyle(fontSize: 9, color: Colors.white),
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
                                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                                  child: Text(
                                    "中国嘉德2021春季拍卖会 瓷器及古董珍玩集萃",
                                    maxLines: 2,
                                    style: mediumStyle(fontSize: 13, color: const Color(0xFF111111)),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(10, 14, 10, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(2.5)),
                                    child: LinearProgressIndicator(
                                      value: 0.5,
                                      color: Colors.red,
                                      backgroundColor: Color(0xFFE7E7ED),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(
                                    "第102件/345件",
                                    style: semiBoldStyle(fontSize: 11, color: const Color(0xFF333333)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                                  child: Text(
                                    "藏宝拍卖",
                                    style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
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

      /// 拍2
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 22, 14, 0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  children: const [
                    Text(
                      "全球拍",
                      style: TextStyle(fontSize: 16, color: Color(0xFF222222), fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      "查看更多",
                      style: TextStyle(fontSize: 11, color: Color(0xFF999999), fontWeight: FontWeight.w500),
                    ),
                    Text(
                      " >",
                      style: TextStyle(fontSize: 11, color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.only(top: 15),
                child: PageView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Stack(
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
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4)),
                                          color: Colors.black.withAlpha(127)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                        child: Text(
                                          "距开拍 16 天",
                                          style: mediumStyle(fontSize: 9, color: Colors.white),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(7, 10, 4, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "现代纸作、印象派及现代艺术",
                                        style: semiBoldStyle(fontSize: 13, color: const Color(0xFF333333)),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        "assets/images/home/home_live_tip.png",
                                        width: 62,
                                        height: 13,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(7, 6, 4, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "佳士得 巴黎",
                                        style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        "assets/images/home/home_eys.png",
                                        width: 13,
                                        height: 13,
                                      ),
                                      Text(
                                        " 1328.6w 次围观",
                                        style: semiBoldStyle(fontSize: 11, color: const Color(0xFF666666)),
                                      ),
                                    ],
                                  ),
                                )
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

      /// 拍3
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 22, 14, 0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  children: const [
                    Text(
                      "专场拍",
                      style: TextStyle(fontSize: 16, color: Color(0xFF222222), fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      "查看更多",
                      style: TextStyle(fontSize: 11, color: Color(0xFF999999), fontWeight: FontWeight.w500),
                    ),
                    Text(
                      " >",
                      style: TextStyle(fontSize: 11, color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.only(top: 15),
                child: PageView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Stack(
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
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4)),
                                          color: Colors.black.withAlpha(127)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                        child: Text(
                                          "距开拍 16 天",
                                          style: mediumStyle(fontSize: 9, color: Colors.white),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(7, 10, 4, 0),
                                  child: Text(
                                    "现代纸作、印象派及现代艺术",
                                    style: semiBoldStyle(fontSize: 13, color: const Color(0xFF333333)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(7, 6, 4, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "主理人：汪达达",
                                        style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        "assets/images/home/home_eys.png",
                                        width: 13,
                                        height: 13,
                                      ),
                                      Text(
                                        " 1328.6w 次围观",
                                        style: semiBoldStyle(fontSize: 11, color: const Color(0xFF666666)),
                                      ),
                                    ],
                                  ),
                                )
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

      SliverPersistentHeader(
          pinned: true, // header 滑动到可视区域顶部时是否固定在顶部
          floating: false,
          delegate: SliverHeaderDelegate.fixedHeight(
              height: 40,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                      left: 0,
                      right: 30,
                      bottom: 0,
                      top: 0,
                      child: ColoredBox(
                        color: Colors.white,
                        child: TabBar(
                            controller: _controller.tabController,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 1,
                            indicator: const UnderlineGradientTabIndicator(
                                borderSide: BorderSide(strokeAlign: BorderSide.strokeAlignInside)),
                            // automaticIndicatorColorAdjustment: true,
                            splashFactory: NoSplash.splashFactory,
                            unselectedLabelStyle: mediumStyle(
                              fontSize: 13,
                              color: const Color(0xFF999999),
                            ),
                            unselectedLabelColor: const Color(0xFF999999),
                            labelStyle: semiBoldStyle(
                              fontSize: 14,
                              color: const Color(0xFF333333),
                            ),
                            labelColor: const Color(0xFF333333),
                            physics: const NeverScrollableScrollPhysics(),
                            tabs: _controller.tabTitles
                                .map((e) => Tab(
                                      text: e,
                                    ))
                                .toList()),
                      )),
                  Positioned(
                      right: 0,
                      width: 75,
                      height: 27,
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                          "assets/images/home/home_cate_bj.png",
                        ))),
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: IconButton(
                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                        iconSize: 12,
                                        onPressed: () => _controller.isVer.value = !_controller.isVer.value,
                                        icon: const ImageIcon(size: 12, AssetImage("assets/images/home/home_cate_open.png"))))),
                            Expanded(
                                child: SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: IconButton(
                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                        iconSize: 12,
                                        onPressed: () {},
                                        icon: const ImageIcon(size: 12, AssetImage("assets/images/home/home_cate_list.png")))))
                          ],
                        ),
                      ))
                ],
              ))),
    ];
  }
}

typedef SliverHeaderBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  // child 为 header
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  //最大和最小高度相同
  SliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  //需要自定义builder时使用
  SliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    //测试代码：如果在调试模式，且子组件设置了key，则打印日志
    assert(() {
      if (child.key != null) {
        dev.log('${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
      }
      return true;
    }());

    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
  }
}
