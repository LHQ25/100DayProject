//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "first()") {
    
    // 1 创建一个新的发布者，发布从 1 到 9 的数字
    let numbers = (1...9).publisher
    
    // 2 使用 first() 操作符查找第一个发出的
    numbers
        .print("numbers")
        .first()
        .sink(receiveCompletion: {
            print("Completed with: \($0)")
        }, receiveValue: {
            print($0)
        })
    .store(in: &subscriptions)
    
}

example(of: "first(where:)") {
    
    // 它是 lazy 的，意思是：它只取所需的值，直到找到与你提供的谓词匹配的值。 一旦找到匹配项，它就会取消订阅并完成
    
    // 1 创建一个新的发布者，发布从 1 到 9 的数字
    let numbers = (1...9).publisher
    
    // 2 使用 first(where:) 操作符查找第一个发出的偶数值
    numbers
        .print("numbers")
        .first(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: {
            print("Completed with: \($0)")
        }, receiveValue: {
            print($0)
        })
    .store(in: &subscriptions)
    
}

//: [Next](@next)
