//: [Previous](@previous)

import Foundation
import Combine


public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 它允许你提供种子值和累加器闭包。 该闭包接收累积值（从种子值开始）和当前值。 从该闭包中，你返回一个新的累积值。 一旦操作员收到 .finished 完成事件，它就会发出最终的累积值
example(of: "reduce") {
    
    // 1 创建一个发出六个字符串的发布者
    let publisher = ["Hel", "lo", " ", "Wor", "ld", "!"].publisher
    publisher
        .print("publisher")
//        .reduce("") { accumulator, value in
//            // 2 将 reduce 与空字符串一起使用，将发出的值附加到它以创建最终的字符串结果
//            accumulator + value
//        }
        .reduce("", +) // reduce 的第二个参数是一个闭包，它接受两个某种类型的值并返回一个相同类型的值。 在 Swift 中，+ 也是一个匹配该签名的函数
    .sink(receiveValue: { print("Reduced into: \($0)") })
    .store(in: &subscriptions)
    
    // 注意累积的结果——Hello World！ — 仅在上游发布者发送 .finished 完成事件后打印
}

//: [Next](@next)
