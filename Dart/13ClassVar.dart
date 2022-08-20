import 'dart:math';

void main() {
  // 静态变量在其首次被使用的时候才被初始化
  print(Queue.initialCapacity);

  print(Queue.distanceBetween(Point(1, 3), Point(5, 5)));
}

/* ---------------- 类变量和方法 ----------------*/
// 使用关键字 static 可以声明类变量或类方法。
class Queue {
  // 静态变量（即类变量）常用于声明类范围内所属的状态变量和常量
  static const initialCapacity = 16;

  // 静态方法（即类方法）不能对实例进行操作，因此不能使用 this。但是他们可以访问静态变量
  static double distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }

  // 对于一些通用或常用的静态方法，应该将其定义为顶级函数而非静态方法
}
