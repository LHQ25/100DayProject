## Combine 简介

### Combine 概述

Combine framework 提供了一个声明式的 Swift API，通过 Combine，我们可以为给定的事件源创建单个处理链，而不是实现多个 delegate callback 或 completion handler。链的每个部分是一个 Combine 的**操作符(Operator)**，它对从上一步接收到的值执行不同的操作。这些值可以表示多种异步事件，**发布者(Publisher)** 可以发布随时间变化的值，**订阅者(Subscriber)** 从发布者那里接收这些值。

通过使用 Combine，我们集中我们的事件处理代码，消代码中的嵌套的闭包、基于约定的回调等技术，使我们的代码更易于阅读和维护。该系列将介绍 Combine framework，并使用 Swift 编写声明式(Declarative)、响应式(Reactive) App。

### Apple 平台下的异步编程

Apple 也在不断在改进其平台的异步编程，我们可以使用多种机制创建和执行异步代码。我们肯定使用过这些内容：`NotificationCenter`、GCD、`Operation`、委托模式和闭包等。在这些技术背景下，编写高质量的异步代码会更复杂一些，不同类型的异步 API，每个都有自己的接口设计方案。

Combine 作为一种通用的设计和编写异步代码的高级(High-level)语言被引入  Swift，也被 Apple 集成到 Timer、NotificationCenter 和 Core Data 等框架中。从 Foundation 一直到 SwiftUI，Apple 将 Combine 集成作为其“传统”API 的替代方案。作为开发者，Combine 也很容易集成到我们自己的代码中。

声明式(Declarative)、响应式(Reactive)编程已经存在了很长一段时间。在 2009 年微软推出的 .NET (Rx.NET) 是第一个的响应式方案。2012 年其开源后，许多不同的语言开始使用这一概念。在 Apple 平台，已经有几个第三方响应式框架，如 RxSwift，它实现了 Rx 标准。

Combine 实现了一个与 Rx 不同但相似的标准，称为 Reactive Streams。 Reactive Streams 与 Rx 有一些关键区别，但它们有共同的核心概念。在 iOS 13/macOS Catalina 及以后，Apple 通过内置的 Combine 框架为其生态带来了响应式编程的支持。

## Combine 的基础概念

Combine 中的四个关键部分是**发布者(Publisher)**、**操作符(Operator)** 和 **订阅者(Subscriber)**，以及**订阅(Subscription)**。

### 发布者(Publisher)基础概念

Publisher 可以随着时间的推移向一个或多个接收方(订阅者)发出值的类型。每个 Publisher 都可以发出这三种类型的多个事件：

1. 该 Publisher 的 `Output` 类型的值；
2. 表示成功的 completion；
3. 带有该 Publisher 的 `Failure` 类型的 `Error` 的 completion。

Publisher 可以发出零个或多个 `Output` 类型的值，如果它完成了，无论是成功还是失败，后续它都不会发出任何其他事件。

以发布 `Int` 值的 Publisher 在时间轴上的可视化效果为例：

![Publisher.png](http://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1312ad385db6409ca8d18f8aeb935dc5~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

蓝色框表示在时间线上给定时间 Publisher 发出的值。图表右竖线表示 stream 的成功完成。三种类非常普遍，代表了我们 App 中的任何类型的动态数据。

Publisher 协议有两种类型是通用的，正如前文提到：

- `Publisher.Output` 是 Publisher 输出的值的类型。 一个 `Int` Publisher 永远不能直接发出 `String` 类型值。
- `Publisher.Failure` 是 Publisher 在失败时可以抛出的错误类型。 如果 Publisher 永远不会失败，我们可以指定为 `Never` 类型来。

当我们订阅某个 Publisher 时，会期望从中获得什么值以及可能会因哪些错误而失败，即 `Publisher.Output` 与 `Publisher.Failure`。

### 操作符(Operator)基础概念

Operator 是在 Publisher 协议上声明的方法，它们返回相同的或新的 Publisher。我们可以一个接一个地调用操作符，从而有效地将它们链接在一起。这些操作符是高度解耦、可组合的，所以它们可以组合起来在单个**订阅(Subscription)** 中实现复杂逻辑。操作符总的输入和输出，通常称为 **上游(Upstream)** 和 **下游(Downstream)**。但需要注意，如果一个 Operator 的输出与下一个 Operator 的输入类型不匹配，则不能组合在一起。

![Operator.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/335e2f73ea8a4caaae63647fe4b6b388~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

操作符专注于处理从前一个操作符接收到的数据，并将其输出提供给链中的下一个操作符。我们可以以明确的方式，来定义每个异步的、抽象的工作的顺序，以及有明确的输入、输出类型和错误处理。

### 订阅者(Subscriber)基础概念

到达订阅链的末端，每个订阅都以一个 Subscriber 结束。Subscriber 通常对输出的值或事件做些什么。

![Subscriber.png](http://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4dcd82bf9d7b448eb87020c00f3d3578~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

目前，Combine 提供了两个内置 Subscriber：

- Sink Subscriber 允许我们使用闭包。来接收值或事件。在那里我们可以对值或事件做想做的事情。
- Assign Subscriber 允许我们通过 keypath 直接将结果绑定到模型，或 UI 控件上的某个属性从而在直接屏幕上显示数据。

如果我们对数据有其他需求，创建自定义 Subscriber 比创建 Publisher 更容易。 Combine 提供非常简单的协议，使我们能够合适的构建自己的工具。

### 订阅(Subscription)基础概念

**订阅(Subscription)** 值 Combine 的 Subscription 协议及实现该协议的对象，通俗的说，是 Publisher、Operator 和 Subscriber 的完整链。

当我们在 Subscription 的末尾添加 Subscriber 时，它会在链的开头“激活” Publisher。即**如果没有 Subscriber 接收输出，则 Publisher 不会发出任何值**。

Subscription 允许我们使用自己的自定义代码、错误处理，声明了一连串异步事件。并且这些代码我们只需要做一次，然后就不必再考虑它了。

如果我们的 App 完全使用 Combine，可以通过 Subscription 来描述我们的整个 App 的逻辑。这样我们不需要再写 Push Data 或 Pull Data 或 callback 之类的代码：

![Subscription.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/831e1ef92b174f889bed2e47da003af7~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

此外，我们不需要专门管理 Subscription：Combine 提供的一个名为 `Cancellable` 的协议。

系统提供的两个 Subscriber 都符合 `Cancellable`，这意味着我们的 Subscription 代码（整个 Publisher、Operator 和 Subscriber 调用链）返回一个 Cancellable 对象。每当我们从内存中释放 `Cancellable `对象时，它都会取消整个 Subscription 并从内存中释放其资源。

因此，我们可以通过绑定 Subscription 的生命周期到 ViewController 的 strong 属性中，每当用户从关闭 ViewController 时，都会析构其属性并取消 Subscription。我们可以自动化这个过程，添加一个 `[AnyCancellable]` 类型的属性，并在其中添加当前的 Subscription。当该属性从内存中释放时，这些 Subscription 都会被自动取消并释放。

### Combine 的优势

当前，不使用 Combine 仍可以创建好的 App。但是使用这些框架会更方便、安全和高效。系统级别的异步代码的抽象，其意味着已经经过充分测试、有更紧密集成和更安全的技术：

- Combine 在系统级别上集成，本身使用了一些不公开的语言功能，提供了我们无法自己构建的 API；
- Combine 将许多常见操作抽象为 Publisher 协议上的方法，包括内置的 Operator ，已经过 Apple 的测试；
- 当我们的代码中所有的异步工作都使用 Publisher 的接口，模块组合和可重用性变得非常强大。
- Combine 的 Operator 是高度可组合的。如果我们创建一个新的 Operator，其与其余的 Combine 即插即用。

此外，在 App 架构方面，Combine 肯定不是一个影响我们如何构 App 的框架。Combine 只是处理异步数据和事件的通信协议，它不会改变别的内容。我们可以在你的 MVC 中使用 Combine，同样可以在 MVVM 代码、VIPER 等中使用它。因此，我们可以迭代地和有选择地添加 Combine 代码，我们不需要做出的“全有或全无”的选择。例如我们可以首先转换我们的数据模型，或调整网络层，再或者只为新增代码中使用 Combine。

如果我们同时采用 Combine 和 SwiftUI，情况会略有不同。SwiftUI 从 MVC 架构中删除了 C，也要归功于将 Combine 和 SwiftUI 的结合使用。当我们从数据模型到视图一直使用响应式编程时，其实不需要一个特殊的 Controller 来控制视图：

![CombineAndSwiftUI.drawio.png](http://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/680da2cf703f438180818d5500e184e5~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

## 发布者(Publisher)

### NotificationCenter

Combine 的核心是 Publisher 协议。 该协议定义了对 Publisher 类型的要求，使其能够随时间将一系列值传输给一个或多个订阅者。

订阅 Publisher 的想法类似于订阅来自 `NotificationCenter` 的通知。Apple 也在  `NotificationCenter` 提供了 `publisher(for:object:)` 方法，返回一个可以发布通知的 Publisher。

可以尝试在 Playground 中以下代码：

```swift
import Foundation

let center = NotificationCenter.default
let myNotification = Notification.Name("MyNotification")

let publisher = center.publisher(for: myNotification, object: nil)
let observer = center.addObserver(
    forName: myNotification,
    object: nil,
    queue: nil) { notification in
        print("Notification received!")
    }

center.post(name: myNotification, object: nil)
center.removeObserver(observer)
复制代码
```

在上述代码中，我们通过 `center` 获取了一个发布 `myNotification` 类型的 `Notification` 的 Publisher。接着，我们创建一个 `observer` 来监听 `center` 的  `myNotification` 类型的 `Notification` 。在收到该  `Notification`  时，将打印 `Notification received!`。最后，我们在 `center` 上  post `myNotification`。最终，控制台将展示：

```
Notification received!
复制代码
```

但上述输出，实际上并非来自 Publisher，我们继续往下看。

## 订阅者(Subscriber)

### 使用 `sink(_:_:)`

重新调整 Playground 中的代码：

```swift
import Foundation

let center = NotificationCenter.default
let myNotification = Notification.Name("MyNotification")

let publisher = center.publisher(for: myNotification, object: nil)
let subscription = publisher
    .sink { _ in
        print("Notification received from a publisher!")
    }

center.post(name: myNotification, object: nil)
subscription.cancel()

复制代码
```

我们通过在 `publisher` 上使用 `sink(_:_:)` 创建 Subscription，在 `publisher` 发布 `myNotification` 值时，将打印内容：

```css
Notification received from a publisher!
复制代码
```

查看 `sink`，我们会看到它其实是一个简单的方法，Subscriber 通过闭包处理以处理来自 Publisher 的 `Output` 类型的值，`sink` 将持续接收与 Publisher 发出的值，这也称为无限需求(Unlimited demand)。：

```swift
func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable
复制代码
```

此外， `sink`  实际上提供了两个闭包：一个用于处理接收的值，另一个用于处理接收成功或失败的 completion 事件。在 Playground 上添加 `import Combine` 后继续添加代码：

```swift
let just = Just("Hello, Combine!")
_ = just
    .sink(
        receiveCompletion: {
            print("Received completion: ", $0)
        },
        receiveValue: {
            print("Received value: ", $0)
        })
复制代码
```

我们在这里使用 `Just` 创建 Publiesher， `Just` 允许我们以单个值创建 Publiesher。接着创建对 Publiesher `just` 的 Subscription，并为接收到的 completion 事件和值进行打印：

```yaml
Received value:  Hello, Combine!
Received completion:  finished
复制代码
```

我们来看下 `Just` 的描述，它是一个 Publisher，它向每个 Subscriber 发出一次 output(值)，然后 finish(completion 事件)：

```swift
A publisher that emits an output to each subscriber just once, and then finishes.
复制代码
```

我们可以继续添代码，添加另一个 Subscriber：

```swift
_ = just
    .sink(
        receiveCompletion: {
            print("Received completion (another): ", $0)
        },
        receiveValue: {
            print("Received value (another): ", $0)
        })
复制代码
```

最终，控制台将输出以下内容：

```java
Received value:  Hello, Combine!
Received completion:  finished
Received value (another):  Hello, Combine!
Received completion (another):  finished
复制代码
```

### 使用 `assign(to:on:)`

除了` sink` 之外，内置的 `assign(to:on:)` 运算符能够将接收到的值分配给对象的属性，并且与  KVO 兼容。可以在 Playground 中删除之前的代码，并添加以下代码：

```swift
class MyObject {
    var value: String = "" {
        didSet {
            print(value)
        }
    }
}

let object = MyObject()
let publisher = ["Hello", "Combine!"].publisher
_ = publisher
    .assign(to: \.value, on: object)
复制代码
```

在这里，我们首先定义了一个具有 `value` 属性的 `MyObject` 类，`value` 在 `didSet` 后，将打印当前 `value`。

创建 `MyObject` 类的实例 `object`。从 `String` 数组创建 `publisher`，订阅该 `publisher`，将收到的值分配给 `object` 的 `value` 属性。运行 Playground，控制台将最终展示：

```
Hello
Combine!
复制代码
```

> `assign(to:on:)` 在处理 UIKit 或 AppKit 框架的 App 时特别有用，我们可以将值直接分配给 `label`、 `button` 等 UI 组件。

### 使用 `assign(to:)`

`assign` 还一个变体， `assign(to:)` 可将 Publisher 发出的值用于 `@Published` 属性包装器注解的属性，在 Playground 中删除之前的代码，并添加以下代码：

```swift
class MyObject {
    @Published var value = 0
}

let object = MyObject()
object.$value
    .sink {
        print($0)
    }

(0..<5).publisher
    .assign(to: &object.$value)
复制代码
```

我们定义 `MyObject` 类，并创建一个 `object` 实例，`value` 属性用 `@Published` 属性包装器注解，除了可作为常规属性访问之外，它还为属性创建了一个 Publisher。使用 `@Published` 属性上的 `$` 前缀来访问其底层 Publisher，订阅该 Publisher，并打印出收到的每个值。最后，我们创建一个 0..<5 的 `Int` Publisher 并将它发出的每个值 `assign` 给 `object` 的 `value` Publisher。 使用 `&` 来表示对属性的 inout 引用，这里的 inout 来源于函数签名：

```swift
func assign(to published: inout Published<Self.Output>.Publisher)
复制代码
```

这里有一些差异，`assign(to:)` 不返回 `AnyCancellable`，在内部完成了生命周期的管理，在 `@Published` 属性释放时会取消订阅。最终，控制台将输出：

```
0
0
1
2
3
4
复制代码
```

我们可能想知道使用 `assign(to:on:)` 和  `assign(to:)` 还有哪些差异？我们查看以下代码：

```swift
class MyObject {
    @Published var value: String = ""
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        ["A", "B", "C"].publisher
            .assign(to: \.value, on: self)
            .store(in: &subscriptions)
    }
}
复制代码
```

这这里，使用 `assign(to: \.word, on: self)` 并存储生成的 `AnyCancellable`，这会导致引用循环：`MyObject` 类实例持有生成的 `AnyCancellable`，而生成的 `AnyCancellable` 同样持有`MyObject` 类实例。此时用 `assign(to:)` 替换 `assign(to:on:)` 可以防止引入这个问题。

## Cancellable

当 Subscriber 不再希望从 Publisher 接收值时，我们需要取消 Subscription，释放资源并停止发生任何不应该触发的事件。

Subscription 将 `AnyCancellable` 实例作为用于取消 Subscription 的 token 返回，因此我们可以在完成后取消 Subscription。 `AnyCancellable` 符合 `Cancellable` 协议，该协议正是为此目的，提供 `cancel()` 方法。在前面的示例中，我们可以在最后添加 `subscription.cancel()`  来取消 Subscription。

如果我们没有显式调用 `cancel()`，它将一直持续到 Publisher 发出 completion 事件，或直到正常的内存管理导致存储的Subscription 释放。

## Subscription 中的相互作用

我们先来解释一下 Publisher 和 Subscriber 之间的相互作用，以下是一个简单概述：

![interaction.png](http://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1bcb1a102eb141339d9ddb913e4705d0~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

1. Subscriber 订阅 Publisher；
2. Publisher 创建 Subscription 并将其提供给 Subscriber；
3. Subscriber 请求值；
4. Publisher 发送对应数量的值；
5. Publisher 发送 completion 事件。

我们来看下 `Publisher` 协议：

```swift
public protocol Publisher {
    associatedtype Output
    
    associatedtype Failure : Error
    
    func receive<S>(subscriber: S)
    where S: Subscriber,
          Self.Failure == S.Failure,
          Self.Output == S.Input
}

extension Publisher {
    public func subscribe<S>(_ subscriber: S)
    where S : Subscriber,
          Self.Failure == S.Failure,
          Self.Output == S.Input
}
复制代码
```

1. `Output` 是 Publisher 生成的值的类型；
2. `Failure` 是 Publisher 可能发生的错误类型，如果 Publisher 保证不会发生错误，则为 `Never`；
3. 先看 extension 中的方法，Subscription 时，Subscriber 在 Publisher 上调用 `subscribe(_:)`；
4. 回过头看 `receive(subscriber:)` ，刚刚的 `subscribe(_:)` 的实现将调用 `receive(subscriber:)` ，将 Subscriber 附加到 Publisher 上，即创建 Subscription。

Subscriber 必须匹配 Publisher 的 `Output` 和  `Failure` 才能创建订阅。我们接着看看 Subscriber 协议：

```swift
public protocol Subscriber: CustomCombineIdentifierConvertible {
    associatedtype Input
    
    associatedtype Failure: Error
    
    func receive(subscription: Subscription)
    
    func receive(_ input: Self.Input) -> Subscribers.Demand
    
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
复制代码
```

1. `Input` 是 Subscriber 可以接收的值的类型；
2. `Failure `是 Subscriber 可以接收的错误类型； 如果 Subscriber 不会收到错误则为  `Never`；
3. Publisher 在 Subscriber 上调用 `receive(subscription:)` 来给 Subscriber 返回 Subscription；
4. Publisher 在 Subscriber 上调用 `receive(_:)`发送值；
5. Publisher 在 Subscriber 上调用 `receive(completion:)` 来发送 comlpetion 事件。

Publisher 与 Subscriber 通过 Subscription 进行链接：

```swift
public protocol Subscription: Cancellable, CustomCombineIdentifierConvertible {
    func request(_ demand: Subscribers.Demand)
}
复制代码
```

Subscriber 调用 `request(_:)` 表示它期望接收的值的数量，最多是无限制。

在 Subscriber 中，请注意 `receive(_:)` 返回一个 `Demand`。 因此，即使 `subscription.request(_:)` 设置了 Subscriber 初始期望接收的值的最大数量，我们也可以在每次收到新值时调整该最大值。在 `Subscriber.receive(_:)` 中调整的最大值，是与之前的最大值累加的。 这意味着我们可以在每次收到新值时，增加最大值，但不能进行减少。

## 自定义 Subscriber

清理 Playground 代码，并添加以下代码：

```swift
import Combine

final class IntSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.max(3))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value: ", input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion: ", completion)
    }
}

let publisher = (1...5).publisher
复制代码
```

我们定义一个自定义 Subscriber：`IntSubscriber`。指定此 Subscriber 的 `Input` 、`Failure`，可以接收 `Int` 类型的值，并且永远不会收到错误。接着实现所需的方法，`receive(subscription:)` 由 Publisher 调用，在该方法中调用 `subscription` 上的  `request(_:)` 方法，指定 Subscriber 期望接收最多三个值。收到每个值后打印，返回 `.none`，表示 Subscriber 不会调整自己对于值的数量多期望； `.none` 也等价于 `.max(0)`。收到 completion 事件时，打印事件。

继续在 Playground 中添加以下代码：

```swift
let publisher = (1...5).publisher
let subscriber = IntSubscriber()
publisher.subscribe(subscriber)
复制代码
```

我们通过 range 的创建发出 `Int` 类型值的 `publisher`。接着创建一个与 Publisher 的 `Output` 和 `Failure` 类型相匹配的 Subscriber。最后为 Publisher  `subscribe` Subscriber。

运行 Playground，我们将看到以下打印到控制台：

```yaml
Received value:  1
Received value:  2
Received value:  3
复制代码
```

我们没有收到 completion 事件，这是因为我们指定了 `.max(3)` 的最大数量。在 `IntSubscriber` 的 `receive(_:)` 中，尝试将 `.none` 更改为 `.unlimited`，再次运行 Playground，这次我们将看到控制台的输出包含所有值以及 completion 事件：

```yaml
Received value:  1
Received value:  2
Received value:  3
Received value:  4
Received value:  5
Received completion:  finished
复制代码
```

尝试将 `.unlimited` 更改为 `.max(1)` 并再次运行 Playground：

```yaml
Received value:  1
Received value:  2
Received value:  3
Received value:  4
Received value:  5
Received completion:  finished
复制代码
```

现在控制台打印的内容和 `.unlimited` 时相同，因为每次收到值时，我们都指定要将最大值增加 1。

## Future

之前我们使用 `Just` 创建一个向 Subscriber 发出单个值然后完成的 Publisher。`Future` 可以用于异步生成单个结果然后再完成。 清理 Playground 并添加：

```swift
import Foundation
import Combine
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func futureIncrement(
    integer: Int,
    afterDelay delay: TimeInterval
) -> Future<Int, Never> {
    Future<Int, Never> { promise in
        print("Original")
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            promise(.success(integer + 1))
        }
    }
}
复制代码
```

> `PlaygroundPage.current.needsIndefiniteExecution = true` 使 Playground 可以获得异步执行的结果。

我们创建了一个返回 `Future<Int, Never>` 的 `futureIncrement` 函数，它将发出一个整数并且永远不会失败。在函数内部，这我们创建了 `future`，它 block 中提供了一个 `promise`，我们在完成异步操作后，提供值执行该 `promise`，从而以在延迟 `delay` 时间后，递增 `integer`。

来看看 `Future` 的 Definition：

```swift
final public class Future<Output, Failure> : Publisher where Failure: Error {
    public typealias Promise = (Result<Output, Failure>) -> Void
    ...
}
复制代码
```

`Promise` 是一个闭包的别名，它接收一个 `Result`，其中包含由 `Future` 发布的单个值或错误。

回到 Playground ，在 `futureIncrement` 的定义之后添加以下代码：

```swift
var subscriptions = Set<AnyCancellable>()
let future = futureIncrement(integer: 1, afterDelay: 3)
future
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
复制代码
```

在这里，使用我们之前创建的函数创建一个 `Future`，在三秒后递增我们传递的整数 1。订阅并打印接收到的值和完成事件，并将生成的 Subscription 存储在 `subscriptions` 中。

运行 Playground，我们将在控制台看到：

```arduino
Original
// ...三秒以后
2
finished
复制代码
```

通过在 Playground 中添加以下代码来添加第二个 Subscription：

```swift
future
    .sink(receiveCompletion: { print("Second: ", $0) },
          receiveValue: { print("Second: ", $0) })
    .store(in: &subscriptions)
复制代码
```

重新运行 Playground，在指定的延迟之后，第二个 Subscription 接收到相同的值。Future 不会重新执行 `promise`，只有一个 `Original` 被打印，它共享或重放其输出：

```makefile
Original
2
finished
Second:  2
Second:  finished
复制代码
```

我们删除刚刚添加的两个 Subcription，只保留：

```swift
var subscriptions = Set<AnyCancellable>()
let future = futureIncrement(integer: 1, afterDelay: 3)
复制代码
```

代码运行立即打印 Original。 发生这种情况是因为 `Future` 是贪婪的，一旦创建就会执行。它不像常规 Publisher 那样是 lazy 的。

## Subject

### `PassthroughSubject`

我们这部分将学习如何创建自定义 Publisher —— `Subject`。`Subject` 充当中间人，使非 Combine 的命令式代码能够向 Combine 的 Subscriber 发送值。将这个新示例添加到我们清理后的 Playground：

```swift
enum MyError: Error {
    case test
}

final class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = MyError
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Received value: ", input)
        return input == "Combine" ? .max(1) : .none
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("Received completion: ", completion)
    }
}
复制代码
```

在上述代码中，我们定义了 `MyError` 类型。接着定义了一个接收 `String` 和 `MyError` 的自定义 Subscriber。该 Subscriber 根据收到的值调整期望，如果值为 `Combine` 则添加一的最大值。

继续添加代码：

```swift
let subject = PassthroughSubject<String, MyError>()
let subscriber = StringSubscriber()
subject.subscribe(subscriber)
let subscription = subject
    .sink(
        receiveCompletion: { completion in
            print("Received completion (sink): ", completion)
        },
        receiveValue: { value in
            print("Received value (sink): ", value)
        })
复制代码
```

我们创建了一个 `PassthroughSubject` 实例 `subject`。接着创建了一个自定义的 `StringSubscriber` 实例 `subscriber`。为 `subscriber` 订阅 `subject`。接着，我们使用 `sink` 创建另一个 Subscription。

`PassthroughSubject` 使我们能够按需发布值或者完成事件，它们将传递这些值和完成事件。与任何 Publisher 一样，我们必须提前声明它可以发出的值和错误的类型，Subscriber 的输入和失败类型必须和 `PassthroughSubject` 的发出的值和错误的类型相匹配，才能成功订阅 `PassthroughSubject`。

继续添加代码：

```swift
subject.send("Hello")
subject.send("Combine")
复制代码
```

使用 `subject` 的 `send` 方法发送两个值。运行 Playground，我们会看到的：

```java
Received value:  Hello
Received value (sink):  Hello
Received value:  Combine
Received value (sink):  Combine
复制代码
```

继续添加代码：

```swift
subscription.cancel()
subject.send("I am coming again.")
subject.send(completion: .finished)
subject.send("Is there anyone now?")
复制代码
```

在这里我们取消了 `subscription`，然后发送了另一个值，接着发送了完成时间，最后再发送一个值。运行 Playground：

```yaml
Received value (sink):  Hello
Received value:  Hello
Received value (sink):  Combine
Received value:  Combine
Received value:  I am coming again.
Received completion:  finished
复制代码
```

因为我们之前取消了第二个 Subscriptor 的 Subscription，只有第一个 Subscriptor 会收到“I am coming again.”值。第一个 Subscriptor 没有收到“Is there anyone now?”值，因为它在 `subject` 发送值之前收到了 completion 事件。

在 `subject.send(completion: .finished)`之前添加一行代码：

```swift
subject.send(completion: .failure(MyError.test))
复制代码
```

运行 Playground，控制台会打印：

```yaml
Received value (sink):  Hello
Received value:  Hello
Received value (sink):  Combine
Received value:  Combine
Received value:  I am coming again.
Received completion:  failure(Page_Contents.MyError.test)
复制代码
```

第一个 Subscriptor 收到 `.failure` 成事件，没有收到后发送的 `finished` 完成事件。这表明一旦 Publisher 发送了一个  完成事件它就完成了。

### `CurrentValueSubject`

使用 `PassthroughSubject` 传递值是将命令式代码连接到 `Combine` 的声明性世界的一种方式。 有时我们还想在命令式代码中查看 Publisher 的当前值——我们有另一个 subject：`CurrentValueSubject`。

清理 Playground 之前的代码，并将这个新示例添加到 playground 中：

```swift
var subscriptions = Set<AnyCancellable>()
let subject = CurrentValueSubject<Int, Never>(0)
subject
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
复制代码
```

首先创建 Subscription set `subscriptions`。接着创建类型为 `Int` 和 `Never` 的 `CurrentValueSubject`，其初始值为 0。创建 `subject` 的  Subscription  并打印从 `subject` 接收到的值。最后将 Subscription 存储在 `subscriptions` set 中。

我们必须使用初始值初始化 `CurrentValueSubject`；新 Subscriptor 立即获得该值或该 subject 发布的最新值。 运行 Playground：

```
0
复制代码
```

接着，添加此代码以发送两个新值：

```swift
subject.send(1)
subject.send(2)
复制代码
```

运行 Playground，控制台将输出：

```
0
1
2
复制代码
```

与 `PassthroughSubject` 不同，我们可以随时向 `CurrentValueSubject` 询问其 `value`。 添加以下代码以打印出 `subject` 的当前值，继续添加代码并产看控制台输出：

```swift
print(subject.value)
复制代码
0
1
2
2
复制代码
```

除了在 `CurrentValueSubject` 上调用 `send(_:)` 发送新值， 另一种方法是为其 value 属性分配一个新值。 添加此代码：

```swift
subject.value = 3
print(subject.value)
复制代码
```

运行 Playground，我们会看到 2 和 3 分别打印了两次——一次由 Subscriber 打印，另一次通过 `print` 打印。

接下来，创建一个对 `CurrentValueSubject` 的新 Subscription：

```swift
subject
    .sink(receiveValue: { print("Second subscription: ", $0) })
    .store(in: &subscriptions)
复制代码
```

我们在上文了解到，在 `subscriptions` set 释放时，会自动取消添加到其中的 Subscription，我们可以使用 `print()`  Operator，它将所有事件记录到控制台，修改两个 Subscription  代码，添加 `print()` 和完成事件：

```swift
// ...
subject
    .print()
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
// ...
subject
    .print()
    .sink(receiveValue: { print("Second subscription: ", $0) })
    .store(in: &subscriptions)

subject.send(completion: .finished)
复制代码
```

再次运行 Playground，我们将看到整个示例的以下输出：

```yaml
receive subscription: (CurrentValueSubject)
request unlimited
receive value: (0)
0
receive value: (1)
1
receive value: (2)
2
2
receive value: (3)
3
3
receive subscription: (CurrentValueSubject)
request unlimited
receive value: (3)
Second subscription:  3
receive finished
receive finished
复制代码
```

## 动态调整 demand

我们之前了解到，在 `Subscriber.receive(_:)` 中调整 demand 是累加的。 我们可以在更详细的示例中仔细研究它是如何工作的。 清理 Playground 并添加新示例：

```swift
final class IntSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value", input)
        switch input {
        case 1:
            return .max(2)
        case 3:
            return .max(1)
        default:
            return .none 
        }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion", completion)
    }
}

let subscriber = IntSubscriber()
let subject = PassthroughSubject<Int, Never>()
subject.subscribe(subscriber)
subject.send(1)
subject.send(2)
subject.send(3)
subject.send(4)
subject.send(5)
subject.send(6)
subject.send(6)
复制代码
```

大部分代码与之前的示例类似，我们将专注于 `receive(_:)` 方法：

1. 收到值 1，新的最大值为 4（2 + 2）；
2. 收到值 3，新的最大值为 5（4 + 1）；
3. 最大值维持 5。

运行 Playground，我们将看到以下内容：

```
Received value 1
Received value 2
Received value 3
Received value 4
Received value 5
复制代码
```

正如预期的那样，只打印了五个值，没有打印出第六个值。

## 类型擦除

有时我们希望让 Subscriber 订阅来自 Publisher 的事件，而限制访问有关该 Publisher 的其他信息。清理并添加新的代码在 Playground 中：

```swift
var subscriptions = Set<AnyCancellable>()
let subject = PassthroughSubject<Int, Never>()
let publisher = subject.eraseToAnyPublisher()
publisher
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
subject.send(0)
复制代码
```

我们创建一个 `PassthroughSubject`，从 `subject` 创建一个类型擦除的 Publisher `publisher`。订阅类型擦除的 `publisher`。通过 `subject` 发送新值。

`publisher` 的的类型为 `AnyPublisher<Int, Never>`。`AnyPublisher` 是符合 `Publisher` 协议的类型擦除结构。类型擦除允许我们隐藏可能不想向 Subscriber 或下游 Publisher 公开的 Publisher 的信息。

其实 `AnyCancellable` 也是一个符合 `Cancellable` 的类型擦除类，它允许调用者取消 Subscription，而无需访问底层 的 Subscription 来执行其他操作。`eraseToAnyPublisher()` Operator 将实际的 Publisher 包装在 `AnyPublisher` 的实例中，隐藏 Publisher 是 `PassthroughSubject`  类的事实。

`AnyPublisher` 没有 `send(_:)`  方法，因此我们不能直接向该发布者添加新值。当我们想要使用一对 Public 和 Private 属性时，允许这些属性的所有者在 Private Publisher 上发送值，外部调用者只订阅但不能发送值。

如果我们将上述代码中的 `subject.send(0)` 替换为 `publisher.send(0)`，代码将提示错误：

```bash
Value of type 'AnyPublisher<Int, Never>' has no member 'send'
复制代码
```

## 桥接 Combine Poblisher 到 async/await

在 iOS 15 和 macOS 12 中，Swift 5.5 中的 Combine 框架新增了两个很棒的功能，帮助我们轻松地将 Combine 与 Swift 中的 async/await 语法结合使用。

清理并添加新的代码在 Playground 中：

```swift
import Foundation
import Combine
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let subject = CurrentValueSubject<Int, Never>(0)
Task {
    for await element in subject.values {
        print("Element: \(element)")
    }
    print("Completed.")
}
subject.send(1)
subject.send(2)
subject.send(3)
subject.send(completion: .finished)

复制代码
```

在此示例中，我们使用 `CurrentValueSubject`，同样，API 可用于任何符合 `Publisher `的类型。

Task 创建一个新的异步任务，闭包内的代码将异步运行。我们使用 for 循环来迭代这些元素的异步序列，一旦发布者完成，无论是成功还是失败，循环都会结束。

再次运行 Playground 代码，我们将看到以下输出：

```makefile
Element: 0
Element: 1
Element: 2
Element: 3
Completed.
复制代码
```

## 内容参考

- [Combine | Apple Developer Documentation](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fcombine)；
- 来自 [Kodeco](https://link.juejin.cn?target=https%3A%2F%2Fwww.kodeco.com%2Fios%2Fbooks) 的书籍《Combine: Asynchronous Programming with Swift》；
- 对上述  [Kodeco](https://link.juejin.cn?target=https%3A%2F%2Fwww.kodeco.com%2Fios%2Fbooks)  书籍的汉语自译版 [《Combine: Asynchronous Programming with Swift》](https://link.juejin.cn?target=https%3A%2F%2Flayers-organization-1.gitbook.io%2Fcombine-asynchronous-programming-with-swift%2Fgroup-1%2Fdi-yi-bu-fen-combine-jian-jie)整理。



作者：Layer
链接：https://juejin.cn/post/7170711332608540703
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。