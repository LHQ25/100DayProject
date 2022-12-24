//: [Previous](@previous)

import Foundation
import Combine
import UIKit

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

/*
 该操作符的工作方式类似，在相同索引中发出成对值的元组。 它等待每个发布者发出一个项目，然后在所有发布者在当前索引处发出一个值后发出一个项目元组。
 这意味着如果你压缩两个发布者，每次两个发布者发出一个新值时，你都会得到一个元组
 */

example(of: "zip") {
    
    // 1 创建两个 PassthroughSubject，第一个接受整数，第二个接受字符串。 两者都不能发出错误
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    // 2 将 publisher1 与 publisher2 压缩，一旦它们各自发出一个新值，就将它们的发射配对
    publisher1
        .zip(publisher2)
        .sink(receiveCompletion: { _ in
            print("Completed") }, receiveValue: { print("P1: \($0), P2: \($1)") })
        .store(in: &subscriptions)
    
    // 3 将 1 和 2 发送到 publisher1，然后将“a”和“b”发送到 publisher2，然后将 3 再次发送到 publisher1，最后将“c”和“d”发送到 publisher2
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send("a")
    publisher2.send("b")
    publisher1.send(3)
    publisher2.send("c")
    publisher2.send("d")
    
    // 4 完成 publisher1 和 publisher2
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
    
}

//: [Next](@next)
