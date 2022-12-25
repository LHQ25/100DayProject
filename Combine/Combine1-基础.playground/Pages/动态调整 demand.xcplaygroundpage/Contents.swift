//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

example(of: "Dynamically adjusting Demand") {
    
    final class IntSubscriber: Subscriber {
        typealias Input = Int
        typealias Failure = Never
        
        func receive(subscription: Subscription) {
            subscription.request(.max(2)) // 原始值
        }
        
        // 之前了解到，在 Subscriber.receive(_:) 中调整需求是累加的。 你现在可以在更详细的示例中仔细研究它是如何工作的
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value", input)
            switch input {
            case 1:
                return .max(2)
                // 1 新的最大值为 4（原始最大值为 2 + 新最大值为 2）
            case 3:
                return .max(1)
                // 2 新的最大值为 5（之前的 4 + 新的 1）
            default:
                return .none // == .max(0)
                // 3 最大值仍然是 5（之前的 4 + 新的 0）
            }
        }
        
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    
    let subscriber = IntSubscriber()
    let subject = PassthroughSubject<Int, Never>()
    subject.subscribe(subscriber)
    subject.send(1)
    subject.send(2)
    subject.send(3)
    subject.send(4)
    subject.send(5)
    subject.send(6)
}

example(of: "Type erasure") {
    
    var subscriptions = Set<AnyCancellable>()  // -> AnyCancellable 是一个符合 Cancellable 的类型擦除类，它允许调用者取消订阅，而无需访问底层 subscription 来执行其他操作
    
    // 1 创建一个 PassthroughSubject
    let subject = PassthroughSubject<Int, Never>()
    // 2 从该 Subject 创建一个类型擦除的发布者
    let publisher = subject.eraseToAnyPublisher()  // -> 它的类型为 AnyPublisher<Int, Never>, AnyPublisher 是符合 Publisher 协议的类型擦除结构。 类型擦除允许你隐藏你可能不想向订阅者或下游发布者公开的发布者的详细信息
    // 3 订阅类型擦除的发布者
    publisher.sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    // 4 通过 PassthroughSubject 新值
    subject.send(0)
    
    // 当你想要对发布者使用类型擦除的一个示例是，当你想要使用一对公共和私有属性时，以允许这些属性的所有者在私有发布者上发送值，并让外部调用者只订阅但不能发送值。
    // AnyPublisher 没有 send(_:) 运算符，因此你不能直接向该发布者添加新值。
    // eraseToAnyPublisher() 运算符将提供的发布者包装在 AnyPublisher 的实例中，隐藏发布者实际上是 PassthroughSubject 的事实。 这也是必要的，因为你不能专门化 Publisher 协议，例如，你不能将类型定义为 Publisher<UIImage, Never>。
    
    // publisher.send(1)  // 报错
    
}

//: [Next](@next)
