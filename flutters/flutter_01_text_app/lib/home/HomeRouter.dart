import 'package:fluro/fluro.dart';
import 'homepage.dart';

var homeHandler = Handler(handlerFunc: (context, paramter) {
  return const HomePageView();
});
