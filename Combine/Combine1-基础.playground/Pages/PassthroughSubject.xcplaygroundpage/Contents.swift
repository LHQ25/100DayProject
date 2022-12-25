//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

// Subject 充当中间人，使非 Combine 命令式代码能够向 Combine 订阅者发送值
example(of: "PassthroughSubject") {
    // 1 定义自定义错误类型
    enum MyError: Error {
        case test
    }
    
    // 2 定义一个接收字符串和 MyError 错误的自定义订阅者
    final class StringSubscriber: Subscriber {
        
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }
        
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            // 3 根据收到的值调整需求, 当输入为“World”时，在 receive(_:) 中返回 .max(1) 会导致新的最大值设置为 3（原始最大值加 1）
            return input == "World" ? .max(1) : .none
        }
        
        func receive(completion: Subscribers.Completion<MyError>) {
            print("Received completion", completion)
        }
    }
    
    // 4 创建自定义订阅者的实例
    let subscriber = StringSubscriber()
    
    // 5 创建一个 String 类型的 PassthroughSubject 实例和你定义的自定义错误类型。
    let subject = PassthroughSubject<String, MyError>()
    // 6 为订阅者订阅 subject
    subject.subscribe(subscriber)
    // 7 使用 sink 创建另一个订阅
    let subscription = subject.sink(receiveCompletion: { completion in
        print("Received completion (sink)", completion)
    }, receiveValue: { value in
        print("Received value (sink)", value)
        
    })
    
    subject.send("Hello")
    subject.send("World")
    
    // 8 取消第二次订阅
    subscription.cancel()
    // 9 发送另一个值
    subject.send("Still there?")
    
    // 只有第一个订阅者会收到该值。 发生这种情况是因为你之前取消了第二个订阅者的订阅
    
    // 第一个订阅者收到错误，但没有收到错误后发送的完成事件。
    // 这表明，一旦发布者发送了一个 completion 事件——无论是正常完成还是错误——它就完成了。
    // 使用 PassthroughSubject 传递值是将命令式代码连接到 Combine 的声明性世界的一种方式
    // subject.send(completion: .failure(MyError.test))
    
    subject.send(completion: .finished)
    subject.send("How about another one?")
    // 第二个订阅者没有收到“How about another one?”值，因为它在 subject 发送值之前收到了 completion 事件。第一个订阅者没有收到完成事件或值，因为它的订阅之前被取消了
}

//: [Next](@next)
