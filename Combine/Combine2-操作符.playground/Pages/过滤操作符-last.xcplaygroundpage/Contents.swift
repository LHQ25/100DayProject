//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "last()") {
    
    // 你还可以使用 first() 和 last() 操作符来简单地获取发布者发出的第一个或最后一个值。 这些人也分别是 lazy 和贪婪的
    // 它是 lazy 的，意思是：它只取所需的值，直到找到与你提供的谓词匹配的值。 一旦找到匹配项，它就会取消订阅并完成
    
    // 1 创建一个新的发布者，发布从 1 到 9 的数字
    let numbers = (1...9).publisher
    
    // 2 使用 last() 操作符查找最后发出的
    numbers
        // .print("numbers")
        .last()
        .sink(receiveCompletion: {
            print("Completed with: \($0)")
        }, receiveValue: {
            print($0)
        })
    .store(in: &subscriptions)
    
}

example(of: "last(where:)") {
    
    // 它是 lazy 的，意思是：它只取所需的值，直到找到与你提供的谓词匹配的值。 一旦找到匹配项，它就会取消订阅并完成
    
    // 1 创建一个新的发布者，发布从 1 到 9 的数字
    let numbers = (1...9).publisher
    
    // 2 使用 last(where:) 操作符查找最后发出的偶数值
    numbers
        // .print("numbers")
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: {
            print("Completed with: \($0)")
        }, receiveValue: {
            print($0)
        })
    .store(in: &subscriptions)
    
}

example(of: "last(where:)") {
    
    // 因为操作符无法知道发布者是否会发出与下一行的条件匹配的值，因此操作符必须知道发布者的全部范围，然后才能确定与条件匹配的最后一个项目
    
    let numbers = PassthroughSubject<Int, Never>()
    
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: {
            print("Completed with: \($0)") }, receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    numbers.send(1)
    numbers.send(2)
    numbers.send(3)
    numbers.send(4)
    numbers.send(5)
    
    // 由于发布者永远不会完成，因此无法确定匹配条件的最后一个值
    // 要解决此问题，请将以下内容添加为示例的最后一行，PassthroughSubject 发送完成：
    numbers.send(completion: .finished)
}

//: [Next](@next)
