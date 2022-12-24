//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// last 的工作方式与 first 完全相同，只是它发出发布者发出的最后一个值。 这意味着它也是贪婪的，必须等待上游发布者完成
example(of: "last") {
    
    // 1 创建一个将发出三个字母并完成的发布者
    let publisher = ["A", "B", "C"].publisher
    
    // 2 使用 last 操作符只发出最后发布的值并打印出来
    publisher
        .print("publisher")
        .last()
        .sink(receiveValue: { print("Last value is \($0)") })
        .store(in: &subscriptions)
    
    // last 等待上游发布者发送一个 .finished 完成事件，此时它向下游发送最后一个发出的值，以便在接收器中打印出来。
    // 注意：与 first 完全一样，last 也有一个 last(where:) 重载，它发出匹配指定条件的发布者发出的最后一个值
}

//: [Next](@next)
