void main() {
  // 通常来说，Map 是用来关联 keys 和 values 的对象。其中键和值都可以是任何类型的对象。
  // 每个 键 只能出现一次但是 值 可以重复出现多次。 Dart 中 Map 提供了 Map 字面量以及 Map 类型两种形式的 Map
  var gifts = {
    // Key:    Value
    'first': 'partridge',
    'second': 'turtledoves',
    'fifth': 'golden rings'
  };

  var nobleGases = {
    2: 'helium',
    10: 'neon',
    18: 'argon',
  };
  // Dart 将 gifts 变量的类型推断为 Map<String, String>，而将 nobleGases 的类型推断为 Map<int, String>。
  // 如果你向这两个 Map 对象中添加不正确的类型值，将导致运行时异常

  // 使用 Map 的构造器创建 Map
  var gifts = Map<String, String>();
  gifts['k1'] = 'v1';
  gifts['k2'] = 'v2';

  var oble = Map<Int, String>();
  oble[1] = 'v1';
  oble[3] = 'v3';

  // 获取
  const v3 = oble[3];

  // 添加 or 修改
  oble[3] = 'vvv3';

  // 获取的值不存在 返回null
  const e = oble[2];

  // 键值对的长度
  const l = oble.length;

  // 在一个 Map 字面量前添加 const 关键字可以创建一个 Map 编译时常量
  final constantMap = const {
    2: 'helium',
    10: 'neon',
    18: 'argon',
  };

  // Map 可以像 List 一样支持使用扩展操作符（... 和 ...?）以及集合的 if 和 for 操作
}
