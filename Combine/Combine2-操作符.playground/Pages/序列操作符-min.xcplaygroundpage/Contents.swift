//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// min 操作符可让你找到发布者发出的最小值。 它是贪婪的，这意味着它必须等待发布者发送一个 .finished 完成事件。 一旦发布者完成，操作者只会发出最小值
example(of: "min") {

    // 1 创建一个发布四个不同数字的发布者
    let publisher = [1, -50, 246, 0].publisher
    
    // 2 使用 min 操作符查找发布者发出的最小数量并打印该值
    publisher
        .print("publisher")
        .min()
        .sink(receiveValue: { print("Lowest value is \($0)") })
        .store(in: &subscriptions)
    
    // Combine 怎么知道这些数字中的哪一个是最小值？ 嗯，这要归功于数值符合 Comparable 协议。你可以在发出 Comparable-conforming 类型的发布者上直接使用 min() ，无需任何参数
    
}

example(of: "min non-Comparable") {
    
    // 1 你创建一个发布者，该发布者发出三个从各种字符串创建的 Data 对象
    let publisher = ["12345", "ab", "hello world"]
        .map { Data($0.utf8) }
        // [Data]
        .publisher // Publisher<Data, Never>
    
    // 2 由于 Data 不符合 Comparable，因此使用 min(by:) 操作符查找字节数最少的 Data 对象
    publisher
        .print("publisher")
        .min(by: { $0.count < $1.count })
        .sink(receiveValue: { data in
            // 3 将最小的 Data 对象转换回字符串并打印出来
            let string = String(data: data, encoding: .utf8)!
            print("Smallest data is \(string), \(data.count) bytes")
        })
    .store(in: &subscriptions)
    
    // 值不符合 Comparable 会发生什么？ 幸运的是，你可以使用 min(by:) 操作符提供自己的比较器闭包。
}

//: [Next](@next)
