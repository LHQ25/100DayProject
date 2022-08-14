void main() {
  // 变量仅存储对象的引用。这里名为 name 的变量存储了一个 String 类型对象的引用，“Bob” 则是该对象的值
  var name = "bob";
  print(name);
  // name 变量的类型被推断为 String，但是你可以为其指定类型
  // 如果一个对象的引用不局限于单一的类型，可以将其指定为 Object（或 dynamic）类型
  Object name2 = "Bob2";
  print(name2);
  // 指定类型
  String name3 = "Bob3";
  print(name3);
  // 风格建议指南 中的建议，通过 var 声明局部变量而非使用指定的类型

  /// 默认值
  // 在 Dart 中，未初始化以及可空类型的变量拥有一个默认的初始值 null。（如果你未迁移至 空安全，所有变量都为可空类型。）
  // 即便数字也是如此，因为在 Dart 中一切皆为对象，数字也不例外
  int? lineCount;
  print(lineCount);

  // 开启 空安全 后在使用变量后必须进行初始化
  int lineCount2 = 0;
  print(lineCount2);

  // 不必在声明它的地方初始化局部变量，但需要在使用它之前为其分配一个值,下面的代码是有效的，因为 Dart 可以在 lineCount 被传递给 print() 时检测到它是非空的：
  int lineCount3;
  if (true) {
    lineCount3 = 3;
  }
  print(lineCount3);

  // 顶级和类变量被延迟初始化； 初始化代码在第一次使用该变量时运行。

  desciption = "1234";
  print(desciption);

  /// Final 和 Const
  // 如果你不想更改一个变量，可以使用关键字 final 或者 const 修饰变量，这两个关键字可以替代 var 关键字或者加在一个具体的类型前。
  // 一个 final 变量只可以被赋值一次；
  // 一个 const 变量是一个编译时常量（const 变量同时也是 final 的）。
  // 顶层的 final 变量或者类的 final 变量在其第一次使用的时候被初始化。
  final name4 = "name4";
  final String nickname = "nc";
  // name4 = "new name4"; // error
  // 使用关键字 const 修饰变量表示该变量为 编译时常量。
  // 如果使用 const 修饰类中的变量，则必须加上 static 关键字，
  // 即 static const（译者注：顺序不能颠倒）。
  // 在声明 const 变量时可以直接为其赋值，也可以使用其它的 const 变量为其赋值：
  const bar = 100000;
  const double atm = 1.01325 * bar;
  // const 关键字不仅仅可以用来定义常量，还可以用来创建 常量值，该常量值可以赋予给任何变量。
  // 你也可以将构造函数声明为 const 的，这种类型的构造函数创建的对象是不可改变的。
  var foo = const [];
  final bar2 = const [];
  const baz = []; // Euqivalent to `const []`

  // 如果使用初始化表达式为常量赋值可以省略掉关键字 const，比如上面的常量 baz 的赋值就省略掉了 const。详情请查阅 不要冗余地使用 const。
  // 没有使用 final 或 const 修饰的变量的值是可以被更改的，即使这些变量之前引用过 const 的值
  foo = [1, 2, 3]; // was const []
  // baz = [42]; // Error: 常量值不能被修改

  /// 类型检查
  const Object i = 3;
  const list = [i as Int];
  const map = { if (i is Int) i: "int"};
  const set = { if (list is List<int>) ...list }
}

/// 懒加载
late String desciption;
