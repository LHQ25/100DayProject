//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {

    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// Future 可以用于异步生成单个结果然后完成
example(of: "Future") {
    
    // 创建了一个返回 Int 和 Never 类型的 future 的工厂函数； 意思是，它将发出一个整数并且永远不会失败
    func futureIncrement(integer: Int, afterDelay delay: TimeInterval) -> Future<Int, Never> {
        Future<Int, Never> { promise in
            print("Original")
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(integer + 1))
            }
        }
    }
    
    // 1 使用你之前创建的工厂函数创建一个未来，指定在三秒延迟后递增你传递的整数
    let future = futureIncrement(integer: 1, afterDelay: 3)
    // 2 订阅并打印接收到的值和完成事件，并将生成的订阅存储在订阅集中
    future.sink(receiveCompletion: {
        print($0)
    }, receiveValue: {
        print($0)
    })
    .store(in: &subscriptions)
    
    future.sink(receiveCompletion: {
        print("Second", $0)
    },  receiveValue: {
        print("Second", $0)
    }).store(in: &subscriptions)
}

//: [Next](@next)
