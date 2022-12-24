操作符(Operator)是 Combine 生态的重要组成部分，使我们以有意义的方式操作上游 Publisher 发出的值。我们将了解 Combine 的大多数 Operator：转换(Transforming)、过滤(Filtering)、组合(Combining)、时间操作(Time Manipulation)和序列(Sequence)。

## 转换操作符(Transforming Operators)

Combine 的每个 Operator 都返回一个 Publisher。 一般来说，Publisher 接收上游事件，对其进行某些操作，将操作后的事件向下游发送给消费者。

### 收集值

#### `collect()`

```swift
func collect() -> Publishers.Collect<Self>
func collect(_ count: Int) -> Publishers.CollectByCount<Self>
复制代码
```

一个 Publisher 可以发出单个值或值的集合。`collect()`  Operator 是将来自 Publisher 的单值流转换为单个数组的方法。以下弹珠图图描述了 `collect()` 缓冲单值流，直到上游的 Publisher 完成，然后它向下游发出该数组：

![collect.png](http://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dcddd198559c4c4eb85fb6399956f272~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

新建 Playground 并添加以下代码：

```swift
import Combine
import Foundation

func example(_ desc: String, _ action:() -> Void) {
    print("--- \(desc) ---")
    action()
}

var subscriptions = Set<AnyCancellable>()

example("Collect") {
    ["A", "B", "C", "D", "E"]
        .publisher
        .sink { print($0) } 
            receiveValue: { print($0) }
        .store(in: &subscriptions)
}
复制代码
```

运行 Playground，我们会看到每个值都出现在单独的行上，最后跟着一个完成事件：

```css
--- Collect ---
A
B
C
D
E
finished
复制代码
```

现在在调用 `sink` 之前使用 `collect()`:

```swift
example("Collect") {
    ["A", "B", "C", "D", "E"]
        .publisher
        .collect()
        .sink { print($0) } 
            receiveValue: { print($0) }
        .store(in: &subscriptions)
}
复制代码
```

再次运行 Playground，我们将看到接收到单个数组值，然后是完成事件：

```css
--- Collect ---
["A", "B", "C", "D", "E"]
finished
复制代码
```

但在使用 `collect()` 和其他不需要指定 count 这类 Operator 时要小心，，因为它们不会在上游完成之前发出值，所以它们可能将使用大量内存来存储接收到的值。

`collect()`  Operator 有一些变体。例如我们可以指定收集一定数量的值，将上游切割成多个“批次”。我们可以将上述实例代码中的 `.collect()` 替换为：

```swift
.collect(2)
复制代码
```

再次运行 Playground，我们将看到以下输出：

```css
--- Collect ---
["A", "B"]
["C", "D"]
["E"]
finished
复制代码
```

因为上游 Publisher 在 `collect()` 填满其缓冲区之前就完成了，所以它将剩余的内容作为一个数组发送，即值 E 也作为一个数组。

### 映射值

#### `map(_:)`

```swift
func map<T>(_ transform: @escaping (Self.Output) -> T) -> Publishers.Map<Self, T>
复制代码
```

我们通常希望以某种方式转换值。` map` 的工作方式与 Swift 的标准 `map` 类似。在弹珠图中，我们将每个值乘以 2，此 Operator 在上游发布值后立即发布值：

![map.png](http://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/72f3fcac8cd442e398dbd4304cbe5056~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将这个新示例添加到我们的 Playground：

```swift
example("map") { 
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    [9, 99, 999, 9999].publisher
        .map { 
            formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
        }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

在这里，我们创建一个 `formatter` 来拼出每个数字。创建 `Int` Publisher 后，使用 `map`，闭包中获取上游值并返回字符串。运行 Playground，我们将看到以下输出：

```arduino
--- map ---
九
九十九
九百九十九
九千九百九十九
复制代码
```

`map` Operator 的 keyPath 有三个，它们可以使用 keyPath 映射到值的一个、两个或三个属性。 他们的签名如下：

```swift
func map<T>(
  _ keyPath: KeyPath<Self.Output, T>
) -> Publishers.MapKeyPath<Self, T>

func map<T0, T1>(
    _ keyPath0: KeyPath<Self.Output, T0>,
    _ keyPath1: KeyPath<Self.Output, T1>
) -> Publishers.MapKeyPath2<Self, T0, T1>

func map<T0, T1, T2>(
    _ keyPath0: KeyPath<Self.Output, T0>,
    _ keyPath1: KeyPath<Self.Output, T1>,
    _ keyPath2: KeyPath<Self.Output, T2>
) -> Publishers.MapKeyPath3<Self, T0, T1, T2>
复制代码
```

将以下示例添加到 Playground：

```swift
example("map & keyPath") { 
    struct Persion {
        var name: String
        var height: Float
        var weight: Float
    }
    let publisher = PassthroughSubject<Persion, Never>()
    publisher
        .map(\.name, \.height, \.weight)
        .map { "\($0)'s height is \($1) cm and weight is \($2) kg." }
        .sink { print($0) }
        .store(in: &subscriptions)
    publisher.send(.init(name: "A", height: 180, weight: 80))
    publisher.send(.init(name: "B", height: 170, weight: 60))
}
复制代码
```

我们定义了 `Persion` 结构，并订阅 `publisher`，将相关字段转换 `String` 并输出。运行 Playground，输出将如下所示：

```css
--- map & keyPath ---
A's height is 180.0 cm and weight is 80.0 kg.
B's height is 170.0 cm and weight is 60.0 kg.
复制代码
```

#### `tryMap(_:)`

```swift
func mapError<E>(_ transform: @escaping (Self.Failure) -> E) -> Publishers.MapError<Self, E> where E : Error
复制代码
```

包括 `map` 在内的几个 Operator 都有一个带有 try 前缀的方法，该前缀的方法接受一个可抛出错误的闭包。方法中抛出的错误，将在下游被接收：

```swift
example("tryMap") {
    Just("Path")
        .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
        .sink { print($0) } 
            receiveValue: { print($0) }
        .store(in: &subscriptions)
}
复制代码
```

我们创建了一个 `String` Publisher，使用 tryMap 尝试获取文件内容，接收并打印出完成事件或值。运行 Playground，我们将看到错误事件：

```objectivec
--- tryMap ---
failure(Error Domain=NSCocoaErrorDomain Code=260 "文件夹“Path”不存在。" UserInfo={NSFilePath=Path, NSUserStringVariant=(
    Folder
), NSUnderlyingError=0x15aec8790 {Error Domain=NSOSStatusErrorDomain Code=-43 "fnfErr: File not found"}})
复制代码
```

### 扁平化 Publisher

#### `flatMap(maxPublishers:_:)`

```swift
func flatMap<T, P>(
    maxPublishers: Subscribers.Demand = .unlimited,
    _ transform: @escaping (Self.Output) -> P
) -> Publishers.FlatMap<P, Self> where T == P.Output, P : Publisher, Self.Failure == P.Failure
复制代码
```

`flatMap` Operator 将多个上游 Publisher 展平为一个下游 Publisher。`flatMap` 返回的 Publisher 与接收的上游 Publisher 通常是不同的。在 Combine 中 `flatMap` 的一个常见用例，是当我们想要将一个 Publisher 发出的元素，传递给一个返回 Publisher 的方法，并最终订阅第二个 Publisher 发出的元素。在 Playground 中添加新代码：

```swift
example("flatMap") {    
    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
        .publisher
        .collect()
        .flatMap { codes in
            Just(codes.map { String(UnicodeScalar($0)) }.joined())
        }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们将 ASCII 编码的 `Int` 数组转换为 `publisher`，将这些值 `collect `为一个 `Int` 数组。使用 `flatMap` 转换为一个 `Just` Publisher，该 Publisher 将 `Int` 数组转变为一个 `String` 类型的值。接着订阅 `Just` Publisher，打印该值。最终输出如下：

```diff
--- flatMap ---
Hello, World!
复制代码
```

上面的示例中，我们使用了方法的第二个入参，提供了一个 `transform` 闭包，还有一个 `maxPublishers` 参数。

`flatMap` 将所有接收到的 Publisher 的输出扁平化为一个 Publisher，因为它会缓冲多个 Publisher，来更新它在下游发出的单个 Publisher，这可能会引起内存问题。而 `maxPublishers` 为我们做了限制：

![flatMap.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eacc44b8bb3d442eb48242d9a913d241~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

在图中，`flatMap` 接收三个发布者：p0、p1 和 p2。 `flatMap` 从 p1 和 p2 发出值，但忽略 p3，因为 `maxPublishers` 设置为 2。上述逻辑用代码描述为：

```swift
example("flatMap & maxPublishers") {    
    let publisher = PassthroughSubject<AnyPublisher<String, Never>, Never>()
    publisher
        .flatMap(maxPublishers: .max(2)) { $0 }
        .sink { print($0) } 
            receiveValue: { print($0) }
        .store(in: &subscriptions)
    
    let p0 = CurrentValueSubject<String, Never>("p0 - 0")
    let p1 = CurrentValueSubject<String, Never>("p1 - 0")
    let p2 = CurrentValueSubject<String, Never>("p2 - 0")
    
    publisher.send(p0.eraseToAnyPublisher())
    publisher.send(p1.eraseToAnyPublisher())
    publisher.send(p2.eraseToAnyPublisher())
    
    p0.send("p0 - 1")
    p1.send("p1 - 1")
    p2.send("p2 - 1")
    p0.send("p0 - 2")
    p1.send("p1 - 2")
    p2.send("p2 - 2")
}
复制代码
```

添加到 Playground 并运行，控制台将输出：

```diff
--- flatMap & maxPublishers ---
p0 - 0
p1 - 0
p0 - 1
p1 - 1
p0 - 2
p1 - 2
复制代码
```

### 替换和插入值

#### `replaceNil(with:)`

```swift
func replaceNil<T>(with output: T) -> Publishers.Sequence<[Publishers.Sequence<Elements, Failure>.Output], Failure> where Elements.Element == T?
复制代码
```

当我们希望始终提供非 Nil 值时可以使用该 Operator。如下图所示，`replaceNil` 接收可选值并将 `nil`  值替换为我们指定的值：

![replaceNil.png](http://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d20872e6f34b44e4ae35fdfbb2c6946b~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到 Playground：

```swift
example("replaceNil") {
    [Optional(1), nil, Optional(3)].publisher
        .eraseToAnyPublisher()
        .replaceNil(with: 2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们从可选 `Int` 数组创建 Publisher。使用 `replaceNil(with:)` 将来自上游发布者的 nil 值替换为 2：

```diff
--- replaceNil ---
1
2
3
复制代码
```

> [上述代码使用 `eraseToAnyPublisher()` 调整了编译器的类型推断，否则 `Optional` 不会被展开。](https://link.juejin.cn?target=https%3A%2F%2Fforums.swift.org%2Ft%2Funexpected-behavior-of-replacenil-with%2F40800)

#### `replaceEmpty(with:)`

```swift
func replaceNil<T>(with output: T) -> Publishers.Map<Self, T> where Self.Output == T?
复制代码
```

如果 Publisher 完成了但没有发出一个值，我们可以使用 `replaceEmpty(with:)` Operator 来插入一个值。在下面的弹珠图中，Publisher 完成时没有发出任何内容，此时 `replaceEmpty(with:)` 操作符插入一个值并将其发布到下游：

![replaceEmpty.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d0f6e97cd4ce44cba31cfd135cf194f6~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

在 Playground 中添加这个新示例以查看它的实际效果：

```swift
example("replaceEmpty") {
    let empty = Empty<Int, Never>()
    empty
        .replaceEmpty(with: 1)
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们创使用 `Empty` Publisher 立即发出 `.finished` 事件。而 `.replaceEmpty(with: 1)` 将会在完成事件发生时，插入值 1：

```diff
--- replaceEmpty ---
1
finished
复制代码
```

### 值的增量输出

#### `scan(_:_:)`

```swift
func scan<T>(
    _ initialResult: T,
    _ nextPartialResult: @escaping (T, Self.Output) -> T
) -> Publishers.Scan<Self, T>
复制代码
```

`scan` 将上次闭包返回的值，和上游 Publisher 发出的最新值提供给闭包。在下面的弹珠图中，`scan` 从 0 开始，当它从 Publisher 接收每个值时，它将其加到先前存储的值中，然后发出结果：

![scan.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f19b9038b9d24595a1763d6da7c46567~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

上述图用代码描述为：

```swift
example("scan") {
    [1, 2, 3]
        .publisher
        .scan(0) { latest, current in
            latest + current
        }
        .sink(receiveValue: { print($0)})
        .store(in: &subscriptions)
}
复制代码
```

运行 Playground 将输出：

```diff
--- scan ---
1
3
6
复制代码
```

## 过滤操作符(Filtering Operators)

当我们想要限制 Publisher 发出的值或事件，只使用其中需要的一部分时，可以使用使用一组特殊的 Operator 来做到这一点：过滤操作符。

### 过滤值

#### `filter(_:)`

```swift
func filter(_ isIncluded: @escaping (Self.Output) -> Bool) -> Publishers.Filter<Self>
复制代码
```

我们将了解基础过滤——消费 Publisher 的值，并有条件地决定将其中的哪些传递给下游的消费者。`filter` 采用返回 Bool 的闭包，只传递与条件匹配的值：

![filter.png](http://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/afb0c536fa4749c3bac28e636d4ad471~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将这个新示例添加到 Playground：

```swift
example("filter") {
    (1...10)
        .publisher
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { print("\($0) is a multiple of 3!")})
        .store(in: &subscriptions)
}
复制代码
```

在上面的示例中，我们创建一个新的 Publisher，它将发出从 1 到 10。使用 `filter`，只允许通过是三的倍数的数字：

```css
--- filter ---
3 is a multiple of 3!
6 is a multiple of 3!
9 is a multiple of 3!
复制代码
```

#### `removeDuplicates()`

```swift
func removeDuplicates() -> Publishers.RemoveDuplicates<Self>
复制代码
```

很多时候我们可能会遇到 Publisher 发出相同的值，我们可能希望忽略这些值：Combine 为该任务提供了 Operator：

![removeDuplicates.png](http://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f8d2b7f5e0b94cbf87e3ec320a57a0c1~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下示例添加到我们的 Playground:

```swift
example("removeDuplicates") {
    ["a", "b", "b", "b", "c", "d", "d", "e", "f", "f"]
        .publisher
        .removeDuplicates()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们过滤了数组中重复的字符串，运行我们的 Playground 并查看控制台：

```css
--- removeDuplicates ---
a
b
c
d
e
f
复制代码
```

### 移除 `nil` 值

#### `compactMap(_:)`

```swift
func compactMap<T>(_ transform: @escaping (Self.Output) -> T?) -> Publishers.CompactMap<Self, T>
复制代码
```

Swift 标准库中的一个非常著名的方法：`compactMap`—— Combine 有一个同名的 Operator：

![compactMap.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8c5922584a614493a9c894a888fa2649~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下内容添加到我们的 Playground：

```swift
example("compactMap") {
    ["a", "1", "2", "b", "3", "4", "c"]
        .publisher
        .compactMap { Int($0) }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们创建一个 `String` Publisher，使用 `compactMap` 尝试从每个单独的字符串初始化一个 `Int`。 如果失败，则返回 nil。 这些 nil 值会被 `compactMap` 过滤。在我们的 Playground 中运行上面的示例：

```diff
--- compactMap ---
1
2
3
4
复制代码
```

### 忽略值

#### `ignoreOutput()`

```swift
func ignoreOutput() -> Publishers.IgnoreOutput<Self>
复制代码
```

有时我们只关心 Publisher 完成事件的发送，而忽略值。我们可以使用 `ignoreOutput`：

![ignoreOutput.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1e8914fcda6c4b96be2e9dc3c4cc616f~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到我们的 Playground：

```swift
example("ignoreOutput") {
    (1...100)
        .publisher
        .ignoreOutput()
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们创建一个 Publisher，从 1 到 100 发出 100 个值，添加 `ignoreOutput()` Operator，它会忽略所有值，只向消费者发出完成事件：

```diff
--- ignoreOutput ---
finished
复制代码
```

### 寻找值

#### `first()` `first(where:)`

```swift
func first() -> Publishers.First<Self>
func first(where predicate: @escaping (Self.Output) -> Bool) -> Publishers.FirstWhere<Self>
复制代码
```

#### `last()` `last(where:)`

```swift
func last() -> Publishers.Last<Self>
func last(where predicate: @escaping (Self.Output) -> Bool) -> Publishers.LastWhere<Self>
复制代码
```

同样起源于 Swift 标准库的 Operator：`first(where:)` 和 `last(where:)`。 我们可以使用它们分别仅查找和发出与提供闭包条件匹配的第一个或最后一个值：

![firstAndLast.png](http://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/82f853ff42ae4beaac121de72a999d67~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到我们的 Playground：

```swift
example("first(where:)") {
     (1...5)
        .publisher
        .first(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example("last(where:)") {
     (1...5)
        .publisher
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们分别查找了发出的第一个和最后一个偶数值：

```scss
--- first(where:) ---
2
finished
--- last(where:) ---
4
finished
复制代码
```

一旦 `first(where:)` 找到匹配的值，它就会通过 Subscription 发送取消，上游停止发出值。可以添加 `print()` 验证：

```swift
example("first(where:)") {
     (1...5)
        .publisher
        .print()
        .first(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

控制台将输出：

```erlang
--- first(where:) ---
receive subscription: (1...5)
request unlimited
receive value: (1)
receive value: (2)
receive cancel
2
finished
复制代码
```

`first(where:)`  是 lazy的，而  `last(where:)` 则是贪婪的，需要等 Publisher 发送完成事件后，才能确定所需的值。

### 删除值

#### `dropFirst(_:)`

```swift
func dropFirst(_ count: Int = 1) -> Publishers.Drop<Self>
复制代码
```

`dropFirst` Operator 需要 `count` 参数（如果省略，则默认为 1），忽略 Publisher 发出的前 `count` 个值：

![dropFirst.png](http://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cb81d18fb4fc48da88d2de164437f035~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到 Playground：

```swift
example("dropFirst") {
    (1...5)
        .publisher
        .dropFirst(3)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们创建一个 Publisher 发出 1 到 5 之间的数字。使用 `dropFirst(3)` 删除前三个值：

```swift
--- dropFirst ---
4
5
复制代码
```

#### `drop(while:)`

```swift
func drop(while predicate: @escaping (Self.Output) -> Bool) -> Publishers.DropWhile<Self>
复制代码
```

`drop(while:)` 是一个非常有用的变体，它用条件闭包忽略 Publisher 发出的任何值，直到第一次满足该条件后，值就可以通过：

![dropWhile.png](http://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1b702a28b52b49d39ccd49b388173233~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到 Playground：

```swift
example("drop(while:)") {
    let numbers = (1...5)
        .publisher
        .drop(while: { $0 % 4 != 0 })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

我们创建了一个发出 1 到 5 之间数字的 Publisher，使用 `drop(while:)` 等待可以被 4 整除的第一个值：

```scss
--- drop(while:) ---
4
5
复制代码
```

`drop(while:)` 的闭包在满足条件后将不再执行，修改上述代码：

```swift
example("drop(while:)") {
    let numbers = (1...5)
        .publisher
        .drop(while: {
            print("Checking \($0)")
            return $0 % 4 != 0
        })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

控制台将输出：

```scss
--- drop(while:) ---
Checking 1
Checking 2
Checking 3
Checking 4
4
5
复制代码
```

#### `drop(untilOutputFrom:)`

```swift
func drop<P>(untilOutputFrom publisher: P) -> Publishers.DropUntilOutput<Self, P> where P : Publisher, Self.Failure == P.Failure
复制代码
```

`drop(untilOutputFrom:)` 会跳过 Publisher 发出的任何值，直到作为参数的 Publisher 开始发出值：

![dropUntilOutputFrom.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b6738e92ac0a4d97a8a8a34b4964cf34~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

我们用代码来描述这个过程：

```swift
example("drop(untilOutputFrom:)") {
    let isReady = PassthroughSubject<Void, Never>()
    let publisher = PassthroughSubject<Int, Never>()
    publisher
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    (1...5).forEach { num in
        publisher.send(num)
        if num == 3 {
            isReady.send()
        }
    }
}
复制代码
```

我们创建了两个 `PassthroughSubject`。使用 `drop(untilOutputFrom: isReady)` 忽略 `publisher` 的值，直到 `isReady` 发出至少一个值，在 `publisher` 发出 3 后， `isReady`  发出值：

```scss
--- drop(untilOutputFrom:) ---
4
5
复制代码
```

### 限制值

#### `prefix(_:)`

```swift
func prefix(_ maxLength: Int) -> Publishers.Output<Self>
复制代码
```

#### `prefix(while:)`

```swift
func prefix(while predicate: @escaping (Self.Output) -> Bool) -> Publishers.PrefixWhile<Self>
复制代码
```

#### `prefix(untilOutputFrom:)`

```swift
func prefix<P>(untilOutputFrom publisher: P) -> Publishers.PrefixUntilOutput<Self, P> where P : Publisher
复制代码
```

与删除值的一系列 Operator 相反，`prefix` 系列将只取所提供的数量的值，`prefix` 系列是 lazy 的，获取所需的值后即发送完成事件：

![prefix.png](http://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/104cc60258424e61929431226d45e571~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到 Playground：

```swift
example("prefix") {
    (1...5)
        .publisher
        .prefix(2)
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example("prefix(while:)") {
    (1...5)
        .publisher
        .prefix(while: { $0 < 3 })
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example("prefix(untilOutputFrom:)") {
    let isReady = PassthroughSubject<Void, Never>()
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .prefix(untilOutputFrom: isReady)
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
    (1...5).forEach { num in
        publisher.send(num)
        if num == 2 {
            isReady.send()
        }
    }
}
复制代码
```

运行 Playground，控制台将输出：

```swift
--- prefix ---
1
2
finished
--- prefix(while:) ---
1
2
finished
--- prefix(untilOutputFrom:) ---
1
2
finished
复制代码
```

## 组合操作符(Combining Operators)

这组 Operator 允许我们组合不同 Publisher 发出的值或事件，在代码中创建有意义的数据组合。

### 前置值

#### `prepend(_:)`

```swift
func prepend(_ elements: Self.Output...) -> Publishers.Concatenate<Publishers.Sequence<[Self.Output], Self.Failure>, Self>
复制代码
```

`...` 语法指可变参数列表，这意味着该方法入参可以为任意数量的与原始 Publisher 的 `Output` 类型相同的值：

![prepend.png](http://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e0fa787ea12e4078b1583a949b2ae5e7~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到我们的 Playground：

```swift
example("prepend") {
    [4, 5]
        .publisher
        .prepend(1, 2, 3)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

在上面的代码中，我们创建一个发布数字 4、5 的 Publisher，使用 `prepend` 在 Publisher 的值之前添加数字 1 、2、3。运行 Playground，我们会在调试控制台中看到以下内容：

```diff
--- prepend ---
1
2
3
4
5
复制代码
```

我们可以轻松添加多个前置：

```swift
example("prepend") {
    [4, 5]
        .publisher
        .prepend(1, 2, 3)
        .prepend(-1, 0)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

将会输出：

```diff
--- prepend ---
-1
0
1
2
3
4
5
复制代码
```

#### `prepend(Sequence)`

```swift
func prepend<S>(_ elements: S) -> Publishers.Concatenate<Publishers.Sequence<S, Self.Failure>, Self> where S : Sequence, Self.Output == S.Element
复制代码
```

`prepend` 的这种变体将任何符合 `Sequence` 的对象作为输入。 例如 Array 或 Set：

将以下代码添加到你的 Playground：

```swift
example("prepend(Sequence)") {
    [7, 8].publisher
        .prepend([5, 6])
        .prepend(Set(3...4))
        .prepend(stride(from: 0, to: 3, by: 1))
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

在此代码中，我们创建了一个发布数字 7、8 的 Publisher。三次链接 `prepend(Sequence`)  到 Publisher， 一次从 Array 中添加值，第二次从 Set 中添加值、第三次从符合 `Sequence`  的 `Strideable` 中添加值：

```scss
--- prepend(Sequence) ---
0
1
2
3
4
5
6
7
8
复制代码
```

> Set 是无序的，意味着上例中的两个值可以是 3 和 4，也可以是 4 和 5。

#### `prepend(Publisher)`

```swift
func prepend<P>(_ publisher: P) -> Publishers.Concatenate<P, Self> where P : Publisher, Self.Failure == P.Failure, Self.Output == P.Output
复制代码
```

前两个 Operator 将值列表添加到现有 Publisher。 如果我们有两个不同的 Publisher，并且想将它们的值合在一起，我们可以使用 `prepend(Publisher)` 在 Publisher 的值之前添加第二个 Publisher 发出的值：

```swift
example("prepend(Publisher)") {
    let publisher1 = [3, 4].publisher
    let publisher2 = [1, 2].publisher
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

运行 Playground，控制台将输出：

```swift
--- prepend(Publisher) ---
1
2
3
4
复制代码
```

该 Operator 还有一些细节，我们继续添加以下内容添加到 Playground：

```swift
example("prepend(Publisher) V2") {
    let publisher1 = [3, 4].publisher
    let publisher2 = PassthroughSubject<Int, Never>()
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    publisher2.send(1)
    publisher2.send(2)
}
复制代码
```

我们创建了两个 Publisher。 第一个发出值 3 和 4，而第二个是动态接受值的 `PassthroughSubject`。在 `publisher1` 的值之前添加 `publisher2` 的值，接着 publisher2 发送值 1 和 2。运行 Playground：

```scss
--- prepend(Publisher) V2 ---
1
2
复制代码
```

为什么 `publisher2` 只发出两个值？ 因为 `publisher2` 发出了值，但没有发出完成事件，被前置的 Publisher 必须发出完成事件后，Combine 才知道需要进行切换 Publisher：

```swift
example("prepend(Publisher) V2") {
    let publisher1 = [3, 4].publisher
    let publisher2 = PassthroughSubject<Int, Never>()
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    publisher2.send(1)
    publisher2.send(2)
    publisher2.send(completion: .finished)
}
复制代码
```

现在，控制台才会输出：

```swift
--- prepend(Publisher) V2 ---
1
2
3
4
复制代码
```

### 追加值

#### `append(_:)`

```swift
func append(_ elements: Self.Output...) -> Publishers.Concatenate<Self, Publishers.Sequence<[Self.Output], Self.Failure>>
复制代码
```

`append` 的工作方式与 `prepend` 类似：它也接受一个 `Output` 类型的可变参数列表，然后在原始 Publisher 完成事件后，附加在最终的完成事件前：

![append.png](http://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c0ce8303b85f4e66b564a4931cd6cff7~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到 Playground：

```swift
example("append") {
    [1, 2, 3]
        .publisher
        .append(4, 5)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

在上面的代码中，创建一个发布 1、2、3 的 Publisher，使用 `append`，追加 4 和 5：

```diff
--- append ---
1
2
3
4
5
复制代码
```

`append` 的工作方式与我们期望的完全一样，等待上游完成事件后，然后再添加自己的值。这意味着上游必须发出完成事件，否则 `append`  永远不会发生。

#### `append(Sequence)`

```swift
func append<S>(_ elements: S) -> Publishers.Concatenate<Self, Publishers.Sequence<S, Self.Failure>> where S : Sequence, Self.Output == S.Element
复制代码
```

与 `prepend` 类似，`append` 的变体可以追加符合 `Sequence` 的对象：

```swift
example("append(Sequence)") {
    [1, 2, 3]
        .publisher
        .append([4, 5])
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

运行 Playground 将输出：

```scss
--- append(Sequence) ---
1
2
3
4
5
复制代码
```

#### `append(Publisher)`

```swift
func append<P>(_ publisher: P) -> Publishers.Concatenate<Self, P> where P : Publisher, Self.Failure == P.Failure, Self.Output == P.Output
复制代码
```

与 `prepend` 类似，`append` 的变体可以追加另一个 Publisher：

```swift
example("append(Publisher)") {
    let publisher1 = [1, 2].publisher
    let publisher2 = [3, 4].publisher
    publisher1
        .append(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
复制代码
```

运行 Playground 将输出：

```scss
--- append(Publisher) ---
1
2
3
4
复制代码
```

同样需要注意，只有前一个 Publisher 发布完成事件，才能追加另一个 Publisher。

### 其他高级组合操作符

#### `switchToLatest()`

```swift
func switchToLatest() -> Publishers.SwitchToLatest<Self.Output, Self>
复制代码
```

`switchToLatest()` 使我们可以在取消对旧 Publisher 订阅的同时，切换到对新 Publisher 的订阅：

![switchToLatest.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3c981fd7942d419d8461ff6c038224b6~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到我们的 Playground，描述上述弹珠图：

```swift
example("switchToLatest") {
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    let numbers1 = PassthroughSubject<Int, Never>()
    let numbers2 = PassthroughSubject<Int, Never>()
    let numbers3 = PassthroughSubject<Int, Never>()
    
    publishers
        .switchToLatest()
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    publishers.send(numbers1)
    numbers1.send(1)
    numbers1.send(2)
    
    publishers.send(numbers2)
    numbers1.send(3)
    numbers1.send(completion: .finished)
    numbers2.send(4)
    numbers2.send(5)
    
    publishers.send(numbers3)
    numbers2.send(6)
    numbers2.send(completion: .finished)
    numbers3.send(7)
    numbers3.send(8)
    numbers3.send(9)
    numbers3.send(completion: .finished)
    
    publishers.send(completion: .finished)
}
复制代码
```

我们创建一个 `PassthroughSubject` 发出其他 `PassthroughSubject` 值，接着创建三个 `PassthroughSubject`。在 `publishers` 使用 `switchToLatest`。现在，每次我们通过 `publishers` 发送  `numbers1`、` numbers2`、` numbers3` 时，我们都会切换到新的 Publisher 并取消之前的 Subscription。最终，我们的控制台将打印：

```swift
--- switchToLatest ---
1
2
4
5
7
8
9
finished
复制代码
```

在实际应用中，例如用户点击触发网络请求的按钮，再未拿到请求结果时，用户再次点击按钮，触发第二个网络请求。此时，可以使用 `switchToLatest()` 来只使用新的请求结果。

#### `merge(with:)`

```swift
func merge(with other: Self) -> Publishers.MergeMany<Self>
复制代码
```

此 Operator 将合并来自同一类型的不同 Publisher 的值，如下所示：

![merge.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2e451720f3fa45e3abfdf77b52434c1e~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到我们的 Playground：

```swift
example("merge(with:)") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher1
        .merge(with: publisher2)
        .sink(receiveCompletion: { print($0) },
            receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send(3)
    publisher1.send(4)
    publisher1.send(completion: .finished)
    publisher2.send(5)
    publisher2.send(completion: .finished)
}
复制代码
```

在上述代码中，我们创建来了两个 `PassthroughSubjects` 。将 `publisher1` 与 `publisher2` `merge`。 `merge` 提供了重载，可让我们合并多达八个不同的 Publisher。将 1 和 2 添加到 `publisher1`，然后将 3 添加到 `publisher2`，然后再次将 4 添加到 `publisher1` 并发送完成事件，最后将 5 添加到 `publisher2 `并发送完成事件。

运行我们的 Playground：

```swift
--- merge(with:) ---
1
2
3
4
5
finished
复制代码
```

`merge` 将会等待所有 Publisher 发出完成事件后才会发出最终的完成事件。

#### `combineLatest(_:_:)`

```swift
func combineLatest<P, T>(
    _ other: P,
    _ transform: @escaping (Self.Output, P.Output) -> T
) -> Publishers.Map<Publishers.CombineLatest<Self, P>, T> where P : Publisher, Self.Failure == P.Failure
复制代码
```

combineLatest 是另一个允许我们组合不同 Publisher 的操作符。 它还允许我们组合不同值类型的Publisher。它在所有 Publisher 发出值时，发出一个包含所有 Publisher 的最新值的元组。

所以会有一个问题：Publisher 和传递给 `combineLatest` 的每个 Publisher 都必须至少发出一个值，然后 `combineLatest` 本身才会发出值：

![combineLatest.png](http://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c62e98b4aafa44c28778b7eaf0758df4~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到我们的 Playground：

```swift
example("combineLatest") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    publisher1
        .combineLatest(publisher2)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print("P1: \($0), P2: \($1)") }
        )
        .store(in: &subscriptions)
    
    publisher1.send(1)
    publisher1.send(2)
    
    publisher2.send("a")
    publisher2.send("b")
    
    publisher1.send(3)
        publisher1.send(completion: .finished)
    
    publisher2.send("c")
    publisher2.send(completion: .finished)
}
复制代码
```

我们创建两个 `PassthroughSubjects`。将 `publisher2` 的与 publisher1  `combineLatest` 起来。 我们可以使用不同的 `combineLatest`  的重载组合最多四个不同的 Publisher。将 1 和 2 发送到 `publisher1`，然后将“a”和“b”发送到 `publisher2`，然后将 3 发送到 `publisher1` 并发送完成事件，最后将“c”发送到 `publisher2` 并发送完成事件。

最终，控制台将输出：

```swift
--- combineLatest ---
P1: 2, P2: a
P1: 2, P2: b
P1: 3, P2: b
P1: 3, P2: c
finished
复制代码
```

#### `zip(_:)`

```swift
func zip<P>(_ other: P) -> Publishers.Zip<Self, P> where P : Publisher, Self.Failure == P.Failure
复制代码
```

该 Operator 的工作方式与标准库类似，发出不同 Publisher 的相同索引的成对值的元组。即它等待每个 Publisher 发出一个值，然后在所有 Publisher 在当前索引处发出一个值后，发出一个元组：

![zip.png](http://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/64085d435ddb4a84abcc69911b50129e~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

将以下代码添加到我们的 Playground：

```swift
example("zip") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    publisher1
        .zip(publisher2)
        .sink(receiveCompletion: { print($0) },
            receiveValue: { print("P1: \($0), P2: \($1)") })
        .store(in: &subscriptions)
    
    publisher1.send(1)
    publisher1.send(2)
    
    publisher2.send("a")
    publisher2.send("b")
    
    publisher1.send(3)
    publisher1.send(completion: .finished)
    
    publisher2.send("c")
    publisher2.send("d")
    publisher2.send(completion: .finished)
}
复制代码
```

我们创建两个 `PassthroughSubject`。将 publisher1 与 publisher2 `zip`。将 1 和 2 发送到 `publisher1`，然后将“a”和“b”发送到 `publisher2`，然后将 3 再次发送到 `publisher1` 并发送完成事件，最后将“c”和“d”发送到 `publisher2 `并发送完成事件。

最后一次运行我们的 Playground 并查看调试控制台：

```yaml
--- zip ---
P1: 1, P2: a
P1: 2, P2: b
P1: 3, P2: c
finished
复制代码
```

## 内容参考

- [Combine | Apple Developer Documentation](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fcombine)；
- 来自 [Kodeco](https://link.juejin.cn?target=https%3A%2F%2Fwww.kodeco.com%2Fios%2Fbooks) 的书籍《Combine: Asynchronous Programming with Swift》；
- 对上述 [Kodeco](https://link.juejin.cn?target=https%3A%2F%2Fwww.kodeco.com%2Fios%2Fbooks) 书籍的汉语自译版 [《Combine: Asynchronous Programming with Swift》](https://link.juejin.cn?target=https%3A%2F%2Flayers-organization-1.gitbook.io%2Fcombine-asynchronous-programming-with-swift%2Fgroup-1%2Fdi-yi-bu-fen-combine-jian-jie)整理与补充。



作者：Layer
链接：https://juejin.cn/post/7173204152556716063
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。