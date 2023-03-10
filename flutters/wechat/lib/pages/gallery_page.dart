import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class GalleryPage extends StatelessWidget {
  GalleryPage(this.index, this.images, {super.key});

  final int index;
  final List<AssetEntity> images;
  //final _controller = Get.put(GalleryPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryPageController>(
        init: GalleryPageController(),
        builder: (controller) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: MyAppBar(
                const BackButton(
                  color: Colors.white,
                ),
                controller.ac,
                controller.visible.value),
            body: InkWell(
              onTap: () {
                controller.visible.toggle();
              },
              child: Container(
                color: Colors.black,
                child: ExtendedImageGesturePageView.builder(
                    itemCount: images.length,
                    controller: ExtendedPageController(initialPage: index),
                    preloadPagesCount: 1,
                    itemBuilder: (context, index) {
                      return ExtendedImage(
                          initGestureConfigHandler: (state) {
                            return GestureConfig(
                                inPageView: true,
                                initialScale: 1.0,
                                cacheGesture: false);
                          },
                          mode: ExtendedImageMode.gesture,
                          onDoubleTap: (state) {
                            // currentIndex = index;
                            // rebuild.add(index);
                          },
                          fit: BoxFit.contain,
                          image: AssetEntityImageProvider(images[index],
                              isOriginal: true));
                    }),
              ),
            ),
          );
        });
  }
}

class GalleryPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var visible = true.obs;

  late AnimationController ac;
  @override
  void onInit() {
    super.onInit();
    ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(this.child, this.animationController, this.visible,
      {super.key});

  final AnimationController animationController;
  final Widget child;
  final bool visible;

  @override
  Size get preferredSize => const Size(double.infinity, 84);

  @override
  Widget build(BuildContext context) {
    visible ? animationController.reverse() : animationController.forward();
    return SlideTransition(
        position: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1))
            .animate(CurvedAnimation(
                parent: animationController, curve: Curves.easeOut)),
        child: Container(
          height: MediaQuery.of(context).viewPadding.top + 64,
          alignment: Alignment.bottomLeft,
          child: child,
        ));
  }
}
