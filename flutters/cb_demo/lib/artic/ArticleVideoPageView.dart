import 'package:cb_demo/routes/Routes.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

class ArticleVideoPageView extends StatefulWidget {
  const ArticleVideoPageView({Key? key}) : super(key: key);

  @override
  State<ArticleVideoPageView> createState() => _ArticleVideoPageViewState();
}

class _ArticleVideoPageViewState extends State<ArticleVideoPageView> {
  late VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();

    _playerController = VideoPlayerController.network(
        formatHint: VideoFormat.dash,
        videoPlayerOptions: VideoPlayerOptions(),
        "https://vcdn.exampleol.com/cos/dvideo/202107/92c0514437b2437c860fc0b69ca7a284.mp4");
  }

  Future<bool> started() async {
    await _playerController.initialize();
    await _playerController.setLooping(true);
    await _playerController.play();
    return true;
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
            onPressed: () => Application.router.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () => Application.router.pop(context),
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
              builder: (context, controller) {
                return AspectRatio(
                  aspectRatio: _playerController.value.aspectRatio,
                  child: VideoPlayer(_playerController),
                );
              },
              future: started(),
            ),
          ),
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
                            child: Image.asset(
                                "assets/images/article/article2.png"),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            height: 35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "藏宝艺术",
                                  style: mediumStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                                const Spacer(),
                                Text(
                                  "2021.01.30 15:00",
                                  style: regularStyle(
                                      fontSize: 11,
                                      color: const Color(0xFF999999)),
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
                                  style: regularStyle(
                                      fontSize: 11, color: Colors.white),
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
                                  style: regularStyle(
                                      fontSize: 11, color: Colors.white),
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
