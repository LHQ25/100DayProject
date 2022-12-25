//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 删除值是你在与发布者合作时经常需要的功能。例如，当你想忽略来自一个发布者的值直到第二个发布者开始发布时，或者如果你想在流开始时忽略特定数量的值
example(of: "dropFirst") {
    
    // 1 创建一个发布者，它发出 10 个介于 1 和 10 之间的数字
    let numbers = (1...10).publisher
    
    // 2 使用 dropFirst(8) 删除前八个值，只打印 9 和 10
    numbers
    .dropFirst(8)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "drop(while:)") {
    
    // 1 创建一个发出 1 到 10 之间数字的发布者
    let numbers = (1...10).publisher
    
    // 2 使用 drop(while:) 等待可以被 5 整除的第一个值。 一旦满足条件，值将开始流经操作符并且不会再被删除
    numbers
        .drop(while: {
            print("x")
            return $0 % 5 != 0
        })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
}

example(of: "drop(untilOutputFrom:)") {
    
    // 1 创建两个你可以手动发送值的 PassthroughSubjects。 第一个是 isReady 而第二个代表用户的点击
    // 第一行表示 isReady 流，第二行表示用户通过 drop(untilOutputFrom:) 进行的点击，它以 isReady 作为参数
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2 使用 drop(untilOutputFrom: isReady) 忽略用户的任何点击，直到 isReady 发出至少一个值
    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 3 通过 subject 发送五个“点击”，就像上图一样。 第三次点击后，你发送 isReady 一个值
    (1...5).forEach { n in
        taps.send(n)
        if n == 3 {
            isReady.send()
        }
    }

}

//: [Next](@next)
