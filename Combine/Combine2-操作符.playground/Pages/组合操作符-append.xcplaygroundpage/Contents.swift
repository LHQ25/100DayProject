//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

/*
 追加(Appending)
 下一组操作符处理将发布者发出的事件与其他值连接起来。 但在这种情况下，你将使用 append(Output...)、append(Sequence) 和 append(Publisher) 处理追加而不是前置。 这些操作符的工作方式与它们的前置操作符类似。
 append(Output...)
 append(Output...) 的工作方式与它的 prepend 对应的类似：它也接受一个 Output 类型的可变参数列表，然后在原始发布者完成 .finished 事件后，附加在 .finished 前
 */

example(of: "append(Output...)") {
    
    // 1 创建一个只发出一个值的发布者：1
    let publisher = [1].publisher
    
    // 2 使用 append 两次，第一次追加 2 和 3，然后追加 4
    publisher
        .append(2, 3)
        .append(4)
        .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
    
}

example(of: "append(Output...) #2") {
    
    // 1 publisher 现在是一个 PassthroughSubject，它允许你手动向它发送值
    let publisher = PassthroughSubject<Int, Never>()
    publisher
        .append(3, 4)
        .append(5)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 2 你将 1 和 2 发送到 PassthroughSubject
    publisher.send(1)
    publisher.send(2)
    
    // 追加的工作方式与你期望的完全一样，每个追加都等待上游完成，然后再添加自己的工作。
    // 这意味着上游必须完成，否则追加永远不会发生，因为 Combine 无法知道先前的发布者已经完成了其所有值的发送
    publisher.send(completion: .finished)
}

example(of: "append(Publisher)") {
    
    // 1 创建两个发布者，第一个发出 1 和 2，第二个发出 3 和 4
    let publisher1 = [1, 2].publisher
    let publisher2 = [3, 4].publisher
    
    // 2 将 publisher2 附加到 publisher1，因此 publisher2 中的所有值一旦完成就会附加在publisher1 的末尾
    publisher1
        .append(publisher2)
        .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
    
}

//: [Next](@next)
