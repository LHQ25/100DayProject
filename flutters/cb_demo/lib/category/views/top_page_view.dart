import 'package:card_swiper/card_swiper.dart';
import 'package:cb_demo/util/SimpleColor.dart';
import 'package:cb_demo/util/TextStyle.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

import '../../artic/ArticleVideoPageView.dart';
import '../controller/TopPageController.dart';

class TopPageView extends StatelessWidget {
  TopPageView({super.key});

  final _controller = Get.put(TopPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("榜单"),
        titleTextStyle: mediumStyle(fontSize: 18, color: color333333),
      ),
      body: NestedScrollView(
          headerSliverBuilder: _headerView,
          body: Obx(() => EasyRefresh(
              footer: const ClassicFooter(),
              onLoad: () async {
                return _controller.loadMoreVideo();
              },
              child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _controller.videos.length,
                  cacheExtent: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 3, crossAxisSpacing: 3, childAspectRatio: 174.0 / 232.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        debugPrint("------> ${_controller.videos[index].resources}");
                        Get.to(ArticleVideoPageView(videoUrl: _controller.videos[index].resources));
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: ColoredBox(
                          color: Colors.white,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                _controller.videos[index].cover!,
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        foregroundImage: NetworkImage(_controller.videos[index].head!),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 24,
                                        child: TextButton.icon(
                                            onPressed: null,
                                            style: TextButton.styleFrom(elevation: 0, padding: EdgeInsets.zero),
                                            icon: const Icon(Icons.heart_broken_rounded),
                                            label: Text(
                                              " ${_controller.videos[index].praisedCount ?? 0}",
                                              style: regularStyle(fontSize: 12, color: Colors.white),
                                            )),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1));
              }))),
    );
  }

  List<Widget> _headerView(BuildContext context, bool index) {
    return [
      SliverToBoxAdapter(
        child: SizedBox(
            width: double.infinity,
            height: 28,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: ColoredBox(
                    color: const Color(0xFFFEF2F2),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/cate/top1.png",
                          width: 18,
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "这里是用户昵称昵称昵…",
                            style: regularStyle(fontSize: 13, color: color333333),
                          ),
                        )
                      ],
                    )))),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
        sliver: SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 351.0 / 140.0,
            child: Obx(() => Swiper(
                  itemCount: _controller.banners.length,
                  autoplay: true,
                  itemBuilder: (context, index) {
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Image.network(
                        _controller.banners[index].img!,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                )),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(top: 24, left: 12, right: 12, bottom: 24),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            width: double.infinity,
            height: 102,
            child: Obx(() => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (content, index) {
                  return Column(
                    children: [
                      Image.network(
                        _controller.cates[index].cover!,
                        width: 40,
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          _controller.cates[index].title ?? "",
                          style: regularStyle(fontSize: 12, color: color333333),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (content, index) {
                  return const SizedBox(
                    width: 38,
                    height: 10,
                  );
                },
                itemCount: _controller.cates.length)),
          ),
        ),
      )
    ];
  }
}
