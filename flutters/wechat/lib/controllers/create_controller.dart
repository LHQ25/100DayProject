import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreateController extends GetxController {
  var images = RxList<AssetEntity>();
  var onDragStarted = false.obs;
  var onAccept = false.obs;

  int get imagesCount {
    return images.length;
  }

  void deleteImage(AssetEntity obj) {
    images.remove(obj);
  }

  void imagePicker(BuildContext context) async {
    var ss = images.toList();
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: ss,
        maxAssets: 9,
      ),
    );
    if (result != null) {
      images.value = result;
    }
  }
}
