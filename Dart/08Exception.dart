void main() {
  /*
    Dart 代码可以抛出和捕获异常。
    异常表示一些未知的错误情况，如果异常没有捕获则会被抛出从而导致抛出异常的代码终止执行。

    与 Java 不同的是，Dart 的所有异常都是非必检异常，方法不必声明会抛出哪些异常，并且你也不必捕获任何异常。

    Dart 提供了 Exception 和 Error 两种类型的异常以及它们一系列的子类，你也可以定义自己的异常类型。
    但是在 Dart 中可以将任何非 null 对象作为异常抛出而不局限于 Exception 或 Error 类型
  */

  // 抛出异常
  exceptionTest();
  exceptionTest2();
  distanceError(Point(1, 1));

  // 捕获异常
  try {
    distanceError(Point(1, 1));
  } on Exception catch (e) {
    print(e.toString());
  } catch (e) {
    print(e.toString());
  } finally {
    print("捕获完成")
  }

  // 对于可以抛出多种异常类型的代码，也可以指定多个 catch 语句，每个语句分别对应一个异常类型，
  // 如果 catch 语句没有指定异常类型则表示可以捕获任意异常类型

  // 如上述代码所示可以使用 on 或 catch 来捕获异常，使用 on 来指定异常类型，使用 catch 来捕获异常对象，两者可同时使用

  // 无论是否抛出异常，finally 语句始终执行，如果没有指定 catch 语句来捕获异常，则异常会在执行完 finally 语句后抛出
}

void exceptionTest() {
  throw FormatException("1231");
}

// 也可以抛出任意的对象
void exceptionTest2() {
  throw "adasdasd";
}

// 为抛出异常是一个表达式，所以可以在 => 语句中使用，也可以在其他使用表达式的地方抛出异常
void distanceError(Point p) => throw UnimplementedError();
