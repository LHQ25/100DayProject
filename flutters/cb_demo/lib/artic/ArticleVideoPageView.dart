import 'package:cb_demo/routes/Routes.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'controllers/video_controller.dart';

// class ArticleVideoPageView extends StatefulWidget {
//   const ArticleVideoPageView({super.key});
//
//   @override
//   State<ArticleVideoPageView> createState() => _ArticleVideoPageViewState();
// }

class ArticleVideoPageView extends StatelessWidget {
  ArticleVideoPageView({super.key, required this.videoUrl});

  final _controller = Get.put(VideoManagerController());

  final String? videoUrl;

  set videoUrl(String? value) => print("--> $value");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.share,
                size: 20,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        children: [
          Center(
              child: FutureBuilder(
            builder: (context, t) {
              return AspectRatio(
                aspectRatio: _controller.playerController.value.aspectRatio,
                child: VideoPlayer(_controller.playerController),
              );
            },
            future: _controller.started(videoUrl),
          )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Text(
                      "胭脂红——用黄金入釉的瓷器：美的就是不一样探索古典美",
                      maxLines: 2,
                      style: mediumStyle(fontSize: 16, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: Image.asset("assets/images/article/article2.png"),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            height: 35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "藏宝艺术",
                                  style: mediumStyle(fontSize: 13, color: Colors.white),
                                ),
                                const Spacer(),
                                Text(
                                  "2021.01.30 15:00",
                                  style: regularStyle(fontSize: 11, color: const Color(0xFF999999)),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/article/article_see.png",
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  "1376",
                                  style: regularStyle(fontSize: 11, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/article/article_share.png",
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  "1376",
                                  style: regularStyle(fontSize: 11, color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
