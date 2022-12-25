//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "collect - > 以指定的时间间隔从发布者那里收集值。这是一种很有用的缓冲形式") {
    
    let valuesPerSecond = 1.0
    let collectTimeStride = 4
    
    // 1 设置源发布者——一个将传递 Timer 发出的值的 PassthroughSubject
    let sourcePublisher = PassthroughSubject<Int, Never>()
    
    // 2 创建一个 collectedPublisher，它使用 collect 操作符收集它在 collectTimeStride 跨步期间接收到的值。 操作符将这些值组作为数组发送到指定的调度程序：DispatchQueue.main
    let collectedPublisher = sourcePublisher.collect(.byTime(DispatchQueue.main, .seconds(collectTimeStride)))
    
    collectedPublisher.sink(receiveCompletion: { v in
        print("receiveCompletion : \(v)")
    }) { v in
        print(v)
    }
    .store(in: &subscriptions)
    
    sourcePublisher.send(1)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        sourcePublisher.send(3)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        sourcePublisher.send(5)
    }
    
    // 不能完成，否则无法搜集到后面的值
    // sourcePublisher.send(completion: .finished)
}

//: [Next](@next)
