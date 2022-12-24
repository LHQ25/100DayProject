//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

// 可以将多个订阅存储在 AnyCancellable 的集合中，而不是将每个 subscription 存储为一个值。 然后，该集合将在集合 deinit 之前自动取消添加到其中的每个 subscription

example(of: "CurrentValueSubject") {
    // 1 创建 subscription set
    var subscriptions = Set<AnyCancellable>()
    // 2 创建类型为 Int 和 Never 的 CurrentValueSubject。 这将发布整数并且永远不会发布错误，初始值为 0
    let subject = CurrentValueSubject<Int, Never>(0)
    // 3 创建 subject 的 subscription 并打印从 subject 接收到的值
    subject
        .print()
        .sink(receiveValue: {
        print($0)
    })
    .store(in: &subscriptions)
    // 4 将 subscription 存储在 subscription set 中（作为 inout 参数而不是 copy 传递）
    
    // 发送两个新值
    subject.send(1)
    subject.send(2)
    
    // 与 PassthroughSubject 不同，你可以随时向当前 subject 询问其 value
    print(subject.value)
    
    // 在当前值主题上调用 send(_:) 是发送新值的一种方法。 另一种方法是为其 value 属性分配一个新值
    subject.value = 3
    print(subject.value)
    
    subject
        .print()
        .sink(receiveValue: {
        print("Second subscription:", $0)
    })
    .store(in: &subscriptions)
    
    // 两个订阅都接收完成事件而不是取消事件。
    // 由于它们已经完成，你不再需要取消它们
    subject.send(completion: .finished)
}

//: [Next](@next)
