import 'package:cb_demo/HomeComponent.dart';
import 'package:cb_demo/auction/vm/auction_binding.dart';
import 'package:cb_demo/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(const AppComponent());
}

class AppComponent extends StatelessWidget {
  const AppComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "FluroDemo",
      debugShowCheckedModeBanner: false,
      enableLog: true,
      logWriterCallback: Logger.write,
      initialBinding: HomeComponentBinding(),
      initialRoute: AppPages.home,
      getPages: AppPages.routes,
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.white),
      themeMode: ThemeMode.system,
      home: const HomeComponent(),
    );
  }
}

mixin Logger {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    Future.microtask(() => print('** $text. isError: [$isError]'));
  }
}

// class AppComponent2 extends StatefulWidget {
//   const AppComponent2({super.key});

//   @override
//   State createState() {
//     return AppComponentState();
//   }
// }

// class AppComponentState extends State<AppComponent2> {
//   AppComponentState() {
//     final router = FluroRouter();
//     Routes.configureRoutes(router);
//     Application.router = router;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const GetMaterialApp(
//       title: "FluroDemo",
//       home: AppComponent(),
//     );
//     // final app = MaterialApp(
//     //   title: 'FluroDemo',
//     //   debugShowCheckedModeBanner: false,
//     //   theme: ThemeData(
//     //       primarySwatch: Colors.cyan,
//     //       highlightColor: Colors.pink,
//     //       splashColor: Colors.transparent),
//     //   onGenerateRoute: Application.router.generator,
//     // );
//     // return app;
//   }
// }
