import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:advertising_id/advertising_id.dart';

class DioTest extends StatefulWidget {
  const DioTest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DioTestState();
}

class _DioTestState extends State<DioTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio'),
      ),
      body: const Center(
        child: Text('Dio'),
      ),
    );
  }
}
