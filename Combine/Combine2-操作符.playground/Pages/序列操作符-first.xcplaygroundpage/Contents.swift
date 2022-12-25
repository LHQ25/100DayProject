//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 第一个操作符类似于 Swift 的 collection 的 first 属性，它让第一个发出的值通过然后完成。它是惰性的，这意味着它不会等待上游发布者完成，而是会在接收到发出的第一个值时取消订阅

example(of: "first") {
    
    // 1 创建一个发出三个字母的发布者
    let publisher = ["A", "B", "C"].publisher
    
    // 2 使用 first() 只让第一个发出的值通过并打印出来
    publisher
        .print("publisher")
        .first()
        .sink(receiveValue: { print("First value is \($0)") })
        .store(in: &subscriptions)
    
    // 一旦 first() 获得发布者的第一个值，它就会取消对上游发布者的订阅。
}
    
// 寻找更精细的控制，可以使用 first(where:)。
// 就像它在 Swift 标准库中的对应物一样，它将发出与提供的条件匹配的第一个值
example(of: "first(where:)") {
    
    // 1 创建一个发出四个字母的发布者
    let publisher = ["J", "O", "H", "N"].publisher
    
    // 2 使用 first(where:) 操作符查找 Hello World 中包含的第一个字母，然后将其打印出来
    publisher
        .print("publisher")
        .first(where: { "Hello World".contains($0) })
        .sink(receiveValue: { print("First match is \($0)") })
        .store(in: &subscriptions)
    
}
    
//: [Next](@next)
