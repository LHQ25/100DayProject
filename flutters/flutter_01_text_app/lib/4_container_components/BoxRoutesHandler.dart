import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_01_text_app/4_container_components/05_1_padding_test.dart';
import 'package:flutter_01_text_app/4_container_components/05_2_decoratedbox_test.dart';
import 'package:flutter_01_text_app/4_container_components/05_3_transform_test.dart';
import 'package:flutter_01_text_app/4_container_components/05_4_container_test.dart';
import 'package:flutter_01_text_app/4_container_components/05_5_clip_test.dart';
import 'package:flutter_01_text_app/4_container_components/05_7_Scaffold_test.dart';

import '05_6_fittedbox_test.dart';

var paddingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const PaddingTest();
});

var decoratedBoxHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const DecoratedBoxTest();
});

var transformHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const TransformTest();
});

var containerHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const ContainerTest();
});

var clipHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const ClipTest();
});

var fittedBoxHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const FittedBoxTest();
});

var scaffoldHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const ScaffoldTest();
});
