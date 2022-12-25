//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// max 的工作方式与 min 完全相同，只是它找到了发布者发出的最大值

example(of: "max") {
    
    // 1 创建一个发出四个不同字母的发布者
    let publisher = ["A", "F", "Z", "E"].publisher
    
    // 2 使用 max 操作符找出数值最高的字母并打印出来
    publisher
        .print("publisher")
        .max()
        .sink(receiveValue: { print("Highest value is \($0)") })
        .store(in: &subscriptions)
    
    // 与 min 完全一样，max 是贪婪的，必须等待上游发布者完成其值的发送，然后才能确定最大值。 在这种情况下，该值为 Z。
    // 注意：与 min 完全一样，max 也有一个伴随的 max(by:) 操作符，它接受一个谓词来确定在 non-Comparable 值中发出的最大值。
}

//: [Next](@next)
