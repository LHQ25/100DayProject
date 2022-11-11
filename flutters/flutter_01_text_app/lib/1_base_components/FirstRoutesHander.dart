import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/1_base_components/TextTest.dart';
import 'package:flutter_01_text_app/1_base_components/image&icon_test.dart';
import 'package:flutter_01_text_app/1_base_components/progress_indicator.dart';
import 'package:flutter_01_text_app/1_base_components/radio_checkbox_test.dart';
import 'package:flutter_01_text_app/1_base_components/form_test.dart';

import 'ButtonTest.dart';

var textHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const TextTest();
});

var buttonHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const ButtonTest();
});

var imageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const ImageTest();
});

var checkHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const RadioCheckBoxTest();
});

var formHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const FormTest();
});

var progressHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const ProgressIndicatorTest();
});
