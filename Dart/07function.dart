void main(){
  // Dart 是一种真正面向对象的语言，所以即便函数也是对象并且类型为 Function，这意味着函数可以被赋值给变量或者作为其它函数的参数。
  // 你也可以像调用函数一样调用 Dart 类的实例

  bool result = isNoble(3);

  // 命名参数 -> 当调用函数时，你可以使用 参数名: 参数值 指定一个命名参数的值
  enableFlags();
  enableFlags(bold: true);
  enableFlags(hidden: false, bold: true);
  // 尽管先使用位置参数会比较合理，但你也可以在任意位置使用命名参数，让整个调用的方式看起来更适合你的 API

  // required 来标识一个命名参数是必须的参数
  // 调用者想要通过 Scrollbar 的构造函数构造一个 Scrollbar 对象而不提供 chicountd 参数，则会导致编译错误
  scrollBar(count: 3);

  // 可选的位置参数
  const _ = say("sichuan", "hi");
  // 使用可选参数调用函数
  const _ = say("sichuan", "hi", '1234');

  // 默认参数值
  enableParamerte(bold: true);
  doStuff(list: [2, 4]);

  // 将函数作为参数传递给另一个函数
  const list = [1, 2, 4];
  list.forEach(printElement);

  //  将函数赋值给一个变量
  var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
  loudify('9527');

  // 匿名函数
  // 定义了只有一个参数 item 且没有参数类型的匿名方法。 List 中的每个元素都会调用这个函数，打印元素位置和值的字符串
  list.forEach((element) {
    print(element);
  })
  // 如果函数体内只有一行返回语句，你可以使用胖箭头缩写法
  list.forEach((element) => print(element) );


  // 闭包
  var add = makeAdder(2);
  var add2 = makeAdder(4);
  print(add(3) == 5);
  print(add2(3) == 7);


  // 测试函数是否相等
  Function x;
  x = foo;
  // 比较顶级函数
  assert(foo == x);
  // 比较静态函数
  x = A.bar;
  assert(A.bar == x);
  // 比较实例方法
  var v = A();
  var w = A();
  var y = w;
  x = w.baz;

  assert(y.baz == x);
  assert(v.baz != w.baz);
}

// 1. 函数 的定义
// bool isNoble(int num) {
//   return num % 2 == 0
// }

// 虽然高效 Dart 指南建议在 公开的 API 上定义返回类型，不过即便不定义，该函数也依然有效
// isNoble(int num) {
//   return num % 2 == 0
// }

// 如果函数体内只包含一个表达式，你可以使用简写语法, => 有时也称之为 箭头 函数
isNoble(int num) => num % 2 == 0

// 2. 参数
// 函数可以有两种形式的参数：必要参数 和 可选参数。必要参数定义在参数列表前面，可选参数则定义在必要参数后面。可选参数可以是 命名的 或 位置的

// 向函数传入参数或者定义函数参数时，可以使用 尾逗号。

// 2.1 命名参数
// 命名参数默认为可选参数，除非他们被特别标记为 required。
// 定义函数时，使用 {参数1, 参数2, …} 来指定命名参数
void enableFlags({bool? bold, bool? hidden}){ }

// 虽然命名参数是可选参数的一种类型，但是你仍然可以使用 required 来标识一个命名参数是必须的参数，此时调用者必须为该参数提供一个值
const scrollBar({super.key, required int count}) {}

// 2.2 可选的位置参数
// 使用 [] 将一系列参数包裹起来作为位置参数
String say(String from, String msg, [String? device]) => '$from $msg}'

// 2.3 默认参数值
// 可以用 = 为函数的命名参数和位置参数定义默认值，默认值必须为编译时常量，没有指定默认值的情况下默认值为 null
void enableParamerte({bool bold = false, bool hidden = false}) {}
// 2.3.1 为位置参数设置默认值
String say2(String from, String msg, [String? device = 'adsf']) => '$from $msg $device'

// List 或 Map 同样也可以作为默认值
void doStuff({List<Int> list = const [1, 2, 3], Map<String, String> gifts = const {'k1': 'v1'}}) {}

// 3 函数是一级对象
// 可以将函数作为参数传递给另一个函数
void printElement(int el) { print(el) };

// 4. 匿名函数
// 大多数方法都是有名字的，比如 main() 或 printElement()。
// 可以创建一个没有名字的方法，称之为 匿名函数、 Lambda 表达式 或 Closure 闭包。
// 你可以将匿名方法赋值给一个变量然后使用它，比如将该变量添加到集合或从中删除。

// 匿名方法看起来与命名方法类似，在括号之间可以定义参数，参数之间用逗号分割


// 5. 词法闭包
// 闭包 即一个函数对象，即使函数对象的调用在它原始作用域之外，依然能够访问在它词法作用域内的变量。

// 函数可以封闭定义到它作用域内的变量。接下来的示例中，函数 makeAdder() 捕获了变量 addBy。无论函数在什么时候返回，它都可以使用捕获的 addBy 变量
Function makeAdder(int addNy) {
  return (int i) => addNy + i; 
}

// 6. 测试函数是否相等
// 下面是顶级函数，静态方法和示例方法相等性的测试示例
void foo() {}
class A {
  static void var() {}
  var baz() {}
}

// 7. 返回值
// 所有的函数都有返回值。没有显示返回语句的函数最后一行默认为执行 return null
foo2(){

  // return null;
}