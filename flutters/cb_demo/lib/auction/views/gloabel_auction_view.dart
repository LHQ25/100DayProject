import 'package:cb_demo/auction/presentation/controller/AuctionpageView.dart';
import 'package:cb_demo/util/SimpleColor.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../presentation/controller/GlobelAuctionController.dart';

class GlobelAuctionView extends StatelessWidget {
  GlobelAuctionView({super.key});

  final controller = Get.put(GlobelAuctionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("全球拍"),
        titleTextStyle:
            mediumStyle(fontSize: 16, color: const Color(0xFF222222)),
        leading: const BackButton(
          color: Color(0xFF333333),
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.calendar_month_outlined),
            color: Colors.black,
          )
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: headerView,
          body: TabBarView(
              controller: controller.tab_controller,
              children: controller.tabs
                  .map((e) => ListView.builder(
                      itemCount: 8,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 20),
                              child: SizedBox(
                                height: 74,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Flex(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 17.5,
                                        ),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "佳士得 2021年春季艺术品拍卖会",
                                                style: semiBoldStyle(
                                                    fontSize: 14,
                                                    color: color333333),
                                              ),
                                              Text(
                                                "中国  2021.07.01-07.30  共21场",
                                                style: regularStyle(
                                                    fontSize: 12,
                                                    color: color333333),
                                              )
                                            ],
                                          ),
                                        )),
                                        SizedBox(
                                          width: 56,
                                          height: 20,
                                          child: DecoratedBox(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF444445),
                                                      Color(0xFF757577)
                                                    ])),
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    foregroundColor:
                                                        Colors.white,
                                                    surfaceTintColor:
                                                        Colors.amber,
                                                    textStyle: mediumStyle(
                                                        fontSize: 13,
                                                        color: Colors.white)),
                                                onPressed: null,
                                                child: Text(
                                                  "进入",
                                                  style: mediumStyle(
                                                      fontSize: 13,
                                                      color: Colors.white),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                        height: 1,
                                        width: double.infinity,
                                        child: ColoredBox(
                                          color: Color(0xFFE6E6E8),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: AspectRatio(
                                aspectRatio: 345.5 / 129.0,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/test/test7.png",
                                      fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: SizedBox(
                                          width: 69.5,
                                          height: 16.5,
                                          child: ColoredBox(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: Text(
                                              "距开拍 16 天",
                                              textAlign: TextAlign.center,
                                              style: mediumStyle(
                                                  fontSize: 9,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 25, left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "F.P. Journe宝玑和丹尼尔斯腕表",
                                    style: semiBoldStyle(
                                        fontSize: 13, color: color333333),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    "assets/images/home/home_eys.png",
                                    width: 15,
                                    height: 15,
                                  ),
                                  Text(
                                    " 1650 人围观",
                                    style: regularStyle(
                                        fontSize: 11, color: color666666),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 6,
                              child: ColoredBox(color: Color(0xFFF5F5F8)),
                            )
                          ],
                        );
                      })))
                  .toList())),
    );
  }

  List<Widget> headerView(BuildContext context, bool res) {
    return [
      SliverToBoxAdapter(
          child: SizedBox(
        height: 86,
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          scrollDirection: Axis.horizontal,
          itemCount: 13,
          itemBuilder: (context, index) {
            return Flex(
              direction: Axis.vertical,
              children: [
                Image.asset(
                  "assets/images/test/test8.png",
                  width: 48,
                  height: 48,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    "瓷花瓶",
                    style: mediumStyle(
                        fontSize: 11, color: const Color(0xFF6B6B6E)),
                  ),
                )
              ],
            );
          },
          separatorBuilder: ((context, index) {
            return const SizedBox(
              width: 20,
              height: 20,
            );
          }),
        ),
      )),
      SliverToBoxAdapter(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 15),
          child: Text(
            "热门拍卖行",
            style: semiBoldStyle(fontSize: 16, color: const Color(0xFF222222)),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SizedBox(
              height: 115,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 15, right: 15),
                scrollDirection: Axis.horizontal,
                itemCount: 13,
                itemBuilder: (context, index) {
                  return Container(
                    width: 84,
                    height: 100,
                    decoration: BoxDecoration(
                        color: const Color(0xFF00295C).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 84.0 / 31.0,
                          child: Image.asset("assets/images/test/test9.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 5),
                          child: Text(
                            "佳士得",
                            style: mediumStyle(
                                fontSize: 12, color: const Color(0xFF111111)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, left: 5),
                          child: Text(
                            "香港",
                            style: mediumStyle(
                                fontSize: 10, color: const Color(0xFF555555)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, left: 5, bottom: 15),
                          width: 50,
                          height: 14.5,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Text(
                            "近期12场",
                            style: mediumStyle(fontSize: 9, color: color666666),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: ((context, index) {
                  return const SizedBox(
                    width: 10,
                    height: 0,
                  );
                }),
              ),
            ))
      ])),
      SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate.fixedHeight(
            height: 36,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFFE6E6E8), width: 0.5))),
              child: TabBar(
                  controller: controller.tab_controller,
                  isScrollable: true,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  labelColor: color333333,
                  labelStyle: semiBoldStyle(fontSize: 12, color: color333333),
                  unselectedLabelColor: color999999,
                  unselectedLabelStyle:
                      mediumStyle(fontSize: 12, color: color999999),
                  indicator: const UnderlineTabIndicator(),
                  splashFactory: NoSplash.splashFactory,
                  tabs: controller.tabs
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList()),
            ),
          ))
    ];
  }
}
