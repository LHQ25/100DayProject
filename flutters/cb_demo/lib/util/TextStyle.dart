import 'package:flutter/material.dart';

TextStyle regularStyle({required double fontSize, required Color color}) =>
    TextStyle(fontWeight: FontWeight.w400, fontSize: fontSize, color: color);

TextStyle mediumStyle({required double fontSize, required Color color}) =>
    TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize, color: color);

TextStyle boldTextStyle({required double size, required Color color}) =>
    TextStyle(fontWeight: FontWeight.w500, fontSize: size, color: color);

TextStyle semiBoldStyle({required double fontSize, required Color color}) =>
    TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize, color: color);
