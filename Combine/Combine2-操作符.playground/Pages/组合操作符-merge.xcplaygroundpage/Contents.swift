//: [Previous](@previous)

import Foundation
import Combine
import UIKit

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "merge(with:)") {
    
    // 1 创建两个 PassthroughSubjects 接受和发出整数值并且不会发出错误
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    // 2 将 publisher1 与 publisher2 合并，将两者发出的值交错。 组合提供重载，可让你合并多达八个不同的发布者
    publisher1
        .merge(with: publisher2)
        .sink(receiveCompletion: { _ in
            print("Completed")
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
    
    // 3 将 1 和 2 添加到 publisher1，然后将 3 添加到 publisher2，然后再次将 4 添加到 publisher1，最后将 5 添加到 publisher2
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send(3)
    publisher1.send(4)
    publisher2.send(5)
    
    // 4 你向发布者 1 和发布者 2 发送完成事件
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
    
}

//: [Next](@next)
