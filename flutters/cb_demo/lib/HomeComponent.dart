import 'package:cb_demo/artic/ArticPageView.dart';
import 'package:flutter/material.dart';

import 'auction/AuctionpageView.dart';
import 'category/ShopCategoryPageView.dart';
import 'mine/MinePageView.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({Key? key}) : super(key: key);

  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  int _currentIndex = 0;
  late PageController _pageController;
  late PageScrollPhysics _pageScrollPhysics;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _pageScrollPhysics = const PageScrollPhysics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const AuctionController();
          } else if (index == 1) {
            return const GoodsCategoryPageView();
          } else if (index == 2) {
            return const ArticPageView();
          } else if (index == 3) {
            return const MinePageView();
          }
          return Center(
            child: Text("$_currentIndex index"),
          );
        },
        onPageChanged: (index) => setState(() {
          _currentIndex = index;
        }),
        physics: _pageScrollPhysics,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
                if (_currentIndex != value) {
                  _currentIndex = value;
                  _pageController.jumpToPage(value);
                }
              }),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedIconTheme: const IconThemeData(
              color: Color.fromARGB(255, 88, 10, 5), size: 36),
          iconSize: 36,
          items: [
            _createBottomNavigationBar("tab_pai", "tab_pai_sel", "拍卖"),
            _createBottomNavigationBar("tab_cate", "tab_cate_sel", "分类"),
            _createBottomNavigationBar("tab_home", "tab_home_sel", "广场"),
            _createBottomNavigationBar("tab_mine", "tab_mine_sel", "我的"),
          ]),
    );
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
