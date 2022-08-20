void main() {
  // Dart 代码库中有大量返回 Future 或 Stream 对象的函数，这些函数都是 异步 的，它们会在耗时操作（比如I/O）执行完毕前直接返回而不会等待耗时操作执行完毕
  // async 和 await 关键字用于实现异步编程，并且让你的代码看起来就像是同步的一样

  /* ------------------- 处理 Future ------------------- */
  // 可以通过下面两种方式，获得 Future 执行完成的结果：
  // 使用 async 和 await，在 异步编程 codelab 中有更多描述；
  // 使用 Future API，具体描述参考 库概览。
  // 使用 async 和 await 的代码是异步的，但是看起来有点像同步代码。
}

Future<Void> checkVersion() async {
  var sersion = await lookUpVersion();
}

/* ------------------- 声明异步函数 ------------------- */
// 异步函数 是函数体由 async 关键字标记的函数。
// 将关键字 async 添加到函数并让其返回一个 Future 对象
Future<String> String lookUpVersion() async => '1.0.0';
// 注意，函数体不需要使用 Future API。如有必要，Dart 会创建 Future 对象。
// 如果函数没有返回有效值，需要设置其返回类型为 Future<void>