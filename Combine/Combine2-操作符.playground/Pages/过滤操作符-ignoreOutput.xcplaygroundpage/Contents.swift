//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()
example(of: "ignoreOutput -> 忽略(Ignoring values)") {
    
    // 1 创建一个发布者，从 1 到 10,000 发出 10,000 个值
    let numbers = (1...10_000).publisher
    
    // 2 添加 ignoreOutput 操作符，它会忽略所有值，只向消费者发出完成事件
    numbers
    .ignoreOutput()
    .sink(receiveCompletion: {
        print("Completed with: \($0)")
    }, receiveValue: { print($0) })
    .store(in: &subscriptions)
    
}

//: [Next](@next)
