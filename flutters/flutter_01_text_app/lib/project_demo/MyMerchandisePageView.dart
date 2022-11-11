import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/util.dart';

class MyMerchandisePageView extends StatefulWidget {
  const MyMerchandisePageView({Key? key}) : super(key: key);

  @override
  State<MyMerchandisePageView> createState() => _MyMerchandisePageViewState();
}

class _MyMerchandisePageViewState extends State<MyMerchandisePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4F78FF),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "images/back.png",
            width: 20,
            height: 36,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => {},
              child: const Text(
                "客服",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF4F78FF),
            height: 70,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 0, 10, 0),
                  child: Image.asset(
                    "images/head.png",
                    width: 46,
                    height: 46,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("纸鸢小铺铺最多十字…",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(
                      "综合评分：4.56",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 138,
            child: Stack(
              children: [
                Container(
                    height: 60,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(40)),
                        color: Color(0xFF4F78FF),
                        shape: BoxShape.rectangle)),
                Positioned(
                    left: 12,
                    right: 12,
                    top: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      height: 118,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 13),
                            child: Row(
                              children: const [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  child: SizedBox(
                                      width: 3,
                                      height: 14,
                                      child: ColoredBox(
                                        color: Color(0xFF4F78FF),
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    "今日数据",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF333333)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      children: const [
                                        Text(
                                          "9999.99w",
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text("成交金额(元)",
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  )),
                              const Padding(
                                padding: EdgeInsets.only(top: 14),
                                child: SizedBox(
                                  width: 1,
                                  height: 42,
                                  child: ColoredBox(color: Color(0xFFE5E5E5)),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      children: const [
                                        Text(
                                          "3999",
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text("成交订单数",
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  )),
                              const Padding(
                                padding: EdgeInsets.only(top: 14),
                                child: SizedBox(
                                  width: 1,
                                  height: 42,
                                  child: ColoredBox(color: Color(0xFFE5E5E5)),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      children: const [
                                        Text(
                                          "390",
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text("成交人数",
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            height: 118,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 13),
                  child: Row(
                    children: const [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        child: SizedBox(
                            width: 3,
                            height: 14,
                            child: ColoredBox(
                              color: Color(0xFF4F78FF),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          "常用服务",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF333333)),
                        ),
                      ),
                    ],
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: TextButton(
                                onPressed: () => {
                                  Navigator.pushNamed(context, "MyMerchandiseListPageView")
                                },
                                child: Column(
                                  children: const [
                                    Image(
                                      image: AssetImage("images/goods.png"),
                                      width: 36,
                                      height: 36,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 6),
                                        child: Text(
                                          "我的商品",
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                )))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: TextButton(
                                onPressed: () => {},
                                child: Column(
                                  children: const [
                                    Image(
                                      image: AssetImage("images/order.png"),
                                      width: 36,
                                      height: 36,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 6),
                                        child: Text(
                                          "订单管理",
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                )))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: TextButton(
                                onPressed: () => {},
                                child: Column(
                                  children: const [
                                    Image(
                                      image: AssetImage("images/shop.png"),
                                      width: 36,
                                      height: 36,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 6),
                                        child: Text(
                                          "店铺信息",
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                )))),
                    Expanded(
                        flex: 1,
                        child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: TextButton(
                                onPressed: () => {},
                                child: Column(
                                  children: const [
                                    Image(
                                      image: AssetImage("images/addr.png"),
                                      width: 36,
                                      height: 36,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                        "地址管理",
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
