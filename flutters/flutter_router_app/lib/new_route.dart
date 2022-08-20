import 'package:flutter/material.dart';

class NewRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewRouteState();
}

class _NewRouteState extends State<NewRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Route'),
      ),
      body: Center(
        child: Text('This is new route'),
      ),
    );
  }
}
