import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_01_text_app/2_layout_components/AfterLayoutTest.dart';
import 'package:flutter_01_text_app/2_layout_components/BoxConstraints.dart';
import 'package:flutter_01_text_app/2_layout_components/align_center_layout.dart';
import 'package:flutter_01_text_app/2_layout_components/flextest.dart';
import 'package:flutter_01_text_app/2_layout_components/stack_positioned_layout.dart';
import 'package:flutter_01_text_app/2_layout_components/wrap_flow_layout_test.dart';

import 'LayoutBuilderTest.dart';

var constraintsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const BoxConstraintsTest();
});

var flexHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const FlexTest();
});

var flowHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const WrapFlowLayoutTest();
});

var stackHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const StackPositionedLayoutTest();
});

var alignHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const AlignCenterLayoutTest();
});

var layoutBuilderHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const LayoutBuilderTest();
});

var afterLayoutHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const AfterLayoutTest();
});
