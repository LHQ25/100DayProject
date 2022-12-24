//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// count 操作符将发出单个值 - 一旦发布者发送 .finished 完成事件，上游发布者发出的值的数量
example(of: "count") {
    
    // 1 创建一个发出三个字母的发布者
    let publisher = ["A", "B", "C"].publisher
    // 2 使用 count() 发出单个值，指示上游发布者发出的值的数量
    publisher
        .print("publisher")
        .count()
        .sink(receiveValue: { print("I have \($0) items") })
        .store(in: &subscriptions)
    
    // 只有在上游发布者发送 .finished 完成事件后才会打印出值 3
}

//: [Next](@next)
