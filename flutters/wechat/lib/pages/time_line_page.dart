import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:wechat/controllers/time_line_controller.dart';
import 'package:get/get.dart';

class TimeLinePage extends StatelessWidget {
  TimeLinePage({Key? key}) : super(key: key);

  final GlobalKey<PullToRefreshNotificationState> refreshKey =
      GlobalKey<PullToRefreshNotificationState>();
  StreamController<void> onBuildController = StreamController<void>.broadcast();
  StreamController<bool> followButtonController = StreamController<bool>();
  double maxDragOffset = 100;

  final _controller = Get.put(TimeLineControlle());

  OverlayEntry? entry;

  Widget _biuldMianView(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: CustomScrollView(
        controller: _controller.scrollController,
        physics: const AlwaysScrollableClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              height: 300,
              child: Stack(
                children: [
                  Positioned.fill(
                    bottom: 30,
                    child: Image.asset(
                      "assets/cypridina.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      right: 10,
                      bottom: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              "H安群",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              "assets/cypridina.jpeg",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: ImageIcon(
                        AssetImage("assets/cypridina.jpeg"),
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              "姓名",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333)),
                            ),
                          ),
                          const Text(
                            "ContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContent",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 6, bottom: 6),
                            child: Text(
                              "北京市 朝阳区",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ),
                          _buildListItem(context),
                        ],
                      ),
                    ))
                  ],
                ),
              );
            }, childCount: 50),
          )
        ],
      ),
    );
  }

// 关闭 like 菜单
  Future<void> _onCloseMenu() async {
    entry?.remove();
    entry?.dispose();
  }

// 动态数据项
  Widget _buildListItem(BuildContext context) {
    // 定义 globalkey 用于查询组件位置
    GlobalKey key = GlobalKey();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "16分钟前",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
        Container(
          key: key,
          width: 30,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: InkWell(
            onTap: () {
              _buildOverView(context);
              _controller.getOffset(key);
            },
            child: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _buildOverView(BuildContext context) {
    entry = OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () async {
          _onCloseMenu();
        },
        child: Stack(
          children: [
            // 背景色渐变动画
            AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 300),
              color: Colors.black.withOpacity(0.4),
            ),

            // 点赞菜单
            AnimatedBuilder(
              animation: _controller.sizeTween,
              builder: (context, child) {
                return Obx(() => Positioned(
                      left:
                          _controller.w.value - 5 - _controller.sizeTween.value,
                      top: _controller.h.value - 10,
                      child: Container(
                        width: _controller.sizeTween.value,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton.icon(
                                onPressed: null,
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                ),
                                label: const Text(
                                  "点赞",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )),
                            TextButton.icon(
                                onPressed: null,
                                icon: const Icon(
                                  Icons.art_track_outlined,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "评论",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ],
        ),
      );
    });

// 延迟显示菜单
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_controller.animationController.status == AnimationStatus.dismissed) {
        _controller.animationController.forward();
      }
    });
    final overlayState = _controller.buildOverLayer(context);
    overlayState.insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimeLineControlle>(
        init: _controller,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ))
              ],
              backgroundColor:
                  Colors.grey.withOpacity(controller.opacity.value),
            ),
            extendBodyBehindAppBar: true,
            body: _biuldMianView(context),
          );
        });
  }
}
