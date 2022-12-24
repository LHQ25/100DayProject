//: [Previous](@previous)

import Foundation
import Combine

// 每次向队列添加新操作时，它的 operationCount 都会增加，并且你的接收器会收到新的计数。当队列消耗了一个 operation 时，计数会减少，并且你的接收器会再次收到更新的计数。
// 还有许多其他框架类公开了符合 KVO 的属性。 只需将 publisher(for:) 与 KVO 兼容属性的关键路径一起使用，你将获得一个能够发出值变化的发布者
let queue = OperationQueue()
let subscription = queue.publisher(for: \.operationCount)
    .sink {
        print("Outstanding operations in queue: \($0)")
    }


// 2. 准备和订阅自己的 KVO 兼容属性
/*
 你还可以在自己的代码中使用 Key-Value Observing，前提是：
 你的对象是类（不是结构）并且符合 NSObject，
 使用 @objc 动态属性标记属性以使其可观察。
 完成此操作后，你标记的对象和属性将与 KVO 兼容，并且可以使用 Combine！
 
 注意：虽然 Swift 语言不直接支持 KVO，但将属性标记为 @objc dynamic 会强制编译器生成触发 KVO 机制的隐藏方法。 描述这种机器超出了本书的范围。 可以说该机制严重依赖 NSObject 协议中的特定方法，这解释了为什么你的对象需要遵守它。
 */

// 1 创建一个符合 NSObject 协议的类。这是 KVO 所必需的
class TestObject: NSObject {
    
    // 2 将你想要使其可观察的任何属性标记为 @objc 动态
    @objc dynamic var integerProperty: Int = 0
    
    @objc dynamic var stringProperty: String = ""
    @objc dynamic var arrayProperty: [Float] = []
}

let obj = TestObject()
// 3 创建并订阅观察 obj 的 integerProperty 属性的发布者
let subscription2 = obj.publisher(for: \.integerProperty)
    .sink {
        print("integerProperty changes to \($0)")
    }
// 4 更新属性几次
obj.integerProperty = 100
obj.integerProperty = 200

// .prior 在发生更改时发出先前的值和新的值
let subscription3 = obj.publisher(for: \.stringProperty, options: [.prior])
    .sink {
        print("stringProperty changes to \($0)")
    }

// .old 和 .new 在此发布者中未使用，它们都什么都不做（只是让新值通过）
let subscription4 = obj.publisher(for: \.arrayProperty, options: [.new])
    .sink {
        print("arrayProperty changes to \($0)")
    }

obj.stringProperty = "Hello"
obj.arrayProperty = [1.0]

obj.stringProperty = "World"
obj.arrayProperty = [1.0, 2.0]


// 2. Observation options
/*
 你调用以观察更改的方法的完整签名是 publisher(for:options:)。 options 参数是一个具有四个值的选项集：.initial、.prior、.old 和 .new。 默认值为 [.initial]，这就是为什么你会看到发布者在发出任何更改之前发出初始值。 以下是选项的细分：
 .initial 发出初始值。
 .prior 在发生更改时发出先前的值和新的值。
 .old 和 .new 在此发布者中未使用，它们都什么都不做（只是让新值通过）
 */


// 3. ObservableObject
// Combine 的 ObservableObject 协议适用于 Swift 对象，而不仅仅适用于派生自 NSObject 的对象。
// 它与 @Published 属性包装器合作，帮助你使用编译器生成的 objectWillChange 发布者创建类
class MonitorObject: ObservableObject {
    
    @Published var someProperty = false
    @Published var someOtherProperty = ""
    
}

let object = MonitorObject()
let subscription5 = object.objectWillChange.sink {
    print("object will change")
}
let subscription6 = object.$someProperty.sink { v in
    print("object will change \(v)")
}
object.someProperty = true
// ObservableObject 协议一致性使编译器自动生成 objectWillChange 属性。 它是一个 ObservableObjectPublisher，它发出 Void 项目并且永不失败。
// 每次对象的 @Published 变量之一发生更改时，都会触发 objectWillChange。 不幸的是，你无法知道实际更改了哪个属性。 这旨在与 SwiftUI 很好地配合使用，它可以合并事件以简化屏幕更新。

//: [Next](@next)
