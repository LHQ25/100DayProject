import 'package:flutter/gestures.dart';

import 'artic/ArticPageView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auction/presentation/controller/AuctionpageView.dart';
import 'category/ShopCategoryPageView.dart';
import 'mine/MinePageView.dart';

// class HomeComponent extends StatefulWidget {
//   HomeComponent({Key? key}) : super(key: key);

//   final Controller = Get.find();

//   @override
//   State<HomeComponent> createState() => _HomeComponentState();
// }

class HomeComponentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeComponentController());
  }
}

class HomeComponentController extends GetxController {
  HomeComponentController();

  late PageScrollPhysics pageScrollPhysics;
  late PageController pageController;

  var currentIndex = 0.obs;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    pageScrollPhysics = const PageScrollPhysics();
    super.onInit();
  }

  void changeBottonBar(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      pageController.jumpToPage(index);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class HomeComponent extends GetView<HomeComponentController> {
  HomeComponent({Key? key}) : super(key: key);
  // final HomeComponentController c = Get.put(HomeComponentController());

  @override
  Widget build(BuildContext context) {
    if (controller.pageController.hasClients) {
      controller.onClose();
      controller.onInit();
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: PageView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            if (index == 0) {
              return AuctionController();
            } else if (index == 1) {
              return const GoodsCategoryPageView();
            } else if (index == 2) {
              return const ArticPageView();
            } else if (index == 3) {
              return const MinePageView();
            }
            return Center(
              child: Text("${controller.currentIndex.value} index"),
            );
          },
          onPageChanged: (index) => controller.currentIndex.value = index,
          physics: controller.pageScrollPhysics,
          controller: controller.pageController,
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              onTap: controller.changeBottonBar,
              currentIndex: controller.currentIndex.value,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              // selectedIconTheme: const IconThemeData(
              // color: Color.fromARGB(255, 88, 10, 5), size: 36),
              iconSize: 36,
              items: [
                _createBottomNavigationBar("tab_pai", "tab_pai_sel", "拍卖"),
                _createBottomNavigationBar("tab_cate", "tab_cate_sel", "分类"),
                _createBottomNavigationBar("tab_home", "tab_home_sel", "广场"),
                _createBottomNavigationBar("tab_mine", "tab_mine_sel", "我的"),
              ]),
        ));
  }

  BottomNavigationBarItem _createBottomNavigationBar(
      String imageName, String selImageName, String title) {
    return BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage("assets/images/tabbar/$imageName.png"),
        ),
        activeIcon: ImageIcon(
          AssetImage("assets/images/tabbar/$selImageName.png"),
        ),
        label: title,
        backgroundColor: Colors.white);
  }
}
