import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

//let can =

example(of: "Just") {
    // 1 使用 Just 创建发布者，它允许你从单个值创建发布者。
    let just = Just("Hello world!")
    // 2 创建对发布者的订阅并为每个接收到的事件打印一条消息。
    _ = just.sink(receiveCompletion: {
        print("Received completion", $0)
    },receiveValue: {
        print("Received value", $0)
    })
}
