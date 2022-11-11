import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/home/basepage.dart';

import '../login/LoginPageView.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final _titles = <String>['基础', '我的'];
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    // _pageController.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return const BaseComponentPageView();
          }
          return const LoginPageView();
        },
        itemCount: _titles.length,
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  _bottomBar() {
    var items = <BottomNavigationBarItem>[];
    for (var title in _titles) {
      items.add(BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: title,
          activeIcon: const Icon(Icons.home_filled)));
    }
    return BottomNavigationBar(
      items: items,
      onTap: (value) {
        if (value == _currentIndex) {
          return;
        }
        setState(() {
          _currentIndex = value;
          _pageController.jumpToPage(value);
        });
      },
      currentIndex: _currentIndex,
    );
  }
}
