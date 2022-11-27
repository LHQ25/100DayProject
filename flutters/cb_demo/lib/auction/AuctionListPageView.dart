import 'package:cb_demo/util/TextStyle.dart';
import 'package:cb_demo/util/Toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class AuctionGridPageView extends StatefulWidget {
  const AuctionGridPageView({Key? key}) : super(key: key);

  @override
  State<AuctionGridPageView> createState() => _AuctionGridPageViewState();
}

class _AuctionGridPageViewState extends State<AuctionGridPageView> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size.width;
    return WaterfallFlow.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: null,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/test/test_a_${index % 3}.png",
                  width: (screen - 45) / 2.0,
                  fit: BoxFit.fitWidth,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text.rich(
                      maxLines: 2,
                      TextSpan(
                          text: "Lot 1",
                          style: semiBoldStyle(
                              fontSize: 13, color: const Color(0xFF333333)),
                          children: [
                            TextSpan(
                                text: "：清管彩开光-Gold Favrile Cup and mettere",
                                style: mediumStyle(
                                    fontSize: 13,
                                    color: const Color(0xFF333333)))
                          ])),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "起拍价：",
                          style: mediumStyle(
                              fontSize: 11, color: const Color(0xFF777777)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Row(
                            children: [
                              Text(
                                "USD 23",
                                style: semiBoldStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF111111)),
                              ),
                              const Spacer(),
                              Image.asset(
                                "assets/images/home/home_collect.png",
                                width: 17,
                                height: 17,
                              )
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          );
        });
  }
}

class AuctionListPageView extends StatefulWidget {
  const AuctionListPageView({Key? key}) : super(key: key);

  @override
  State<AuctionListPageView> createState() => _AuctionListPageViewState();
}

class _AuctionListPageViewState extends State<AuctionListPageView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/test/test_a_0.png",
                  width: 92,
                  height: 82,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                          maxLines: 2,
                          TextSpan(
                              text: "Lot 1",
                              style: semiBoldStyle(
                                  fontSize: 13, color: const Color(0xFF333333)),
                              children: [
                                TextSpan(
                                    text: "：清管彩开光-Gold Favrile Cup and mettere",
                                    style: mediumStyle(
                                        fontSize: 13,
                                        color: const Color(0xFF333333)))
                              ])),
                      // const Spacer(),
                      Text(
                        "起拍价：",
                        style: mediumStyle(
                            fontSize: 11, color: const Color(0xFF777777)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Text(
                              "USD 23",
                              style: semiBoldStyle(
                                  fontSize: 12, color: const Color(0xFF111111)),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                showToast("收藏成功！");
                              },
                              child: Image.asset(
                                "assets/images/home/home_collect.png",
                                width: 17,
                                height: 17,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          );
        });
  }
}
