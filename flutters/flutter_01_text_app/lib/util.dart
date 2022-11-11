import 'dart:ui';

double ScreenWidth() {
  return window.physicalSize.width/window.devicePixelRatio;
}

double ScreenHeight(){
  return window.physicalSize.height/window.devicePixelRatio;
}

double FitWidth(double width) {
  return ScreenWidth()/375.0 *width;
}

double FitHeight(double height) {
  return ScreenHeight()/667.0 *height;
}