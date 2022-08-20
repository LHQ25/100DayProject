void main() {
  // 在 Dart 中，set 是一组特定元素的无序集合。 Dart 支持的集合由集合的字面量和 Set 类提供
  // 尽管 Set 类型(type) 一直都是 Dart 的一项核心功能，但是 Set 字面量(literals) 是在 Dart 2.2 中才加入的
  var halogens = {'florine', 'chlorine', 'bnromine', 'idoline'};
  // Dart 推断 halogens 变量是一个 Set<String> 类型的集合，如果往该 Set 中添加类型不正确的对象则会报错

  // 可以使用在 {} 前加上类型参数的方式创建一个空的 Set，或者将 {} 赋值给一个 Set 类型的变量
  var names = <String>{};
  Set<String> names2 = {};
  // Set 还是 map? Map 字面量语法相似于 Set 字面量语法。因为先有的 Map 字面量语法，所以 {} 默认是 Map 类型。
  // 如果忘记在 {} 上注释类型或赋值到一个未声明类型的变量上，那么 Dart 会创建一个类型为 Map<dynamic, dynamic> 的对象

  // 添加
  names.add('lisi');
  // 添加集合类型
  names.addAll(halogens);

  // 长度
  const lenght = names.length;

  // 在 Set 变量前添加 const 关键字创建一个 Set 编译时常量
  final constantSet = const {
    'fluorine',
    'chlorine',
    'bromine',
    'iodine',
    'astatine',
  };

  // Set 可以像 List 一样支持使用扩展操作符（... 和 ...?）以及 Collection if 和 for 操作
}
