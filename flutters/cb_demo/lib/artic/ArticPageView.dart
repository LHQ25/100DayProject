import 'dart:developer';
import 'package:card_swiper/card_swiper.dart';
import 'package:cb_demo/artic/ArticleVideoPageView.dart';
import 'package:cb_demo/artic/controllers/artic_page_viewcontroller.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../auction/views/AuctionpageView.dart';
import '../custom_view/UnderlineGradientTabIndicator.dart';

class ArticPageView extends StatelessWidget {
  ArticPageView({super.key});

  final _controller = Get.put(ArticPageViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            height: 46,
            decoration: const BoxDecoration(
                image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/images/home/home_appbar_search_bg2.png"))),
            child: GestureDetector(
              onTap: () => log("去搜索"),
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
      body: NestedScrollView(
          headerSliverBuilder: (context, index) {
            /// Banner
            return [
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 345.0 / 145.0,
                  child: Swiper(
                    // containerHeight: 358,
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
              SliverPersistentHeader(
                  pinned: true, // header 滑动到可视区域顶部时是否固定在顶部
                  floating: false,
                  delegate: SliverHeaderDelegate.fixedHeight(
                      child: ColoredBox(
                        color: Colors.white,
                        child: TabBar(
                            controller: _controller.tabController,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 1,
                            indicator: const UnderlineGradientTabIndicator(
                                borderSide: BorderSide(strokeAlign: BorderSide.strokeAlignInside)),
                            automaticIndicatorColorAdjustment: true,
                            unselectedLabelStyle: mediumStyle(
                              fontSize: 13,
                              color: const Color(0xFF999999),
                            ),
                            labelStyle: semiBoldStyle(
                              fontSize: 14,
                              color: const Color(0xFF333333),
                            ),
                            tabs: _controller.tabTitles
                                .map((e) => Tab(
                                      text: e,
                                    ))
                                .toList()),
                      ),
                      height: 40)),
            ];
          },
          body: TabBarView(controller: _controller.tabController, children: [
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    return GestureDetector(
                        onTap: () => Get.to(const WebView()),
                        child: Container(
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E8), width: 0.5))),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                                  child: Text(
                                    "2021中国嘉德春拍6月8日启幕46个专场6000余件重磅珍品 专场6000余件重磅珍品 中国嘉德",
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    style: mediumStyle(fontSize: 14, color: const Color(0xFF111111)),
                                  )),
                              Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/test/test3.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Positioned(
                                      left: 1,
                                      top: 1,
                                      child: Container(
                                        width: 34,
                                        height: 16.5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Text(
                                          "置顶",
                                          style: mediumStyle(fontSize: 9, color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 15.5,
                                      margin: const EdgeInsets.only(right: 9),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(width: 0.5, color: const Color(0xFFCFD0D3))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          "深度好文",
                                          style: mediumStyle(fontSize: 10, color: const Color(0xFF90939B)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 15.5,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 9),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF5F5F8), borderRadius: BorderRadius.all(Radius.circular(1.5))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          "苏富比",
                                          style: mediumStyle(fontSize: 10, color: const Color(0xFF7E7F83)),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "2021.01.30 15:00",
                                      style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Image.asset(
                                        "assets/images/article/artic1.png",
                                        width: 11.5,
                                        height: 9.5,
                                      ),
                                    ),
                                    Text(
                                      "1650",
                                      style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  } else {
                    return GestureDetector(
                        onTap: () => Get.to(ArticleVideoPageView(
                              videoUrl: "",
                            )),
                        child: Container(
                            decoration:
                                const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E8), width: 0.5))),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              child: SizedBox(
                                height: 83,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                            maxLines: 2,
                                            TextSpan(
                                                text: "华艺国际春拍臻品荟萃 北京精品展览5月14日盛大开幕",
                                                style: mediumStyle(fontSize: 14, color: const Color(0xFF111111)))),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Container(
                                              height: 15.5,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(right: 9),
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFFF5F5F8), borderRadius: BorderRadius.all(Radius.circular(1.5))),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: Text(
                                                  "苏富比",
                                                  style: mediumStyle(fontSize: 10, color: const Color(0xFF7E7F83)),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "2021.01.30 15:00",
                                              style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 2),
                                              child: Image.asset(
                                                "assets/images/article/artic1.png",
                                                width: 11.5,
                                                height: 9.5,
                                              ),
                                            ),
                                            Text(
                                              "1650",
                                              style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Image.asset(
                                        "assets/images/test/test4.png",
                                        width: 112,
                                        height: 83,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )));
                  }
                }),
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    return GestureDetector(
                        onTap: () => Get.to(const WebView()),
                        child: Container(
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E8), width: 0.5))),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                                  child: Text(
                                    "2021中国嘉德春拍6月8日启幕46个专场6000余件重磅珍品 专场6000余件重磅珍品 中国嘉德",
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    style: mediumStyle(fontSize: 14, color: const Color(0xFF111111)),
                                  )),
                              Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/test/test3.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Positioned(
                                      left: 1,
                                      top: 1,
                                      child: Container(
                                        width: 34,
                                        height: 16.5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Text(
                                          "置顶",
                                          style: mediumStyle(fontSize: 9, color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 15.5,
                                      margin: const EdgeInsets.only(right: 9),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(width: 0.5, color: const Color(0xFFCFD0D3))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          "深度好文",
                                          style: mediumStyle(fontSize: 10, color: const Color(0xFF90939B)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 15.5,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 9),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF5F5F8), borderRadius: BorderRadius.all(Radius.circular(1.5))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          "苏富比",
                                          style: mediumStyle(fontSize: 10, color: const Color(0xFF7E7F83)),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "2021.01.30 15:00",
                                      style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Image.asset(
                                        "assets/images/article/artic1.png",
                                        width: 11.5,
                                        height: 9.5,
                                      ),
                                    ),
                                    Text(
                                      "1650",
                                      style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  } else {
                    return GestureDetector(
                        onTap: () => Get.to(ArticleVideoPageView(
                              videoUrl: "",
                            )),
                        child: Container(
                            decoration:
                                const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E8), width: 0.5))),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              child: SizedBox(
                                height: 83,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                            maxLines: 2,
                                            TextSpan(
                                                text: "华艺国际春拍臻品荟萃 北京精品展览5月14日盛大开幕",
                                                style: mediumStyle(fontSize: 14, color: const Color(0xFF111111)))),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Container(
                                              height: 15.5,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(right: 9),
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFFF5F5F8), borderRadius: BorderRadius.all(Radius.circular(1.5))),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: Text(
                                                  "苏富比",
                                                  style: mediumStyle(fontSize: 10, color: const Color(0xFF7E7F83)),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "2021.01.30 15:00",
                                              style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 2),
                                              child: Image.asset(
                                                "assets/images/article/artic1.png",
                                                width: 11.5,
                                                height: 9.5,
                                              ),
                                            ),
                                            Text(
                                              "1650",
                                              style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Image.asset(
                                        "assets/images/test/test4.png",
                                        width: 112,
                                        height: 83,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )));
                  }
                }),
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    return GestureDetector(
                        onTap: () => Get.to(const WebView()),
                        child: Container(
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E8), width: 0.5))),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                                  child: Text(
                                    "2021中国嘉德春拍6月8日启幕46个专场6000余件重磅珍品 专场6000余件重磅珍品 中国嘉德",
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    style: mediumStyle(fontSize: 14, color: const Color(0xFF111111)),
                                  )),
                              Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/test/test3.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Positioned(
                                      left: 1,
                                      top: 1,
                                      child: Container(
                                        width: 34,
                                        height: 16.5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Text(
                                          "置顶",
                                          style: mediumStyle(fontSize: 9, color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 15.5,
                                      margin: const EdgeInsets.only(right: 9),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(width: 0.5, color: const Color(0xFFCFD0D3))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          "深度好文",
                                          style: mediumStyle(fontSize: 10, color: const Color(0xFF90939B)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 15.5,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 9),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF5F5F8), borderRadius: BorderRadius.all(Radius.circular(1.5))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          "苏富比",
                                          style: mediumStyle(fontSize: 10, color: const Color(0xFF7E7F83)),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "2021.01.30 15:00",
                                      style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Image.asset(
                                        "assets/images/article/artic1.png",
                                        width: 11.5,
                                        height: 9.5,
                                      ),
                                    ),
                                    Text(
                                      "1650",
                                      style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  } else {
                    return GestureDetector(
                        onTap: () => Get.to(ArticleVideoPageView(
                              videoUrl: "",
                            )),
                        child: Container(
                            decoration:
                                const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E8), width: 0.5))),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              child: SizedBox(
                                height: 83,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                            maxLines: 2,
                                            TextSpan(
                                                text: "华艺国际春拍臻品荟萃 北京精品展览5月14日盛大开幕",
                                                style: mediumStyle(fontSize: 14, color: const Color(0xFF111111)))),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Container(
                                              height: 15.5,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(right: 9),
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFFF5F5F8), borderRadius: BorderRadius.all(Radius.circular(1.5))),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: Text(
                                                  "苏富比",
                                                  style: mediumStyle(fontSize: 10, color: const Color(0xFF7E7F83)),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "2021.01.30 15:00",
                                              style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 2),
                                              child: Image.asset(
                                                "assets/images/article/artic1.png",
                                                width: 11.5,
                                                height: 9.5,
                                              ),
                                            ),
                                            Text(
                                              "1650",
                                              style: regularStyle(fontSize: 11, color: const Color(0xFF666666)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Image.asset(
                                        "assets/images/test/test4.png",
                                        width: 112,
                                        height: 83,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )));
                  }
                })
          ])),
    );
  }
}
