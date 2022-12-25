> ### 面向协议编程
>
> 你可能听过类似的概念：**面向对象编程**、**函数式编程**、**泛型编程**，再加上苹果新提出的**面向协议编程**，这些统统可以理解为是一种编程范式。所谓编程范式，是隐藏在编程语言背后的思想，代表着语言的作者想要用怎样的方式去解决怎样的问题。
>
> 不同的编程范式反应在现实世界中，就是不同的编程语言适用于不同的领域和环境，比如在面向对象编程思想中，开发者用对象来描述万事万物并试图用对象来解决所有可能的问题。编程范式都有其各自的偏好和使用限制，所以越来越多的现代编程语言开始支持**多范式**，使语言自身更强壮也更具适用性。
>
> 面向协议编程是在面向对象编程基础上演变而来，将程序设计过程中遇到的数据类型的抽取（抽象）由使用**基类**进行抽取改为使用**协议**进行抽取。更简单点举个例子来说，一个猫类、一个狗类，我们很容易想到抽取一个描述动物的基类，这就是面向对象编程。当然也会有人想到抽取一个动物通用的协议，这就是面向协议编程了。
>
> 而在Swift语言中，协议被赋予了更多的功能和更广阔的使用空间，为协议增加了扩展功能，使其能够胜任绝大多数情况下数据类型的抽象，所以苹果开始声称Swift是一门支持面向协议编程的语言。

## 协议基础

> 官方文档的定义：
>
> 协议为方法、属性、以及其他特定的任务需求或功能定义蓝图。协议可被类、结构体、或枚举类型采纳以提供所需功能的具体实现。满足了协议中需求的任意类型都叫做遵循了该协议。

### 协议的定义

```swift
protocol Food { }
复制代码
```

用关键词 **protocol** ，声明一个名为 Food 的协议。

### 定义协议属性

```dart
protocol Pet {
    var name: String { get set }
    var master: String { get }
    static var species: String { get }
}
复制代码
```

协议中定义属性表示遵循该协议的类型具备了某种属性。

- 只能使用 `var` 关键字声明；
- 需要明确规定该属性是可读的 `{get}` 、 还是可读可写的 `{get set}` ；
- 为了保证通用，协议中必须用static定义类型方法、类型属性、类型下标，因为class只能用在类中，不能用于结构体等；
- 属性不能赋初始值；

```javascript
struct Dog: Pet {
    var name: String
    var master: String
    static var species: String = "哺乳动物"
    
    var color: UIColor? = nil
}

var dog = Dog(name: "旺财", master: "小明")
dog.master = "张三" // 更改了主人
复制代码
```

定义一个继承协议的结构体 **Dog** ，并新增了一个color属性。

- static 修饰的类属性必须有初始值或实现了 `get set` 方法（`'static var' declaration requires an initializer expression or getter/setter specifier`）

- set 为什么不报错？

  ```ini
  if dog.master == "小明" {
      dog.master = "张三"
  }
  复制代码
  ```

  **master** 属性在协议中被定义为只读属性 **get**，为什么上面的代码还可以 **set** ？

  **协议中的“只读”属性修饰的是协议这种“类型”的实例**。

  ```ini
  let pet: Pet = dog
  pet.master = "李四"
  复制代码
  ```

  虽然我们并不能像创建类的实例那样直接创建协议的实例，但是我们可以通过“赋值”得到一个协议的实例。此时 就会报错 `Cannot assign to property: 'master' is a get-only property`。

  **Dog** 中新增的 **Pet** 中没有的属性 `var color: UIColor? = nil` ，将不会出现在 **pet** 中。

### 定义协议方法

Swift中的协议可以定义类方法或实例方法，在遵守该协议的类型中，具体的实现方法的细节，通过类或实例调用。

```swift
protocol Pet {
    var name: String { get set }
    var master: String { get }
    static var species: String { get }
    
    // 新增的协议方法
    static func sleep()
    mutating func changeName()
}

struct Dog: Pet {
    var name: String
    var master: String
    static var species: String = "哺乳动物"
    var color: UIColor? = nil
    
    static func sleep() {
        print("要休息了")
    }
    mutating func changeName() {
        name = "大黄"
    }
}
复制代码
```

- 声明的协议方法的参数不能有默认值

  ```swift
  ❌ func changeName(name: String = "大黄") // Swift认为默认值也是一种变相的实现
  复制代码
  ```

- 结构体中的方法修改属性时，需要在方法前面加上关键字**mutating** ，表示该属性属性能被修改。这样的方法叫 **异变方法** 。

### 协议中的初始化器

每一个宠物在被领养的时候，主人就已经确定了：

```swift
// 在上面的代码中新增
protocol Pet {    
    init(master: String)
}

struct Dog: Pet {
    required init(master: String) {
        self.master = master
    }
}
复制代码
```

此时会报错 **在不初始化所有存储属性的情况下从初始化器中返回所有属性**。 ( `Return from initializer without initializing all stored properties` )。加上 `self.name = ""` 就可以了。

```swift
class Cat: Pet {
    required init(master: String) {
        self.master = master
        self.name = ""
    }
}
复制代码
```

**Cat类** 遵守了该协议，初始化器必须用 **required** 关键字修饰初始化器的具体实现。

### 继承与遵守协议

```kotlin
class SomeClass: NSObject, OneProtocol, TwoProtocol { }
复制代码
```

因为Swift中类的继承是单一的，但是类可以遵守多个协议，因此为了突出其单一父类的特殊性，应该 **将继承的父类放在最前面，将遵守的协议依次放在后面。**

### 多个协议方法名冲突

```csharp
protocol ProtocolOne {
    func method() -> Int
}
protocol ProtocolTwo {
    func method() -> String
}

struct PersonStruct: ProtocolOne, ProtocolTwo {
    func method() -> Int {
        return 1
    }
    func method() -> String {
        return "Hello World"
    }
}

let ps = PersonStruct()
//尝试调用返回值为Int的方法
let num = ps.method() ❌
//尝试调用返回值为String的方法
let string = ps.method() ❌

let num = (ps as ProtocolOne).method() ✅
let string = (ps as ProtocolTwo).method() ✅
复制代码
```

编译器无法知道同名` method()` 方法到底是哪个协议中的方法，因此需要指定调用特定协议的` method()` 方法 。

### 协议方法的可选实现

- 方法一：通过 **optional** 实现可选

  ```swift
  @objc protocol OptionalProtocol {
      @objc optional func optionalMethod()
      func requiredMethod()
  }
  复制代码
  ```

- 方法二： 通过 **extension** 做默认处理

  ```swift
  protocol OptionalProtocol {
      func optionalMethod()
      func requiredMethod()
  }
  
  extension OptionalProtocol {
      func optionalMethod() {
          
      }
  }
  复制代码
  ```

### 协议的继承、聚合

#### 协议的继承

> 协议可以继承一个或者多个其他协议并且可以在它继承的基础之上添加更多要求。协议继承的语法与类继承的语法相似，选择列出多个继承的协议，使用逗号分隔。

```swift
protocol OneProtocol { }
protocol TwoProtocol { }
protocol ThreeProtocol: OneProtocol, TwoProtocol { }
复制代码
```

产生了一个 **新协议** ，该协议拥有  `OneProtocol` 和  `TwoProtocol` 的方法或属性。需要实现 `OneProtocol` 和  `TwoProtocol`必须的方法或属性。

#### 协议的聚合

> 使用形如`OneProtocol & TwoProtocol`的形式**实现协议聚合（组合）复合多个协议到一个要求里** 。

```ini
protocol OneProtocol { }
protocol TwoProtocol { }
typealias FourProtocol = OneProtocol & TwoProtocol
复制代码
```

聚合出来的不是新的协议，只是一个代指，代指这些协议的集合。

#### 协议的继承和聚合的区别

首先**协议的继承是定义了一个全新的协议，\**我们是希望它能够“大展拳脚”得到普遍使用。而\**协议的聚合**不一样，它并没有定义新的固定协议类型，相反，它只是定义一个临时的拥有所有聚合中协议要求组成的局部协议，很可能是“一次性需求”，使用**协议的聚合**保证了代码的简洁性、易读性，同时去除了定义不必要的新类型的繁琐，并且定义和使用的地方如此接近，见明知意，也被称为**匿名协议聚合**。但是使用了**匿名协议聚合**能够表达的信息就少了一些，所以需要开发者斟酌使用。

### 协议的检查

```python
if pig is Pet {
    print("遵守了 Pet 协议")
}
复制代码
```

检查pig 是否是遵守了 Pet 协议类型的实例。

### 协议的指定

```arduino
protocol ClassProtocol: class { }

struct Test: ClassProtocol { } // 报错
复制代码
```

使用关键字 **class** 使定义的协议只能被类遵守。如果有枚举或结构体尝试遵守会报错 `Non-class type 'Test' cannot conform to class protocol 'ClassProtocol'` 。

### 协议作为参数

```swift
func update(param: FourProtocol) { }
复制代码
```

将协议作为参数，表明遵守了该协议的实例可作为参数。

### 协议的关联类型

> 协议的关联类型指的是根据使用场景的变化，如果协议中某些属性存在 **逻辑相同的而类型不同** 的情况，可以使用关键字**associatedtype**来为这些属性的类型声明“关联类型”。

```swift
protocol LengthMeasurable {
    associatedtype LengthType
    var length: LengthType { get }
    func printMethod()
}

struct Pencil: LengthMeasurable {
    typealias LengthType = CGFloat
    var length: CGFloat
    func printMethod() {
        print("铅笔的长度为 \(length) 厘米")
    }
}

struct Bridge: LengthMeasurable {
    typealias LengthType = Int
    var length: Int
    func printMethod() {
        print("桥梁的的长度为 \(length) 米")
    }
}
复制代码
```

**LengthMeasurable** 协议中用 associatedtype 定义了一个 **类型泛型** 。在实现协议的时候，定义具体的类型。这样就可以适配各种物体长度的测量。

##### associatedtype &  typealias的区别

- **associatedtype**： 在定义协议时，可以用来声明一个或多个类型作为协议定义的一部分，叫关联类型。这种关联类型为协议中的某个类型提供了自定义名字，其代表的实际类型或实际意义在协议被实现时才会被指定。
- **typealias**： 是给 **现有**  的类型(包括系统和自定义的)进行重新命名，然后就可以用该别名来代替原来的类型，已达到改善程序可读性，而且可以自实际编程中根据业务来重新命名，可以表达实际意义。

### 协议的扩展

设想一个这样的场景： 有一个人参加比赛，三个评委打分。比赛结束，求这个人的平均分。

```swift
protocol Score {
    var name: String { get set }
    var firstJudge: CGFloat { get set }
    var secondJudge: CGFloat { get set }
    var thirdJudge: CGFloat { get set }
    
    func averageScore() -> String
}

struct Xiaoming: Score {
    var firstJudge: CGFloat
    var secondJudge: CGFloat
    var thirdJudge: CGFloat
    
    func averageScore() -> String {
        let average = (firstJudge + secondJudge + thirdJudge) / 3
        return "\(name)的得分为\(average)"
    }
}
let xiaoming = Xiaoming(name: "小明", firstJudge: 80, secondJudge: 90, thirdJudge: 100)
let average = xiaoming.averageScore()
复制代码
```

这场比赛，如果有10个人参加，计算平均值的方法，就需要写10次。代码重复严重。可以通过 **协议的扩展解决问题** 。

```swift
extension Score {
    func averageScore() -> String {
        let average = (firstJudge + secondJudge + thirdJudge) / 3
        return "\(name)的得分为\(average)"
    }
}
复制代码
```

`averageScore` 默认进行了实现，不需要遵守者必须实现了。

这个时候，比赛承办方想统计每个人的最高分，应该怎么办呢？

```swift
extension Score {
    func maxScore() -> CGFloat {
        return max(firstJudge, secondJudge, thirdJudge)
    }
}
let maxScore = xiaoming.maxScore()
复制代码
```

比赛承办方对比赛结果的输出不太满意。想把 `小明的得分为90.0` 前面统一加上前缀。

```dart
// 对系统协议进行扩展
extension CustomStringConvertible {
    var customDescription: String {
        return "新希望学校春季运动会运动会得分为：：" + description
    }
}
print(xiaoming.averageScore().customDescription)
复制代码
```

总结：

- 通过协议的扩展提供协议中某些属性和方法的默认实现。
- 将公共的代码和属性统一起来极大的增加了代码的复用。
- 为系统/自定义的协议提供的扩展。

## Swift的55标准库协议

### Swift的55标准库协议可以分为三类

| 类型             | 描述                                                         | 标志                     |
| ---------------- | ------------------------------------------------------------ | ------------------------ |
| **”Can do“协议** | （表示能力）描述的事情是类型可以做或已经做过的。             | 以 **-able** 结尾        |
| **"Is a"协议**   | （表示身份）描述类型是什么样的，与"Can do"的协议相比，这些更基于身份，表示身份的类型。 | 以 **-type** 结尾        |
| **"Can be"协议** | （表示转换）这个类型可以被转换到或者转换成别的东西。         | 以 **-Convertible** 结尾 |

### 如何更好的命名协议？

在自定义协议时应该尽可能遵守苹果的命名规则，便于开发人员之间的高效合作。

### 55个标准的Swift协议

[55个标准Swift协议地址（待完成）](https://link.juejin.cn?target=)

## 协议编程的优势

### 面向对象（继承）

有这样一个需求，在某个页面中，显示的Logo图片需要切圆角处理，让它更美观一些。

```ini
logoImageView.layer.cornerRadius = 5
logoImageView.layer.masksToBounds = true
复制代码
```

如果要求，整个APP中所有的Logo都要切圆角处理。最容易的解决办法是定义一个名为`LogoImageView`的类，使用该类初始化Logo对象。

```swift
class LogoImageView: UIImageView {
    init(radius: CGFloat = 5) {
        super.init(frame: CGRect.zero)
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
复制代码
```

如果要求所有的Logo还要支持点击抖动效果。

```swift
class LogoImageView: UIImageView {
    
    init(radius: CGFloat = 5) {
        super.init(frame: CGRect.zero)
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(shakeEvent))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogoImageView {
    @objc func shakeEvent() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform"
        animation.duration = 0.25
        
        let origin = CATransform3DIdentity
        let minimum = CATransform3DMakeScale(0.8, 0.8, 1)
        
        let originValue = NSValue(caTransform3D: origin)
        let minimumValue = NSValue(caTransform3D:minimum)
        
        animation.values = [originValue, minimumValue, origin, minimumValue, origin]
        layer.add(animation, forKey: "bounce")
        layer.transform = origin
    }
}
复制代码
```

这个时候，如果其他的功能也要使用抖动动画，就不得不接受切圆角功能。即使把切圆角功能从初始化方法中剥离成一个可选方法，但是也不得不接受这份耦合代码。

有的项目里定义了继承 `UIViewController` 的父类，实现了很多功能，项目里页面都要继承它。而且往这个自定义`UIViewController`里塞代码实在太方便了，这个类很容易随着功能迭代逐渐膨胀，变的僵化，越来越难以维护。下面的子类代码全都依赖这个父类，想抽出来复用非常难。

项目里混合使用了原生功能和H5功能。定义的H5容器的父类`WebViewController`，需要满足以下业务要求：

- 有的H5页面比较简单，只需要正常展示网页即可。
- 有的需要JS代码注入。
- 有的需要提供保存图片到相册给H5使用。
- 有的需要提供存跳转原始页面给H5使用。

这个父类中处理了**`WKWebView`实现、 JS注入、桥的定义以及桥功能的实现**等众多能力。导致`WebViewController`代码量多达几千行。很难维护扩展。

> 采用 **继承** 方式解决复用的问题，很容易带来代码的耦合。

假如 UILabel 也需要抖动的动画，采用继承无法实现。UIImageView 和 UILabel 已经是 UIView的子类，除非改动UIView，否则无法通过继承的方式实现。

### 面向对象（扩展）

通过扩展，可以不修改类的实现文件的情况下，给类增加新的方法。可以通过给 UIView 添加扩展来解决 UIImageView 和 UILabel 同时增加抖动功能的需求。缺点是给一个类加上这个东西就污染了该类所有的对象。（UIButton说： 我不需要为什么塞给我？）

### 面向对象（工具类）

当然，我们可以直接写一个工具类来实现这个抖动的效果，然后把必要的参数（layer）传递过来。缺点就是，使用起来相对麻烦，众多的工具类难易管理。（你有因为不知道该使用哪个工具类头疼过么？ 有因为要把方法放哪个工具类头疼过么？有因为工具类代码量过多头疼过么？）

### 面向协议

通过协议重新实现 切圆角功能和抖动动画功能。

```swift
/// 声明一个圆角的能力协议
protocol RoundCornerable {
    func roundCorner(radius: CGFloat)
}

/// 通过扩展给这个协议方法添加默认实现，必须满足遵守这个协议的类是继承UIView的。
extension RoundCornerable where Self: UIView {
    func roundCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}

/// 声明抖动动画的协议
protocol Shakeable {
    func startShake()
}
/// 实现协议方法内容，并指定只有LogoImageView才可以使用。
extension Shakeable where Self: LogoImageView {
    func startShake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform"
        animation.duration = 0.25
        
        let origin = CATransform3DIdentity
        let minimum = CATransform3DMakeScale(0.8, 0.8, 1)
        
        let originValue = NSValue(caTransform3D: origin)
        let minimumValue = NSValue(caTransform3D:minimum)
        
        animation.values = [originValue, minimumValue, origin, minimumValue, origin]
        layer.add(animation, forKey: "bounce")
        layer.transform = origin
    }
}

/// 遵守了RoundCornerable协议，才拥有切圆角的功能。遵守了Shakeable协议，才拥有抖动动画效果。
class LogoImageView: UIImageView, RoundCornerable, Shakeable {
    init(radius: CGFloat = 5) {
        super.init(frame: CGRect.zero)
        
        roundCorner(radius: radius)
        
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(shakeEvent))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func shakeEvent() {
        startShake()
    }
}
复制代码
```

### 泛型及泛型约束

有时候会有一些场景声明的协议只给部分对象使用。

```rust
/// 该协议只运行LogoImageView以及其子类使用
extension Shakeable where Self: LogoImageView { } 
复制代码
```

## 协议解决面向对象中棘手的超类问题

> 该模块引用于：[Swift标准库中常见的协议](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fdaiqiao_ios%2Farticle%2Fdetails%2F79581729)。 由于示例过于优秀，故直接引用。

![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bb3656ef41f14cd58bd10d72eacacac0~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp)

`麻雀`作为一种鸟类，应该继承`鸟`，但是如果继承了`鸟`，就相当于默认了`麻雀`是一种`宠物`，这显然是不和逻辑的。`麻雀`在图中的位置就显得比较尴尬。解决此问题的一般方法如下

![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b59c9072210c4de5a586126ce20d86a6~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp)

乍一看好像解决了这样的问题，但是仔细想由于Swift只支持单继承，`麻雀`没有继承`鸟`类就无法体现`麻雀`作为一种鸟拥有的特性（比如飞翔）。如果此时出现一个新的`飞机`类，虽然`飞机`和`宠物`之间没有任何联系，但是`飞机`和`鸟`是由很多共同特性的（比如飞翔），这样的特性该如何体现呢？答案还是新建一个类成为`动物`和`飞机`的父类。

面向对象就是这样一层一层的向上新建父类最终得到一个“超级父类”`NSObject`。尽管问题得到了解决，但是`麻雀`与`鸟`、`飞机`与`鸟`之间的共性并没有得到很好的体现。而协议的出现正是为了解决这类问题。

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/65d3a008b7e24dd485b318faa3eef216~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp)

实际上图中包括`动物`、`鸟`、`飞机`等类之间的关系就应该是如上图所示的继承关系。使用协议将“宠物”、“飞翔”等看作是一种特性，或者是从另一个维度描述这种类别，更重要的是使用协议并不会打破原有类别之间继承的父子关系。

和飞翔相关的代码统一放在`Flyable`中，需要“飞翔”这种能力就遵守该协议；和宠物相关的代码统一放在`PetType`中，需要成为宠物就遵守该协议。这些

协议灵活多变，结合原有的面向对象类之间固有的继承关系，完美的描述了这个世界。

## 文献

[SwiftDoc.org](https://link.juejin.cn?target=https%3A%2F%2Fswiftdoc.org%2Fv5.1%2F)

[Swift标准库中常见的协议](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fdaiqiao_ios%2Farticle%2Fdetails%2F79581729)

[Swift Summit - What the 55 Swift Standard Library Protocols Taught Me (需要VPN)](https://link.juejin.cn?target=https%3A%2F%2Fwww.skilled.io%2Fu%2Fgregheo%2Fwhat-the-55-swift-standard-library-protocols-taught-me)



作者：移动端小伙伴
链接：https://juejin.cn/post/6932789715749830669
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。