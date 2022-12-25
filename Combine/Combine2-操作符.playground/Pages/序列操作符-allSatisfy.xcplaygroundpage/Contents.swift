//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// allSatisfy 接受一个闭包条件并发出一个布尔值，指示上游发布者发出的所有值是否与该谓词匹配。 它是贪婪的，因此会等到上游发布者发出 .finished 完成事件

example(of: "allSatisfy") {
    
    // 1 创建一个以 2 为步长（即 0、2 和 4）发出 0 到 5 之间的数字的发布者
    let publisher = stride(from: 0, to: 5, by: 2).publisher
    // let publisher = stride(from: 0, to: 5, by: 1).publisher  //在这种情况下，一旦发出 1，条件就不再通过，所以 allSatisfy 发出 false 并取消订阅
    
    // 2 使用 allSatisfy 检查是否所有发出的值都是偶数，然后根据发出的结果打印适当的消息
    publisher
        .print("publisher")
        .allSatisfy { $0 % 2 == 0 }  // 由于所有值确实是偶数，因此在上游发布者发送 .finished 完成后，操作符会发出 true ，并打印出适当的消息。但是，即使单个值没有通过谓词条件，操作符也会立即发出 false 并取消订阅
        .sink(receiveValue: { allEven in
            print(allEven ? "All numbers are even": "Something is odd...")
        })
        .store(in: &subscriptions)
    
    
}

//: [Next](@next)
