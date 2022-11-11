import 'package:fluro/fluro.dart';
import 'package:flutter_01_text_app/six_part/06_3_listview_test.dart';
import 'package:flutter_01_text_app/six_part/06_4_scroll_controller.dart';
import 'package:flutter_01_text_app/six_part/06_5_%20animatedlist_test.dart';
import 'package:flutter_01_text_app/six_part/06_6_gridview_test.dart';
import '06_2_SingleChildScrollView_test.dart';

var singleScrollHandler = Handler(handlerFunc: (context, paramter) {
  return const SingleChildScrollViewTest();
});

var listViewHandler = Handler(handlerFunc: (context, paramter) {
  return const ListViewTest();
});

var scrollControllerHandler = Handler(handlerFunc: (context, paramter) {
  return const ScrollControllerTest();
});

var animateListHandler = Handler(handlerFunc: (context, paramter) {
  return const AnimatedListTest();
});

var gridHandler = Handler(handlerFunc: (context, paramter) {
  return const GridViewTest();
});
