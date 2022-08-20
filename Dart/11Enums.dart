
void main(){

  /* ------------------ 使用枚举 ------------------*/
  // 可以像访问 静态变量 一样访问枚举值
  final favoriteColor = Color.blue;

  // 每一个枚举值都有一个名为 index 成员变量的 Getter 方法，该方法将会返回以 0 为基准索引的位置值。例如，第一个枚举值的索引是 0 ，第二个枚举值的索引是 1。以此类推
  print(favoriteColor.index);
  print(Color.green.index);

  // 获得全部的枚举值，使用枚举类的 values 方法获取包含它们的列表
  const colors = Color.values;

  // 在 Switch 语句中使用枚举，但是需要注意的是必须处理枚举值的每一种情况，即每一个枚举值都必须成为一个 case 子句，不然会出现警告
  switch favoriteColor {
    case Color.blue:
    print("b");
    break;
    case Color.red:
    print("r");
    break;
    case Color.green:
    print("g");
    break;
  }

  // 获取一个枚举值的名称
  print(Color.blue.name);
}

/* ------------------ 枚举类型 ------------------*/
// 枚举类型是一种特殊的类型，也称为 enumerations 或 enums，用于定义一些固定数量的常量值
// 备注:
// 所有的枚举都继承于 Enum 类。枚举类是封闭的，即不能被继承、被实现、被 mixin 混入或显式被实例化。
// 抽象类和 mixin 可以显式的实现或继承 Enum，但只有枚举可以实现或混入这个类，其他类无法享有同样的操作
enum Color { red, green, blue };

/* ------------------  明增强的枚举类型 ------------------*/
// Dart 中的枚举也支持定义字段、方法和常量构造，常量构造只能构造出已知数量的常量实例（已定义的枚举值）。
// 你可以使用与定义 类 类似的语句来定义增强的枚举，但是这样的定义有一些限制条件：
  // 实例的字段必须是 final，包括由 mixin 混入的字段。
  // 所有的 实例化构造 必须以 const 修饰。
  // 工厂构造 只能返回已知的一个枚举实例。
  // 由于 Enum 已经自动进行了继承，所以枚举类不能再继承其他类。
  // 不能重载 index、hashCode 和比较操作符 ==。
  // 不能声明 values 字段，否则它将与枚举本身的静态 values getter 冲突。
  // 在进行枚举定义时，所有的实例都需要首先进行声明，且至少要声明一个枚举实例。
// 下方是一个增强枚举的例子，它包含多个枚举实例、成员变量、getter 并且实现了接口
enum Vehicle implements Comparable<Vehicle> {
  car(tires: 4, passengers: 5, carbonPerKilometer: 400),
  bus(tires: 6, passengers: 50, carbonPerKilometer: 800),
  bicycle(tires: 2, passengers: 1, carbonPerKilometer: 0);

  final int tires;
  final int passengers;
  final int carbonPerKilometer;

  const Vehicle({required this.tires, required this.passengers, required this.carbonPerKilometer});

  int get carbonFootPrint => (carbonPerKilometer / passengers).round();

  @override
  int compareTo(Vehicle other) => carbonFootPrint - other.carbonFootPrint;
}