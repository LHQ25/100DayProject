import 'package:flutter/material.dart';

class StatelessTest extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const StatelessTest(
      {Key? key, required this.text, this.backgroundColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Container(
          color: backgroundColor,
          child: Text(text),
        ),
      ),
    );
  }
}
