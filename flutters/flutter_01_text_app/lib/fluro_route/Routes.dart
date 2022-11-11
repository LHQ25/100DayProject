import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_01_text_app/1_base_components/FirstRoutesHander.dart';
import 'package:flutter_01_text_app/2_layout_components/layout_routes.dart';
import 'package:flutter_01_text_app/EmptyPageView.dart';
import 'package:flutter_01_text_app/4_container_components/BoxRoutesHandler.dart';
import 'package:flutter_01_text_app/fluro_route/route_handles.dart';
import 'package:flutter_01_text_app/login/LoginRoutes.dart';
import '../home/HomeRouter.dart';
import '../six_part/ScrollViewRoutes.dart';

class Routes {
  static String home = "/";

  /// 第三章  基础组件
  static String textPageView = "/textHandler";
  static String buttonPageView = "/buttonPageView";
  static String imageIconPageView = "/image_IconPageView";
  static String checkPageView = "/checkPageView";
  static String formPageView = "/formPageView";
  static String progressPageView = "/progressPageView";

  /// 第四章
  static String constraintsPageView = "/constraintsPageView";
  static String flexPageView = "flexPageView";
  static String flowPageView = "flowPageView";
  static String stackPageView = "stackPageView";
  static String alignPageView = "alignPageView";
  static String layoutBuilderPageView = "layoutBuilderPageView";
  static String afterLayoutPageView = "afterLayoutPageView";

  /// 第五章
  static String paddingPageView = "/paddingPageView";
  static String decoratedBoxPageView = "decoratedBoxPageView";
  static String transformPageView = "transformPageView";
  static String containerPageView = "containerPageView";
  static String clipPageView = "clipPageView";
  static String fittedBoxPageView = "fittedBoxPageView";
  static String scaffoldPageView = "scaffoldPageView";

  /// 第六章
  static String singleScrollPageView = "singleScrollPageView";
  static String listViewPageView = "listViewPageView";
  static String scrollControllerPageView = "scrollControllerPageView";
  static String animatedListPageView = "animatedListPageView";
  static String gridViewPageView = "gridViewPageView";

  static String willPopscope = "/willpopscope";

  static String verificationCodePageView = "/verificationCode";

  static void configureRoutes(FluroRouter router) {
    router.define(home, handler: homeHandler);

    router.define(textPageView, handler: textHandler);
    router.define(buttonPageView, handler: buttonHandler);
    router.define(imageIconPageView, handler: imageHandler);
    router.define(checkPageView, handler: checkHandler);
    router.define(formPageView, handler: formHandler);
    router.define(progressPageView, handler: progressHandler);

    router.define(constraintsPageView, handler: constraintsHandler);
    router.define(flexPageView, handler: flexHandler);
    router.define(flowPageView, handler: flowHandler);
    router.define(stackPageView, handler: stackHandler);
    router.define(alignPageView, handler: alignHandler);
    router.define(layoutBuilderPageView, handler: layoutBuilderHandler);
    router.define(afterLayoutPageView, handler: afterLayoutHandler);

    router.define(paddingPageView, handler: paddingHandler);
    router.define(decoratedBoxPageView, handler: decoratedBoxHandler);
    router.define(transformPageView, handler: transformHandler);
    router.define(containerPageView, handler: containerHandler);
    router.define(clipPageView, handler: clipHandler);
    router.define(fittedBoxPageView, handler: fittedBoxHandler);
    router.define(scaffoldPageView, handler: scaffoldHandler);

    router.define(singleScrollPageView, handler: singleScrollHandler);
    router.define(listViewPageView, handler: listViewHandler);
    router.define(scrollControllerPageView, handler: scrollControllerHandler);
    router.define(animatedListPageView, handler: animateListHandler);
    router.define(gridViewPageView, handler: gridHandler);

    router.define(willPopscope, handler: willPopScopeHandler);

    router.define(verificationCodePageView, handler: VerificationLoginHandler);

    router.notFoundHandler = emptyHandler;
  }
}

var emptyHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const EmptyPageView();
});
