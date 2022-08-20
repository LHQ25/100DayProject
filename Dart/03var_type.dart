void main() {
  /*
    Dart 语言支持下列内容：

    Numbers (int, double)
    Strings (String)
    Booleans (bool)
    Lists (也被称为 arrays)

    ets (Set)
    Maps (Map)
    Runes (常用于在 Characters API 中进行字符替换)

    Symbols (Symbol)
    The value null (Null)
  */

  // Numbers, 支持两种 Number 类型, int double
  var x = 1;
  var hex = 0xDEADBEEF;
  // 一个数字包含了小数点，那么它就是浮点型的
  var y = 1.1;
  var exponents = 1.43e5;
  // 还可以将变量声明为 num。 如果这样做，变量可以同时具有整数和双精度值。
  num x2 = 1;
  x2 += 2.5;
  // 整型字面量将会在必要的时候自动转换成浮点数字面量：
  double z = 1; // Equivalent to double z = 1.0

  // 字符串和数字转换
  // Sting -> int
  var one = int.parse('1');
  print(one);
  // String -> double
  var onePointOne = double.parse('1.1');
  print(onePointOne);
  // int -> String
  String nsAsString = 1.toString();
  print(nsAsString);
  // double -> String
  String piAsString = 3.14156.toStringAsFixed(2);
  print(piAsString);

  // 整型支持传统的位移操作，比如移位（<<、>> 和 >>>）、补码 (~)、按位与 (&)、按位或 (|) 以及按位异或 (^)
  print(3 << 1 == 6);
  print(3 | 4 == 7);
  print(3 & 4 == 0);

  // 数字字面量为编译时常量。很多算术表达式只要其操作数是常量，则表达式结果也是编译时常量
  const msPerSecond = 1000;
  const secondsUntilRetry = 5;
  const msUntilRetry = secondsUntilRetry + msPerSecond;
  print("$msPerSecond, $secondsUntilRetry, $msUntilRetry");

  /// 字符串
  // Dart 字符串（String 对象）包含了 UTF-16 编码的字符序列。可以使用单引号或者双引号来创建字符串
  var s1 = 'Single quotes work well for string literals.';
  var s2 = "Double quotes work just as well.";
  var s3 = 'It\'s easy to escape the string delimiter.';
  var s4 = "It's even easier to use the other delimiter.";
  print("$s1 $s2 $s3 $s4");
  // 代码中文解释
  var s11 = '使用单引号创建字符串字面量。';
  var s22 = "双引号也可以用于创建字符串字面量。";
  var s33 = '使用单引号创建字符串时可以使用斜杠来转义那些与单引号冲突的字符串：\'。';
  var s44 = "而在双引号中则不需要使用转义与单引号冲突的字符串：'";
  print("$s11 $s22 $s33 $s44");

  // 在字符串中，请以 ${表达式} 的形式使用表达式，如果表达式是一个标识符，可以省略掉 {}。
  // 如果表达式的结果为一个对象，则 Dart 会调用该对象的 toString 方法来获取一个字符串
  var s = 'string interpolation';
  print('Dart has $s, which is very handy.');
  print(
      'That deserves all caps. ${s.toUpperCase()} is very handy! STRING INTERPOLATION is very handy!');

  // 使用 + 运算符或并列放置多个字符串来连接字符串
  print("string1" + " string2");

  // 使用三个单引号或者三个双引号也能创建多行字符串
  print("""
  lin1 
  lin2 
  lin3
  """);
  print('''
  lin1 
  lin2 
  lin3
  ''');

  // 在字符串前加上 r 作为前缀创建 “raw” 字符串（即不会被做任何处理（比如转义）的字符串）
  print(r"dawdwa \n \t \g dawd打我大无");

  // 字符串字面量是一个编译时常量，只要是编译时常量 (null、数字、字符串、布尔) 都可以作为字符串字面量的插值表达式
  // These work in a const string.
  const aConstNum = 0;
  const aConstBool = true;
  const aConstString = 'a constant string';

  // These do NOT work in a const string.
  var aNum = 0;
  var aBool = true;
  var aString = 'a string';
  const aConstList = [1, 2, 3];

  const validConstString = '$aConstNum $aConstBool $aConstString';
  // const invalidConstString = '$aNum $aBool $aString $aConstList';

  // MARK: - 布尔类型
  // Dart 使用 bool 关键字表示布尔类型，布尔类型只有两个对象 true 和 false，两者都是编译时常量
  // Dart 的类型安全不允许你使用类似 if (nonbooleanValue) 或者 assert (nonbooleanValue) 这样的代码检查布尔值。相反，你应该总是显示地检查布尔值
  // check is empty
  var funllName = '';
  if (funllName.isEmpty) {}

  // chenc is zero
  var hitPoints = 0;
  if (hitPoints < 0) {}

  // check is null
  var unicon;
  if (unicon == null) {}

  // check is NaN
  var isMeant = 0 / 0;
  if (isMeant.isNaN) {}
}
