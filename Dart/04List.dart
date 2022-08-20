void main() {
  // 数组 (Array) 是几乎所有编程语言中最常见的集合类型，在 Dart 中数组由 List 对象表示。通常称之为 List
  // Dart 中的列表字面量是由逗号分隔的一串表达式或值并以方括号 ([]) 包裹而组成的
  var list = [1, 2, 3];
  // 这里 Dart 推断出 list 的类型为 List<int>，如果往该数组中添加一个非 int 类型的对象则会报错

  // 创建一个空数组
  var grains = <String>[];

  // 添加
  grains.add('value1');

  // 添加多个
  grains.addAll(['v2', 'v3']);

  // 长度
  const length = grains.length;

  // 获取指定位置数据
  const v1 = grains.first;
  const v2 = grains[1];

  // 移除
  grains.removeAt(1)
  const v3 = grains.indexOf('v3');  // 获取指定对象的下标
  bool mr = grains.remove(v3);

  // 清空
  grains.clear()

  // 构造方法创建list, 带填充默认数据
  List l2 = List.filled(2, 'vvv');

  // 你可以在 Dart 的集合类型的最后一个项目后添加逗号。这个尾随逗号并不会影响集合，但它能有效避免「复制粘贴」的错误
  var list2 = [
    1,
    2,
    3,
  ];

  // List 的下标索引从 0 开始，第一个元素的下标为 0，最后一个元素的下标为 list.length - 1。你可以像 JavaScript 中的用法那样获取 Dart 中 List 的长度以及元素
  print("${list2[0]} ${list2.length}");

  //  List 字面量前添加 const 关键字会创建一个编译时常量
  const list3 = [1, 2, 3];

  // Dart 在 2.3 引入了 扩展操作符（...）和 空感知扩展操作符（...?），它们提供了一种将多个元素插入集合的简洁方法。
  // 例如，你可以使用扩展操作符（...）将一个 List 中的所有元素插入到另一个 List 中
  const list4 = [0, ...list3];
  print(list4);
  // 如果扩展操作符右边可能为 null ，你可以使用 null-aware 扩展操作符（...?）来避免产生异常
  List nulllist;
  // const list5 = [0, ...?nulllist];
  // print(list5);

  // Dart 还同时引入了 集合中的 if 和 集合中的 for 操作，在构建集合时，可以使用条件判断 (if) 和循环 (for)。
  // 下面示例是使用 集合中的 if 来创建一个 List 的示例，它可能包含 3 个或 4 个元素
  var nav = ["home", "fu", "plant", if (true) ""];

  // 使用 集合中的 for 将列表中的元素修改后添加到另一个列表中
  var listOfInts = [1, 4, 3, 9, 7];
  var listOfStrings = ['#0', for (var i in listOfInts) '#$i'];
  print(listOfStrings);

  // 排序
  listOfInts.sort(((a, b) => a < b));

  // 泛型
  var fruits = <String>[];
  fruits.add('apple');
  print(fruits);
}
