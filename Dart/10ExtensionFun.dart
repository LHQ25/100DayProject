import 'string_opis.dart';

void main() {
  // 系统
  print(int.parse('42'));
  // 扩展
  print('42'.parseInt());
}

/* ---------- 扩展方法 ----------*/
// 扩展方法是向现有库添加功能的一种方式。你可能已经在不知道它是扩展方法的情况下使用了它。例如，当您在 IDE 中使用代码完成功能时，它建议将扩展方法与常规方法一起使用
extension NuberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}
