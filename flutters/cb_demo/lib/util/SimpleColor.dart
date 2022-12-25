import 'package:flutter/material.dart';

const Color color111111 = Color(0xFF111111);
const Color color222222 = Color(0xFF222222);
const Color color333333 = Color(0xFF333333);
const Color color666666 = Color(0xFF666666);
const Color color999999 = Color(0xFF999999);

const Color colorF72800 = Color(0xFFF72800);

extension SimpleColor on Colors {

  static const Color colorF72800 = Color(0xFFF72800);
  static const Color black2 = Color(0xFF000000);

  Color get black3 {
    return const Color(0xFF000000);
  }

}

class Test {

  void test(){
    var c = Colors.black2;
  }
}