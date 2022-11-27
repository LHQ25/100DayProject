import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 14,
      textColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.35),
    );
