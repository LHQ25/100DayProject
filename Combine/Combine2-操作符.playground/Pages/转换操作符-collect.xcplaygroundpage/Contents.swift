//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

// collect 操作符提供了一种方便的方法来将来自发布者的单值流转换为单个数组
example(of: "collect") {
    
    var subscriptions = Set<AnyCancellable>()
    
    // 会看到每个值都出现在单独的行上，后面跟着一个完成事件
    ["A", "B", "C", "D", "E"].publisher
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
    
    // sink 接收到单个数组值, 后是完成事件
    ["A", "B", "C", "D", "E"].publisher
        .collect()
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
    
    // 注意：在使用 collect() 和其他不需要指定计数或限制的缓冲操作符时要小心。
    // 它们将使用无限量的内存来存储接收到的值，因为它们不会在上游完成之前发出
    
    // 指定你只希望接收最多一定数量的值，从而有效地将上游切割成“批次”
    // 最后一个值 E 也是一个数组。这是因为上游发布者在 collect 填满其规定的缓冲区之前就完成了，所以它将剩余的所有内容作为数组发送
    ["A", "B", "C", "D", "E"].publisher
        .collect(2)
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
    
}

//: [Next](@next)
