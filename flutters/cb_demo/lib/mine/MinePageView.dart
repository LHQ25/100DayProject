import 'package:cb_demo/routes/Routes.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class MinePageView extends StatefulWidget {
  const MinePageView({Key? key}) : super(key: key);

  @override
  State<MinePageView> createState() => _MinePageViewState();
}

class _MinePageViewState extends State<MinePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      // extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leadingWidth: 68,
        leading: Builder(builder: (context) {
          return Row(
            children: [
              Stack(
                children: [
                  Positioned(
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const ImageIcon(
                              size: 20,
                              AssetImage(
                                "assets/images/mine/mine_msg@3x.png",
                              )))),
                  const Positioned(
                      top: 12,
                      right: 12,
                      child: SizedBox(
                        width: 5,
                        height: 5,
                        child: ClipOval(
                          child: ColoredBox(color: Colors.red),
                        ),
                      ))
                  // SizedBox(
                  //     width: 20,
                  //     height: 20,
                  //     child: )
                ],
              ),
              SizedBox(
                  width: 20,
                  height: 20,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: const ImageIcon(
                          size: 20,
                          AssetImage(
                            "assets/images/mine/mine_set.png",
                          ))))
            ],
          );
        }),
        actionsIconTheme: const IconThemeData(color: Colors.yellow),
        actions: [
          IconButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const ImageIcon(AssetImage(
                "assets/images/mine/mine_add.png",
              )))
        ],
      ),
      body: MediaQuery.removeViewPadding(
          removeTop: true,
          context: context,
          child: ListView(
            shrinkWrap: true,
            children: [
              _createUserInfo(),
              _createWallet(),
              _createOrder(),
              _createJoin(),
              _createServices()
            ],
          )),
    );
  }

  Widget _createUserInfo() => AspectRatio(
        aspectRatio: 375 / 270,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/mine/mine3.png"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 10, bottom: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 67,
                      height: 67,
                      child: Image.asset("assets/images/mine/mine_head.png"),
                    ),

                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "藏家凌凌漆",
                                  style: mediumStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF111111)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          width: 38,
                                          height: 13,
                                          "assets/images/mine/mine_2.png"),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Image.asset(
                                            width: 38,
                                            height: 13,
                                            "assets/images/mine/mine_1.png"),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    "竞拍号：567489",
                                    style: regularStyle(
                                        fontSize: 11,
                                        color: const Color(0xFF666666)),
                                  ),
                                )
                              ],
                            ))),
                    // const Spacer(),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      size: 20,
                      color: Color(0xFF666666),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.5),
                          child: Text(
                            "12",
                            style: boldTextStyle(
                                size: 18, color: const Color(0xFF333333)),
                          ),
                        ),
                        Text(
                          "拍卖行",
                          style: boldTextStyle(
                              size: 11, color: const Color(0xFF666666)),
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.5),
                          child: Text(
                            "40",
                            style: boldTextStyle(
                                size: 18, color: const Color(0xFF333333)),
                          ),
                        ),
                        Text(
                          "拍卖会",
                          style: boldTextStyle(
                              size: 11, color: const Color(0xFF666666)),
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.5),
                          child: Text(
                            "40",
                            style: boldTextStyle(
                                size: 18, color: const Color(0xFF333333)),
                          ),
                        ),
                        Text(
                          "藏品",
                          style: boldTextStyle(
                              size: 11, color: const Color(0xFF666666)),
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.5),
                          child: Text(
                            "5",
                            style: boldTextStyle(
                                size: 18, color: const Color(0xFF333333)),
                          ),
                        ),
                        Text(
                          "艺术家",
                          style: boldTextStyle(
                              size: 11, color: const Color(0xFF666666)),
                        )
                      ],
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _createWallet() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            child: Row(
              children: [
                Text(
                  "钱包",
                  style: semiBoldStyle(
                      fontSize: 14, color: const Color(0xFF333333)),
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                  color: Color(0xFF666666),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text.rich(
                      TextSpan(text: "¥", children: [
                        TextSpan(
                            text: "120.00",
                            style: boldTextStyle(
                                size: 18, color: const Color(0xFF333333)))
                      ]),
                      style: semiBoldStyle(
                        fontSize: 13,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "余额",
                        style: mediumStyle(
                            fontSize: 12, color: const Color(0xFF444444)),
                      ),
                    )
                  ],
                )),
                const SizedBox(
                  width: 0.5,
                  height: 36,
                  child: ColoredBox(color: Color(0xFFE6E6E8)),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text.rich(
                      TextSpan(text: "¥", children: [
                        TextSpan(
                            text: "120.00",
                            style: boldTextStyle(
                                size: 18, color: const Color(0xFF333333)))
                      ]),
                      style: semiBoldStyle(
                        fontSize: 13,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "保证金账户",
                        style: mediumStyle(
                            fontSize: 12, color: const Color(0xFF444444)),
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createOrder() => Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  Text(
                    "我的订单",
                    style: semiBoldStyle(
                        fontSize: 14, color: const Color(0xFF333333)),
                  ),
                  Container(
                    width: 140.5,
                    height: 16,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/mine/mine_order_1.png"))),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 6),
                          child: Image.asset(
                            "assets/images/mine/mine_order_2.png",
                            width: 12,
                            height: 10.5,
                          ),
                        ),
                        Text(
                          "您有一笔货款待支付",
                          style: mediumStyle(
                              fontSize: 10, color: const Color(0xFF684A21)),
                        ),
                        const Spacer(),
                        Transform(
                            transform: Matrix4.translationValues(0, 8, 0),
                            child: Image.asset(
                              "assets/images/mine/mine_order_3.png",
                              width: 22.5,
                              height: 22.5,
                            ))
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "全部订单",
                    style: mediumStyle(
                        fontSize: 11, color: const Color(0xFF999999)),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 20,
                    color: Color(0xFF666666),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 27,
                            height: 27,
                            child: Image.asset(
                              "assets/images/mine/mine_order_4.png",
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.5),
                        child: Text(
                          "待付款",
                          style: mediumStyle(
                              fontSize: 14, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 27,
                        height: 27,
                        child: Image.asset(
                          "assets/images/mine/mine_order_5.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.5),
                        child: Text(
                          "待发货",
                          style: mediumStyle(
                              fontSize: 14, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 27,
                        height: 27,
                        child: Image.asset(
                          "assets/images/mine/mine_order_6.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.5),
                        child: Text(
                          "待收货",
                          style: mediumStyle(
                              fontSize: 14, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 27,
                        height: 27,
                        child: Image.asset(
                          "assets/images/mine/mine_order_7.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.5),
                        child: Text(
                          "待评价",
                          style: mediumStyle(
                              fontSize: 14, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                ],
              ),
            )
          ],
        ),
      );

  Widget _createJoin() => Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Column(
          children: [
            GestureDetector(
                onTap: () =>
                    Application.router.navigateTo(context, Routes.joinView),
                child: SizedBox(
                  child: Row(
                    children: [
                      Text(
                        "我的参拍",
                        style: semiBoldStyle(
                            fontSize: 14, color: const Color(0xFF333333)),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                        color: Color(0xFF666666),
                      )
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 22.5,
                        height: 22.5,
                        child: Image.asset(
                          "assets/images/mine/mine_join_1.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.5),
                        child: Text(
                          "竞拍中",
                          style: mediumStyle(
                              fontSize: 12, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 22.5,
                        height: 22.5,
                        child: Image.asset(
                          "assets/images/mine/mine_join_2.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.5),
                        child: Text(
                          "已竞得",
                          style: mediumStyle(
                              fontSize: 12, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 22.5,
                        height: 22.5,
                        child: Image.asset(
                          "assets/images/mine/mine_join_3.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.5),
                        child: Text(
                          "私洽",
                          style: mediumStyle(
                              fontSize: 12, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 22.5,
                        height: 22.5,
                        child: Image.asset(
                          "assets/images/mine/mine_order_7.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.5),
                        child: Text(
                          "未竞得",
                          style: mediumStyle(
                              fontSize: 12, color: const Color(0xFF444444)),
                        ),
                      )
                    ],
                  )),
                ],
              ),
            )
          ],
        ),
      );

  Widget _servicesItem(String title, String image) =>
      Builder(builder: (context) {
        return SizedBox(
          width: (context.width() - 28) / 4.0,
          child: Column(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(
                  image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7.5),
                child: Text(
                  title,
                  style:
                      mediumStyle(fontSize: 12, color: const Color(0xFF444444)),
                ),
              )
            ],
          ),
        );
      });
  Widget _createServices() => Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  Text(
                    "我的服务",
                    style: semiBoldStyle(
                        fontSize: 14, color: const Color(0xFF333333)),
                  ),
                  const Spacer()
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Wrap(
                  spacing: 0,
                  runSpacing: 28,
                  alignment: WrapAlignment.start,
                  // runAlignment: WrapAlignment.start,
                  children: [
                    _servicesItem("优惠券", "assets/images/mine/mine_join_1.png"),
                    _servicesItem("鉴定服务", "assets/images/mine/mine_join_1.png"),
                    _servicesItem("送拍服务", "assets/images/mine/mine_join_1.png"),
                    _servicesItem("足迹统计", "assets/images/mine/mine_join_1.png"),
                    _servicesItem("平台客服", "assets/images/mine/mine_join_1.png"),
                    _servicesItem("帮助中心", "assets/images/mine/mine_join_1.png"),
                    _servicesItem("入驻藏宝", "assets/images/mine/mine_join_1.png")
                  ],
                )),
          ],
        ),
      );
}
