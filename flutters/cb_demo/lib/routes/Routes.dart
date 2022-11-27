import 'package:cb_demo/artic/ArticleVideoPageView.dart';
import 'package:cb_demo/mine/MineJoinPageView.dart';
import 'package:cb_demo/util/WebView.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../HomeComponent.dart';

class Application {
  static late final FluroRouter router;
}

class Routes {
  static String root = "/";
  static String webView = "webView";
  static String videoView = "videoView";
  static String joinView = "JoinPageView";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root, handler: rootHandler);
    router.define(webView, handler: webViewHandler);
    router.define(videoView, handler: videoViewHandler);
    router.define(joinView, handler: joinPageHandler);
    // router.define(demoSimple, handler: demoRouteHandler);
    // router.define(demoSimpleFixedTrans,
    //     handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
    // router.define(demoFunc, handler: demoFunctionHandler);
    // router.define(deepLink, handler: deepLinkHandler);
  }
}

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const HomeComponent();
});

var webViewHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? url = params["url"]?.first;

  return CustomWebView(url);
});

var videoViewHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? url = params["url"]?.first;

  return const ArticleVideoPageView();
});

var joinPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const MineJoinPageView();
});
//
// var demoFunctionHandler = Handler(
//     type: HandlerType.function,
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       String? message = params["message"]?.first;
//       showDialog(
//         context: context!,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(
//               "Hey Hey!",
//               style: TextStyle(
//                 color: const Color(0xFF00D6F7),
//                 fontFamily: "Lazer84",
//                 fontSize: 22.0,
//               ),
//             ),
//             content: Text("$message"),
//             actions: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   child: Text("OK"),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     });
//
// /// Handles deep links into the app
// /// To test on Android:
// ///
// /// `adb shell am start -W -a android.intent.action.VIEW -d "fluro://deeplink?path=/message&mesage=fluro%20rocks%21%21" com.theyakka.fluro`
// var deepLinkHandler = Handler(
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       String? colorHex = params["color_hex"]?.first;
//       String? result = params["result"]?.first;
//       Color color = Color(0xFFFFFFFF);
//       if (colorHex != null && colorHex.length > 0) {
//         color = Color(ColorHelpers.fromHexString(colorHex));
//       }
//       return DemoSimpleComponent(
//           message: "DEEEEEP LINK!!!", color: color, result: result);
//     });
