import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import '../util/SimpleColor.dart';

class MineJoinPageView extends StatefulWidget {
  const MineJoinPageView({Key? key}) : super(key: key);

  @override
  State<MineJoinPageView> createState() => _MineJoinPageViewState();
}

class _MineJoinPageViewState extends State<MineJoinPageView>
    implements TickerProvider {
  final _tabTitles = ["竞拍中", "已竞得", "私洽", "未竞得"];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tabTitles.length, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            "我的参拍",
            style: mediumStyle(fontSize: 16, color: const Color(0xFF222222)),
          ),
          bottom: TabBar(
              controller: _tabController,
              labelStyle:
                  semiBoldStyle(fontSize: 14, color: const Color(0xFF333333)),
              unselectedLabelStyle:
                  mediumStyle(fontSize: 13, color: const Color(0xFF999999)),
              enableFeedback: false,
              splashFactory: NoSplash.splashFactory, // 波纹飞溅效果
              overlayColor: MaterialStateProperty.all(Colors.white), // 波纹飞溅颜色
              indicatorSize: TabBarIndicatorSize.label,
              // indicatorColor: const Color(0xFFF72800),
              indicatorWeight: 1,
              indicatorPadding:
                  const EdgeInsets.only(bottom: 8, left: 6, right: 6),
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xFFF72800))),
              tabs: _tabTitles
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList())),

      // bottomNavigationBar: ,
      body: TabBarView(
          controller: _tabController,
          children: _tabTitles.map((e) => _createListView()).toList()),
    );
  }

  Widget _createListView() => ListView.builder(
      itemCount: 4,
      itemBuilder: (content, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(9, 15, 15, 0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 5),
                        child: Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                const SizedBox(
                                  width: 81,
                                  height: 81,
                                  child: ColoredBox(
                                    color: Colors.yellow,
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    height: 16.5,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: Text(
                                        "已结拍",
                                        textAlign: TextAlign.center,
                                        style: mediumStyle(
                                            fontSize: 9, color: Colors.white),
                                      ),
                                    ))
                              ],
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "清管彩开光青铜器 青龙樽 清管彩开光青铜器 青龙樽 唐宋时期精品拍卖",
                                    maxLines: 2,
                                    style: mediumStyle(
                                        fontSize: 13,
                                        color: const Color(0xFF333333)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.5),
                                    child: Text.rich(TextSpan(
                                        text: "我的出价：",
                                        style: mediumStyle(
                                            fontSize: 11,
                                            color: const Color(0xFF777777)),
                                        children: [
                                          TextSpan(
                                              text: "¥ 2300",
                                              style: semiBoldStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xFF111111)))
                                        ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text.rich(TextSpan(
                                        text: "成交金额：",
                                        style: mediumStyle(
                                            fontSize: 11,
                                            color: const Color(0xFF777777)),
                                        children: [
                                          TextSpan(
                                              text: "¥ 2300",
                                              style: semiBoldStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xFF111111)))
                                        ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text.rich(TextSpan(
                                        text: "已缴保证金：",
                                        style: mediumStyle(
                                            fontSize: 11,
                                            color: const Color(0xFF777777)),
                                        children: [
                                          TextSpan(
                                              text: "¥ 2300",
                                              style: semiBoldStyle(
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xFF111111)))
                                        ])),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      const Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            width: 46.5,
                            height: 16.5,
                            child: ColoredBox(
                              color: Colors.red,
                            ),
                          )),
                    ],
                  ),
                  //if (index % 2 == 0) {Builder(builder: (content) {})}
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox.fromSize(
                  size: const Size.fromHeight(6),
                  child: const ColoredBox(
                    color: Color(0xFFF5F5F8),
                  ),
                ),
              )
            ],
          ),
        );
      });

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
