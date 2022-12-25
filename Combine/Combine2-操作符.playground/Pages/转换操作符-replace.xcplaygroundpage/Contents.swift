//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()
// Combine 还包括一个操作符，当你希望始终提供价值时可以使用该操作符

example(of: "replaceNil") {
    // 1 从可选字符串数组创建发布者
    ["A", nil, "C"].publisher
        .eraseToAnyPublisher()
        .replaceNil(with: "-")
        // 2 使用 replaceNil(with:) 将来自上游发布者的 nil 值替换为新的非 nil 值
        .sink(receiveValue: { print($0) })
        // 3 打印出数值
        .store(in: &subscriptions)
    
    // 注意：replaceNil(with:) 有重载，这会使 Swift 为用例类型进行错误的猜测。这导致类型保留为 Optional<String> 而不是完全展开。 上面的代码使用 eraseToAnyPublisher() 来解决该错误
    
}


// 如果发布者完成了但没有发出一个值，你可以使用 replaceEmpty(with:) 操作符来替换——或者插入一个值
example(of: "replaceEmpty(with:)") {
    
    // 1 创建一个立即发出完成事件的空发布者
    let empty = Empty<Int, Never>()
    // 2 订阅它，并打印收到的事件
    empty
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
    // 使用 Empty 发布者类型创建立即发出 .finished 完成事件的发布者。 你还可以通过将 false 传递给其 completeImmediately 参数来将其配置为从不发出任何内容，默认情况下为 true。 此发布者可用于演示或测试目的，或者当你只想向订阅者发送完成某些任务的信号时
    
    empty
        .replaceEmpty(with: 1)
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
}

//: [Next](@next)
