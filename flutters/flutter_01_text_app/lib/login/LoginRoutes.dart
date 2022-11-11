import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_01_text_app/login/VerificationCodeLoginPageView.dart';

var VerificationLoginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const VerificationCodeLoginPageView();
});
