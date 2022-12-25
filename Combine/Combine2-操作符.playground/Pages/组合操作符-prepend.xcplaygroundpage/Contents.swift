//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 前置(Prepending)
// 在这里开始使用一组操作符，这些操作符都是关于在发布者开头添加值的。换句话说，你将使用它们在原始发布者发出任何值之前添加值

example(of: "prepend(Output...)") {
    
    // 1 创建一个发布数字 3 4 的发布者
    let publisher = [3, 4].publisher
    
    // 2 使用 prepend 在发布者自己的值之前添加数字 1 和 2
    publisher
        .prepend(1, 2)
        .prepend(-1, 0) // 操作符是可链接的,这意味着你可以轻松添加多个前置
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
}

example(of: "prepend(Sequence)") {
    
    // 1 创建一个发布数字 5、6 和 7 的发布者
    let publisher = [5, 6, 7].publisher
    
    // 2 链接 prepend(Sequence) 两次到原始发布者。 一次从数组中添加值，第二次从集合中添加值
    publisher
        .prepend([3, 4])
        .prepend(Set(1...2)) // 与数组相反，要记住关于 Set 的一个重要事实是它们是无序的，因此不能保证项目发出的顺序。 这意味着上例中的前两个值可以是 1 和 2，也可以是 2 和 1
        .prepend(stride(from: 6, to: 11, by: 2))  // 创建了一个 Strideable，它允许你以 2 为步长在 6 和 11 之间跨步。由于 Strideable 符合 Sequence，你可以在 prepend(Sequence) 中使用它
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
}

example(of: "prepend(Publisher)") {
    
    // 1 创建两个发布者。 一个发出数字 3 和 4，第二个发出 1 和 2
    let publisher1 = [3, 4].publisher
    let publisher2 = [1, 2].publisher
    
    // 2 将 publisher2 添加到 publisher1 的开头。 只有在 publisher2 发送 .finished 完成事件后，publisher1 才会开始执行其工作并发出事件
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
}

example(of: "prepend(Publisher) #2") {
    
    // 1 创建两个发布者。 第一个发出值 3 和 4，而第二个是可以动态接受值的 PassthroughSubject
    let publisher1 = [3, 4].publisher
    let publisher2 = PassthroughSubject<Int, Never>()
    
    // 2 在 publisher1 之前添加主题
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 3 通过主题 publisher2 发送值 1 和 2
    publisher2.send(1)
    publisher2.send(2)
    
    // 前置发布者必须完成，以便 Combine 知道是时候切换到 publisher1 发布者了
    publisher2.send(completion: .finished)
}

//: [Next](@next)
