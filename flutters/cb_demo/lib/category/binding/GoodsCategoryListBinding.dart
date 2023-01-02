
import 'package:cb_demo/category/controller/GoodsCategoryListController.dart';
import 'package:get/get.dart';

class GoodsCategoryListBinging extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => GoodsCategoryListController());
  }

}