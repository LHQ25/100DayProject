### 一. 枚举的声明

###### 枚举的定义

```arduino
enum SomeEnumeration {
    // 用case修饰枚举项
    case item
}
复制代码
```

声明一个方向的枚举，包含四个枚举值: 东/西/南/北.

```java
enum Direction {
    case east
    case west
    case north
    case south
}

let east = Direction.east
var head: Direction = .west
head = .north
复制代码
```

**Swift 的枚举成员在被创建时本身就是完备的值，这些值的类型是已经明确定义好的 Direction 类型. 不会像 Objective-C 一样被赋予一个默认的整型值。在上面的 Direction 例子中，east、west 、north、south不会被隐式地赋值为 0，1，2 和 3。**

###### 枚举命名和使用注意点：

- 枚举的第一个字母要大写，枚举值的第一个字母要小写；
- 枚举类型起一个单数名字而不是复数名字，从而使得它能够顾名思义；
- 一旦枚举类型确定，建议使用点语法设置值；

### 二. 枚举的特性

- Swift 中的枚举成员类型： 字符串、字符、任意的整数值或浮点类型。
- Swift 中的枚举成员可以指定任意类型的值来与不同的成员值关联储存（合集）。
- Swift 中的枚举是具有自己权限的一类类型（计算属性、实例方法、扩展等）。

### 三. 枚举值相关

##### 1. 枚举值的类型

Swift 中的枚举更加灵活，不必给每一个枚举成员提供一个值。如果给枚举成员提供一个值（称为原始值），则该值的类型可以是：字符串、字符、任意的整数值或浮点类型。

##### 2. 原始值

Swift的枚举类型提供了一个叫原始值(RawValues)的实现，它为枚举项提供了一个默认值，这个默认值在编译期间就是确定的。

- 获取原始值

```ini
let raw = Direction.west.rawValue
复制代码
```

- 通过原始值生成枚举项

```swift
let east1 = Direction.init(rawValue: "east")
print(type(of: east1))     
// Optional<Direction>
复制代码
```

通过原值值获取的枚举项是可选类型的，所以需要用if let 做一下判断。

```swift
if let east = Direction.init(rawValue: "east") {     
    print(type(of: east))     
}
// Direction
复制代码
```

##### 3.  隐式原始值和显式原始值

未指定枚举值类型

```go
enum Shape {
    case circle
    case square
    case oval
    case trilateral
}

// 不能给未指定类型的枚举成员提供值（case north = "north"❌）
error:  Enum case cannot have a raw value if the enum does not have a raw type
// 未指定类型的枚举成员无法使用rawValue属性（direction.rawValue❌）
error: Value of type 'Direction' has no member 'rawValue'
复制代码
```

隐式原始值

```arduino
enum Shape1: String {
    case circle  
    case square
    case oval
    case trilateral
}
复制代码
```

隐式原始值下枚举项使用系统的分配值：

- 如果是Sting类型，枚举值就是枚举项 `case circle` 等同于`case circle  = "circle"`
- 如果是Int类型，第一个枚举值默认是0，其他逐级+1
- 如果是CGFloat等浮点类型，第一个枚举值默认是0.0，其他逐级+1

显式原始值

```ini
enum Shape2: String {
    case circle = "圆形"
    case square = "正方形"
    case oval = "椭圆"
    case trilateral = "三角形"
}
复制代码
```

隐式 +  显式原始值

```arduino
enum Shape4: Int {
    case circle = 1   
    case square = // 默认值是2
    case oval  // 默认值是3
    case trilateral  // 默认值是4
}

enum Shape4: Int {
    case circle   // 默认值是0
    case square = 2
    case oval  // 默认值是3
    case trilateral  // 默认值是4
}
复制代码
```

##### 2. 监听枚举值

```scss
var direction = Direction.east {
    willSet {
        if newValue != direction {
            print("方向即将发生变化")
        }
    }
    
    didSet {
        if oldValue != direction {
            print("方向已经发生变化")
        }
    }
}
复制代码
```

这里使用了属性观察者，Swift里面的枚举更像一个对象，因此可以很方便的使用属性观察者对枚举值进行监听。

##### 3. 关联值类型（Associated Values）

在 Swift 中，还可以定义这样的枚举类型，它的每一个枚举项都有一个附加信息，来扩充这个枚举项的信息表示，这又叫做关联值。

```java
enum Trade {
    case buy(count: Int)
    case sell(count: Int)
}
let trade = Trade.buy(count: 10)
复制代码
```

**一定要学会使用关联值，这一点很重要。具体的使用后面的第九节会细说**

##### 4. 关联值相等判断

通常情况下枚举是很容易进行相等判断的。一旦为枚举增加了关联值，Swift就没法正确的比较了，需要自己对该枚举实现 `==`运算符。

```swift
// 一个交易的枚举
enum Trade {
    case buy(count: Int)
    case sell(count: Int)
}

// 只有枚举值并且关联值都相等才算相等。
func == (before: Trade, after: Trade) -> Bool {
   switch (before, after) {
     case let (.buy(count1), .buy(count2)) where count1 == count2:
       return true
     case let (.sell(count1), .sell(count2)) where count1 == count2:
       return true
     default:
        return false
   }
}

let trade1 = Trade.buy(count: 10)
let trade2 = Trade.sell(count: 10)
        
if trade1 == trade2 {
      print("一样的")
} else {
     print("不一样")
}
复制代码
```

##### 5. 有关联值的枚举排序/比较大小

```swift
enum SortEnum: Comparable {
    
    case a(Int)
    case b(String)
    indirect case c(SortEnum)
    
    var ordering: Int {
        switch self {
        case .a(_):
            return 0
        case .b(_):
            return 1
        case .c(_):
            return 2
        }
    }
    
    static func < (lhs: SortEnum, rhs: SortEnum) -> Bool {
        lhs.ordering < rhs.ordering
    }
    static func > (lhs: SortEnum, rhs: SortEnum) -> Bool {
        lhs.ordering > rhs.ordering
    }
}

let a = SortEnum.a(0)
let b = SortEnum.b("b")
let c = SortEnum.c(a)
let sortArr: [SortEnum] = [b, c, a]

print(sortArr.sorted())
复制代码
```

借助`Comparable `协议，来实现枚举的比较。

### 四. 枚举与 switch

```bash
switch head {
case .east:
      print("东方向")
case .north, .south, .west:
      print("非东方向")
}
复制代码
```

### 五. 枚举的遍历

```swift
enum Shape5: CaseIterable {
    case circle
    case square
    case oval
    case trilateral
}

for item in Shape5.allCases {
    print(item)
}

let count = Shape5.allCases.count
复制代码
```

遵守`CaseIterable `协议的swift枚举是可以遍历的，通过allCases获取所有的枚举成员.

### 五. 枚举的嵌套

app里面的接口地址，如果都放一起，命名或者寻找都不方便，可以用枚举的嵌套来设计。可以分散在多个文件中，方便维护和管理。

```swift
/// 总接口
enum Interface { }

extension Interface {
    // 系统相关接口
    enum System {
        case sendMessage
        case uploadImage
    }
}

extension Interface {
    // 用户相关接口
    enum User {
        case name
        case icon
        case phone
    }
}

Interface.User.login
复制代码
```

**用枚举来管理系统里面的常量是一个不错的选择。**

### 六. 枚举的(计算)属性和方法

##### 1. 计算属性

```swift
enum AppleDeivce {
    case iPad, iPhone
    
    // 不能使用存储属性
    // var deviceName: String? ❌
    // error: Enums must not contain stored properties

    var yeaer: Int {
        switch self {
        case .iPad:
            return 2010
        case .iPhone:
            return 2007
        }
    }
}
let _ = AppleDeivce.iPhone.yeaer
复制代码
```

枚举中不能使用存储属性，但是可以使用计算属性，计算属性的内容是在枚举值或者枚举关联值中得到的。

##### 2. 实例方法

```swift
enum AppleDeivce {
    case iPad, iPhone, iWatch, other
    
     func introduced() -> String {
        switch self {
        case .iPad:
            return "iPad"
        case .iPhone:
            return "iPhone"
        case .iWatch:
            return "iWatch"
        default:
            return "other"
        }
    }
}
let _ = AppleDeivce.iPhone.introduced()
复制代码
```

在这里，可以认为枚举是一个类，introduced是一个成员方法，AppleDeivce.iPhone 就是一个AppleDeivce的实例，case们是它的属性。introduced里面的switch self，其实就是遍历这个匿名属性的所有场景，如iPad，iPhone等，然后根据不同的场景返回不同的值。

##### 3. 枚举的静态方法

```swift
enum AppleDeivce {
    case iPad, iPhone
    
    static func fromSlang(slang: String) -> AppleDeivce? {
        if slang == "iPhone" {
            return .iPhone
        }
        return nil
    }
}
let _ = AppleDeivce.fromSlang(slang: "iPhone")
复制代码
```

可以做枚举的自定义构造方法。

### 七. 枚举与协议

系统的打印协议

```swift
public protocol CustomStringConvertible {
    var description: String { get }
}
复制代码
```

让枚举遵守这个协议

```swift
enum AppleDeivce: CustomStringConvertible {
    case iPad, iPhone
    
    // 实现协议属性 
    var description: String {
        switch self {
        case .iPhone:
            return "要出现款iPhone了"
        default:
            return "iPad"
        }
    }
}
let _ = AppleDeivce.iPhone.description
复制代码
```

### 八. 枚举与扩展

枚举可以进行扩展。可以将枚举中的case与method/protocol分隔开，阅读者可以快速消化枚举的内容。

```swift
enum AppleDeivce {
    case iPad, iPhone
}

extension AppleDeivce: CustomStringConvertible {
    var description: String {
        switch self {
        case .iPhone:
            return "要出现款iPhone了"
        default:
            return "iPad"
        }
    }
}

extension AppleDeivce {
    static func fromSlang(slang: String) -> AppleDeivce? {
        if slang == "iPhone" {
            return .iPhone
        }
        return nil
    }
}

extension AppleDeivce {
    func introduced() -> String {
        switch self {
        case .iPad:
            return "iPad"
        case .iPhone:
            return "iPhone"
        }
    }
}

extension AppleDeivce {
    var yeaer: Int {
        switch self {
        case .iPad:
            return 2010
        case .iPhone:
            return 2007
        }
    }
}
复制代码
```

### 九. 枚举与泛型

设计一个网络类下的错误信息的处理功能。

- 先声明一个错误信息的结构体，包含两个属性code码和错误信息

```csharp
struct ErrorMessage {
    var code : Int
    var message : String
}
复制代码
```

- 声明网络错误的枚举 该枚举接受一个泛型，用来接受关联值。

```java
enum NetworkError<T> {
    case codeError(T)
    case wrongReturn
    case networkNull
    case tokenOverdue
}
复制代码
```

- 假如在网络类有一个这样的枚举项通过闭包返回出去了

```ini
let errorMessage = ErrorMessage.init(code: 404, message: "not found")
let codeError = NetworkError.codeError(errorMessage)
复制代码
```

- 调用网络api处，对网络错误处理

```swift
switch codeError {
case .codeError(let message):
      print(message.code)
      print(message.message)
default:
       break
}
复制代码
```

### 十. 枚举与结构体

在项目中经常使用`UserDefaults`来存储一下简单的用户信息。但是对`Key`的维护不会很方便。而且会想不起来。用枚举+结构体就能很好的解决这个问题。

- 声明协议

```swift
public protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue == String {
    static public func set(value: Any, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static public func getString(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        let value = UserDefaults.standard.string(forKey: aKey)
        return value
    }
}
复制代码
```

- 给UserDefaults添加扩展

```arduino
public extension UserDefaults {

    struct Version : UserDefaultsSettable {
        public enum defaultKeys: String {
            case version
            case build
        }
    }

    struct LocationInfo: UserDefaultsSettable {
        public enum defaultKeys: String {
            case latitude
            case longitude
        }
    }
}
// 可以由大到小逐级查询，更符合认知习惯。
UserDefaults.Version.set(value: "version", forKey: .version)
let version = UserDefaults.Version.getString(forKey: .version)
复制代码
```

这么设计APP的存储模块，是不是更有层级感，更加方便使用呢？

### 十一. 递归枚举

递归枚举是拥有另一个枚举作为枚举成员关联值的枚举。当编译器操作递归枚举时必须插入间接寻址层。可以在声明枚举成员之前使用 indirect关键字来明确它是递归的。 也可以声明在整个枚举前，让所有的枚举成员都是递归的。

```swift
enum Arithmetic {
    /// 单一数字表达式
    case number(Int)
    /// 两个表达式的加法
    indirect case add(Arithmetic, Arithmetic)
    /// 两个表达式的减法
    indirect case subtract(Arithmetic, Arithmetic)
    /// 两个表达式的乘法
    indirect case multiply(Arithmetic, Arithmetic)
    /// 两个表达式的除法
    indirect case divide(Arithmetic, Arithmetic)
    
    /// 表达式的类型转换的函数
    func evaluate() -> Double {
        
        switch self {
        case .number(let value):
            return Double(value)
            
        case .add(let item1,let item2):
            return item1.evaluate() + item2.evaluate()
            
        case .subtract(let item1,let item2):
            return item1.evaluate() - item2.evaluate()
            
        case .multiply(let item1,let item2):
            return item1.evaluate() * item2.evaluate()
            
        case .divide(let item1,let item2):
            
            // 除数为0的处理
            if item2.evaluate() == 0 { return Double(Int.min) }
            return item1.evaluate() / item2.evaluate()
        }
    }
}

let two = Arithmetic.number(2)
let four = Arithmetic.number(4)
let five = Arithmetic.number(5)
let sum = Arithmetic.add(five, four)
let product = Arithmetic.multiply(sum, two)

print(two.evaluate())
print(sum.evaluate())
print(product.evaluate())

// 打印值分别为：2 9 18
复制代码
```

作者：移动端小伙伴
链接：https://juejin.cn/post/6937578808300027912
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。