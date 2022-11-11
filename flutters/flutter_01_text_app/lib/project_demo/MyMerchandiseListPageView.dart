import 'package:flutter/material.dart';

class MyMerchandiseListPageView extends StatefulWidget {
  const MyMerchandiseListPageView({Key? key}) : super(key: key);

  @override
  State<MyMerchandiseListPageView> createState() =>
      _MyMerchandiseListPageViewState();
}

class _MyMerchandiseListPageViewState extends State<MyMerchandiseListPageView> {
  final _tabs = ["售卖中", "待审核", "审核驳回", "草稿箱", "已下架", "待上架"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "images/blackBack.png",
                  width: 20,
                  height: 36,
                ),
              ),
              title: const Text(
                "我的商品",
                style: TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            body: Flex(
              direction: Axis.vertical,
              children: [
                Container(
                    color: Colors.white,
                    child: Container(
                      height: 30,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: const [
                          Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Image(
                                image: AssetImage("images/search.png"),
                                width: 20,
                                height: 20,
                              )),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                "搜索商品名称、商品ID",
                                style: TextStyle(
                                    color: Color(0xFF999999), fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                Container(
                  color: const Color(0xFFF9F9F9),
                  child: TabBar(
                      isScrollable: true,
                      // controller: _tabController,
                      padding: const EdgeInsets.only(
                          left: 12, top: 7, right: 12, bottom: 7),
                      indicatorColor: const Color(0xFF4F78FF),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 2,
                      indicatorPadding: const EdgeInsets.only(
                          left: 0, top: 7, right: 0, bottom: 0),
                      tabs: _tabs
                          .map((e) => Column(
                                children: [
                                  Text(
                                    e,
                                    style: const TextStyle(
                                        color: Color(0xFF999999), fontSize: 16),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2, bottom: 4),
                                    child: Text(
                                      "0",
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 16),
                                    ),
                                  )
                                ],
                              ))
                          .toList()),
                ),
                Expanded(
                  child: TabBarView(
                    // controller: _tabController,
                    children: _tabs
                        .map((e) => Container(
                            color: const Color(0xFFF9F9F9),
                            // foregroundDecoration: const BoxDecoration(
                            //     image: DecorationImage(
                            //         image: AssetImage("images/empty.png"),
                            //         fit: BoxFit.contain)
                            // ),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return _createCell(index);
                              },
                              itemCount: 10,
                            )))
                        .toList(),
                  ),
                ),
                ColoredBox(
                  color: Colors.white,
                  child: SafeArea(
                      bottom: true,
                      child: GestureDetector(
                        onTap: () {
                          print("123131");
                        },
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xFF4F78FF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, top: 10, bottom: 10),
                            height: 44,
                            child: const Center(
                              child: Text("发布商品",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            )),
                      )),
                )
              ],
            )));
  }

  _createCell(int index) {
    return Container(
      color: const Color(0xFFF9F9F9),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.only(top: 12),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Image(
                      height: 80,
                      width: 80,
                      image: NetworkImage(
                          "https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d29af4389b4b4f7586304fdad9b06762~tplv-k3u1fbpfcp-zoom-mark-crop-v2:460:460:0:0.png")),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "秋季情侣针织帽商品名称名称秋季情侣针织帽",
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "销量 0 | 库存 200 | 暂无评价",
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text.rich(TextSpan(
                            text: "¥",
                            style: TextStyle(
                                color: Color(0xFFF93D3F),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: "300",
                                style: TextStyle(fontSize: 20),
                              ),
                              TextSpan(
                                text: ".14",
                                style: TextStyle(fontSize: 14),
                              )
                            ])),
                      )
                    ],
                  ),
                ))
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(right: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: OutlinedButton(
                          onPressed: () => {},
                          child: const Text(
                            "下架",
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          )),
                    ),
                    OutlinedButton(
                        onPressed: () => {},
                        child: const Text(
                          "编辑",
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
