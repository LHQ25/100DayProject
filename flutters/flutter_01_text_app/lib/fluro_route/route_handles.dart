import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_01_text_app/seven_part/01_willpopscope.dart';

var willPopScopeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const WillPopScopeTest();
});
