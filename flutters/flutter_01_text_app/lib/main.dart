import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/fluro_route/Routes.dart';

void main() {
  runApp(const AppComponent());
}

class Application {
  static late FluroRouter router;
}

class AppComponent extends StatefulWidget {
  const AppComponent({super.key});

  @override
  State<AppComponent> createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> {
  _AppComponentState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: "Demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      onGenerateRoute: Application.router.generator,
    );
    return app;
  }
}
