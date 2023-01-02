import 'package:cb_demo/auction/presentation/controller/GlobelAuctionController.dart';
import 'package:get/instance_manager.dart';

class GlobelAuctionBinding extends Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut(() => GlobelAuctionController());
  }

}