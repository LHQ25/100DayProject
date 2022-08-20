
const double xOrigin = 0;
const double yOrigin = 0;

void main() {
  // Dart 是支持基于 mixin 继承机制的面向对象语言，所有对象都是一个类的实例，而除了 Null 以外的所有的类都继承自 Object 类。
  // 基于 mixin 的继承 意味着尽管每个类（top class Object? 除外）都只有一个超类，一个类的代码可以在其它多个类继承中重复使用。
  // 扩展方法 是一种在不更改类或创建子类的情况下向类添加功能的方式

  // 1. 使用类的成员
  // 对象的 成员 由函数和数据（即 方法 和 实例变量）组成。方法的 调用 要通过对象来完成，这种方式可以访问对象的函数和数据
  const point = Point(3, 3);
  print(point.y);
  // 使用 ?. 代替 . 可以避免因为左边表达式为 null 而导致的问题
  print(point?.x);

  // 2. 使用构造函数
  // 可以使用 构造函数 来创建一个对象。构造函数的命名方式可以为 类名 或 类名 . 标识符 的形式。
  // 例如下述代码分别使用 Point() 和 Point.fromJson() 两种构造器创建了 Point 对象
  const p1 = Point.fromJson({'x': 2, 'y': 9});
  // 以下代码具有相同的效果，但是构造函数名前面的的 new 关键字是可选的
  // const p1 = new Point(3, 4);
  // const p1 = new Point.fromJson({'x': 2, 'y': 9});

  // 一些类提供了常量构造函数。使用常量构造函数，在构造函数名之前加 const 关键字，来创建编译时常量时
  var p2 = const ImmutablePoint(1, 1);

  // 两个使用相同构造函数相同参数值构造的编译时常量是同一个对象：
  var a = const ImmutablePoint(1, 1);
  var b = const ImmutablePoint(1, 1);
  assert(identical(a, b)); // They are the same instance!

  // 在 常量上下文 场景中，你可以省略掉构造函数或字面量前的 const 关键字。例如下面的例子中我们创建了一个常量 Map
  // const pointAndLine = const {
  // 'point': const [const ImmutablePoint(0, 0)],
  // 'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
  // };
  // 只保留第 一个 const 关键字，其余的全部省略
  const pointAndLine = {
    'point': [ImmutablePoint(0, 0)],
    'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
  };
  // 但是如果无法根据上下文判断是否可以省略 const，则不能省略掉 const 关键字，否则将会创建一个 非常量对象

  // 3. 获取对象的类型
  // 可以使用 Object 对象的 runtimeType 属性在运行时获取一个对象的类型，该对象类型是 Type 的实例
  const p = MyPoint();
  print(p.runtimeType);

  // 4. 实例变量
  var mp = MyPoint('muNAAsd');
  const mp2 = MyPoint(1, 2);
  mp.x = 3;
  print('${mp.toString()} ${mp.x}, ${mp.y}, ${mp.z}');

}

class MyPoint {
  double? x; // 实例变量，可能为null
  double? y; // 实例变量，可能为null
  double z = 0; // 实例变量，默认值为 0
  // 所有未初始化的实例变量其值均为 null
  // 所有实例变量均会隐式地声明一个 Getter 方法。非 final 的实例变量和 late final 声明但未声明初始化的实例变量还会隐式地声明一个 Setter 方法

  // 必须设置值， 使用构造函数参数或者构造函数的初始化列表或者
  final String name;
  final DateTime start = dea

  // 构造函数: 声明一个与类名一样的函数即可声明一个构造函数（对于命名式构造函数 还可以添加额外的标识符）。
  // 大部分的构造函数形式是生成式构造函数，其用于创建一个类的实例
  MyPoint(int x, int y) {
    this.x = x;
    this.y = y;
  }
  // 构造函数 终值初始化：构造中初始化的参数可以用于初始化非空或 final 修饰的变量，它们都必须被初始化或提供一个默认值
  // 在初始化时出现的变量默认是隐式终值，且只在初始化时可用
  MyPoint(this.name);
  MyPoint(this.x, this.y);
  // 构造函数 初始化列表
  MyPoint.unName(): name = '';

  // 默认构造函数
  // 如果你没有声明构造函数，那么 Dart 会自动生成一个无参数的构造函数并且该构造函数会调用其父类的无参数构造方法。

  // 构造函数不被继承
  // 子类不会继承父类的构造函数，如果子类没有声明构造函数，那么只会有一个默认无参数的构造函数。

  // 命名式构造函数
  // 可以为一个类声明多个命名式构造函数来表达更明确的意图
  MyPoint.origin(): x = xOrigin, y = yOrigin;
  MyPoint.origin(int x, int y): this.x = x, this.y = y;
  // 构造函数是不能被继承的，这将意味着子类不能继承父类的命名式构造函数，如果你想在子类中提供一个与父类命名构造函数名字一样的命名构造函数，则需要在子类中显式地声明

  // 调用父类非默认构造函数
  // 默认情况下，子类的构造函数会调用父类的匿名无参数构造方法，并且该调用会在子类构造函数的函数体代码执行前，如果子类构造函数还有一个 初始化列表，那么该初始化列表会在调用父类的该构造函数之前被执行，总的来说，这三者的调用顺序如下：
    // 初始化列表
    // 父类的无参数构造函数
    // 当前类的构造函数
  // 如果父类没有匿名无参数构造函数，那么子类必须调用父类的其中一个构造函数，为子类的构造函数指定一个父类的构造函数只需在构造函数体前使用（:）指定

  // 传递给父类构造函数的参数不能使用 this 关键字，因为在参数传递的这一步骤，子类构造函数尚未执行，子类的实例对象也就还未初始化，
  // 因此所有的实例成员都不能被访问，但是类成员可以


  /// 超类参数
  // 为了不重复地将参数传递到超类构造的指定参数，你可以使用超类参数，直接在子类的构造中使用超类构造的某个参数。
  // 超类参数不能和重定向的参数一起使用。超类参数的表达式和写法与 终值初始化 类似


  /// 初始化列表
  // 除了调用父类构造函数之外，还可以在构造函数体执行之前初始化实例变量。每个实例变量之间使用逗号分隔
  MyPoint.fromJson(map<String, String> json): x = json['x'], y = json['y'] {
    print('construct from json')
  }

  /// 重定向构造函数
  // 有时候类中的构造函数仅用于调用类中其它的构造函数，此时该构造函数没有函数体，只需在函数签名后使用（:）指定需要重定向到的其它构造函数 (使用 this 而非类名)
  MyPoint.alongXAxis(double x): this(x, 0);


  // 常量构造函数
  // 如果类生成的对象都是不变的，可以在生成这些对象时就将其变为编译时常量。
  // 你可以在类的构造函数前加上 const 关键字并确保所有实例变量均为 final 来实现该功能


  /// 工厂构造函数
  // 使用 factory 关键字标识类的构造函数将会令该构造函数变为工厂构造函数，这将意味着使用该构造函数构造类的实例时并非总是会返回新的实例对象
  // 在工厂构造函数中无法访问 this
  factory MyPoint(double x){
    
  }


  /// 方法
  // 实例方法
  double distanceTo(Point other) {
    const dx = x - other.x;
    const dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  void doSomething() {
    
  }

  /* -------------- noSuchMethod 方法 -------------- */
  // 如果调用了对象上不存在的方法或实例变量将会触发 noSuchMethod 方法，你可以重写 noSuchMethod 方法来追踪和记录这一行为
  @override
  void NoSuchMethodError(Invocation invocation) {
    print("执行了 未定义的方法");
  }

  // 运算符重载
  MyPoint operator -(MyPoint o) => MyPoint(x - o.x, y - o.y);
  double distanceTo2(Point other) {
    const o = this - other;
    return sqrt(o.x * o.x + o.y * o.y);
  }

  /* -------------- setter & getter -------------- */
  double left = 0;
  double width = 0;
  MyPoint({double left, double width}){
    this.left = left;
    this.width = width;
  }
  // 计算属性 -> 使用 Getter 和 Setter 的好处是，你可以先使用你的实例变量，过一段时间过再将它们包裹成方法且不需要改动任何代码，即先定义后更改且不影响原有逻辑
  double get right => left + width;
  set right(double value) => left = value - width;
}

/* -------------- 抽象类 -------------- */
// 使用关键字 abstract 标识类可以让该类成为 抽象类，抽象类将无法被实例化。
// 抽象类常用于声明接口方法、有时也会有具体的方法实现。如果想让抽象类同时可被实例化，可以为其定义 工厂构造函数。
abstract class Doer {

  // 定义一个接口方法而不去做具体的实现让实现它的类去实现该方法，抽象方法只能存在于 抽象类中
  void doSomething() {}
}

class EffectiveEoer extends Doer {
  void doSomething() => print("重载");
}

/* -------------- 隐式接口 -------------- */
/*  
  每一个类都隐式地定义了一个接口并实现了该接口，这个接口包含所有这个类的实例成员以及这个类所实现的其它接口。
  如果想要创建一个 A 类支持调用 B 类的 API 且不想继承 B 类，则可以实现 B 类的接口。
  一个类可以通过关键字 implements 来实现一个或多个接口并实现每个接口定义的 API
*/
// A person. The implicit interface contains greet().
class Person {
  // In the interface, but visible only in this library.
  final String _name;

  // Not in the interface, since this is a constructor.
  Person(this._name);

  // In the interface.
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// An implementation of the Person interface.
class Impostor implements Person {
  String get _name => '';

  String greet(String who) => 'Hi $who. Do you know who I am?';
}

/* -------------- 扩展一个类 -------------- */
// 使用 extends 关键字来创建一个子类，并可使用 super 关键字引用一个父类
class EPoint extends MyPoint {

  void doSomething() {
    super.doSomething();
  }
}

/* -------------- 重写类成员 -------------- */
// 子类可以重写父类的实例方法（包括 操作符）、 Getter 以及 Setter 方法。你可以使用 @override 注解来表示你重写了一个成员：
class OPoint extends MyPoint {
  
  @override
  void doSomething() {
    print("重写方法");
  }
}

/* -------------- 调用父类非默认构造函数 -------------- */
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  
  Employee.fromJson(super.data): super.fromJson() {
    print('in Employee');
  }

  //因为参数会在子类构造函数被执行前传递给父类的构造函数，因此该参数也可以是一个表达式，比如一个函数
  Employee(): super.fromJson(fetchDefaultData())

  Map<String, String> fetchDefaultData() {
    return {};
  }
}




/// 超类参数
class Vector2d{
  final double x;
  final double y;

  Vector2d(this.x, this.y);

  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  final double z;

  // Vertor3d(final double x, final double y, this.z): super(x, y);
  Vector3d(super.x, super.y, this.z);

  // 如果超类构造的位置参数已被使用，那么超类构造参数就不能再继续使用被占用的位置。但是超类构造参数可以始终是命名参数：
  Vector3d.yzPlane({required super.y, required this.z}): super.named(x: x, y: 0);
}

// 常量构造函数
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;
  const ImmutablePoint(this.x, this.y);
}