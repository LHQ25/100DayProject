import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/controllers/create_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'gallery_page.dart';

class CreatePage extends StatelessWidget {
  CreatePage({super.key});

  final _controller = Get.put(CreateController());
  final images = <AssetEntityImage>[];
  Widget _buildImages(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      double width = (constraint.maxWidth - 16) / 3.0;
      return Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: [
              for (final e in _controller.images)
                Draggable<AssetEntity>(
                    onDragStarted: () {
                      _controller.onDragStarted.value = true;
                    },
                    onDragEnd: (details) {
                      _controller.onDragStarted.value = false;
                      _controller.onAccept.value = false;
                    },
                    onDraggableCanceled: (v, offset) {
                      _controller.onDragStarted.value = false;
                    },
                    onDragCompleted: () {},
                    data: e,
                    feedback: Container(
                      width: width,
                      height: width,
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(6)),
                      child: AssetEntityImage(
                        e,
                        isOriginal: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                    childWhenDragging: Container(
                      width: width,
                      height: width,
                      color: Colors.black12,
                    ),
                    child: InkWell(
                      onTap: () => Get.to(GalleryPage(
                          _controller.images.indexOf(e),
                          _controller.images.toList())),
                      child: Container(
                        width: width,
                        height: width,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: AssetEntityImage(
                          e,
                          isOriginal: false,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              if (_controller.imagesCount < 9)
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        color: Colors.grey[300]),
                    width: width,
                    height: width,
                    child: const Icon(
                      Icons.add_box_rounded,
                      size: 30,
                      color: Colors.black38,
                    ),
                  ),
                  onTap: () => _controller.imagePicker(context),
                )
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomSheet: Obx(() => _controller.onDragStarted.value
          ? DragTarget<AssetEntity>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: 300,
                  color: Colors.red
                      .withOpacity(_controller.onAccept.value ? 1 : 0.3),
                );
              },
              onWillAccept: (obj) {
                _controller.onAccept.value = true;
                return true;
              },
              onAccept: (obj) {
                _controller.deleteImage(obj);
              },
              onLeave: (obj) {
                _controller.onAccept.value = false;
              },
            )
          : const SizedBox.shrink()),
      body: Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            _buildImages(context),
          ],
        ),
      ),
    );
  }
}
