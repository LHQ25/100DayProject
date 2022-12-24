//: [Previous](@previous)

import Foundation
import Combine
import UIKit

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()


// combineLatest 是另一个允许你组合不同发布者的操作符。 它还允许你组合不同价值类型的发布者，这非常有用。 但是，它不是交错所有发布者的排放，而是在所有发布者发出值时发出一个包含所有发布者的最新值的元组。
// 但是有一个问题：原始发布者和传递给 combineLatest 的每个发布者必须至少发出一个值，然后 combineLatest 本身才会发出任何内容
example(of: "combineLatest") {
    
    // 1 创建两个 PassthroughSubjects。 第一个接受没有错误的整数，而第二个接受没有错误的字符串
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    // 2 将 publisher2 的最新排放量与 publisher1 结合起来。 你可以使用不同的 combineLatest 重载组合最多四个不同的发布者
    publisher1
        .combineLatest(publisher2)
        .sink(            receiveCompletion: { _ in print("Completed") },            receiveValue: { print("P1: \($0), P2: \($1)") }        )
        .store(in: &subscriptions)
    
    // 3 将 1 和 2 发送到 publisher1，然后将“a”和“b”发送到 publisher2，然后将 3 发送到 publisher1，最后将“c”发送到 publisher2
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send("a")
    publisher2.send("b")
    publisher1.send(3)
    publisher2.send("c")
    
    // 4
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
    
    // 你可能会注意到从 publisher1 发出的 1 永远不会通过 combineLatest 推送。 这是因为 combineLatest 只有在每个发布者发出至少一个值时才开始发出组合。
    // 在这里，这个条件只有在 "a" 发射后才成立，此时来自 publisher1 的最新发射值是 2。这就是为什么第一个发射是 (2, "a")
}

//: [Next](@next)
