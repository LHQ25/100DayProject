import 'package:cb_demo/routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

void main() {
  runApp(const AppComponent());
}

class AppComponent extends StatefulWidget {
  const AppComponent({super.key});

  @override
  State createState() {
    return AppComponentState();
  }
}

class AppComponentState extends State<AppComponent> {
  AppComponentState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'FluroDemo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          highlightColor: Colors.pink,
          splashColor: Colors.transparent),
      onGenerateRoute: Application.router.generator,
    );
    return app;
  }
}
