//: [Previous](@previous)

import SwiftUI
import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

// 创建自己的发布者

/*
 创建自己的发布者的复杂性从“简单”到“相当复杂”不等。对于你实现的每个操作符，你将寻求最简单的实现形式来实现你的目标。在本节中，你将了解创建自己的发布者的三种不同方法：
    在 Publisher 命名空间中使用简单的扩展方法。
    在 Publishers 命名空间中使用产生值的 Subscription 实现一个类型。
    与上面相同，但订阅会转换来自上游发布者的值。
 
 注意：从技术上讲，可以在没有自定义 Subscription 的情况下创建自定义发布者。如果你这样做，你将失去应对订阅者 demand 的能力，这使你的发布者在 Combine 生态系统中是非法的。提前取消也可能成为一个问题。这不是推荐的方法，本节将教你如何以正确的方式编写发布者
 */

// 1. 发布者作为扩展方法
// 你的首要任务是通过重用现有的操作符来实现一个简单的操作符。
// 为此，你将添加一个新的 unwrap() 操作符，它解开可选值并忽略它们的 nil 值。这将是一个非常简单的练习，因为你可以重用现有的 compactMap(_:) 操作符，它就是这样做的，尽管它需要你提供一个闭包。
// 使用新的 unwrap() 操作符将使你的代码更易于阅读，并且会使你正在做的事情变得非常清晰。读者甚至不必查看闭包的内容
extension Publisher {
    
    // 1 将自定义操作符编写为方法，最复杂的部分是签名
    func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        // 2 实现很简单：只需在 self 上使用 compactMap(_:)！
        compactMap { $0 }
    }
    
    // 最后，你将操作符限制为 Optional 类型。你可以方便地编写它以将包装的类型 T 与你的方法的泛型类型匹配......等等！
    // 注意：当开发更复杂的操作符作为方法时，例如使用操作符链时，签名会很快变得非常复杂。
    // 一个好的技巧是让你的操作符返回一个 AnyPublisher<OutputType, FailureType>。
    // 在该方法中，你将返回一个以 eraseToAnyPublisher() 结尾的发布者，以对签名进行类型擦除。
}

example(of: "Test") {
    
    let values: [Int?] = [1, 2, nil, 3, nil, 4]
    values.publisher
        .unwrap()
        .sink {
            print("Received value: \($0)")
        }
}

// 发布者发出值
// 了解了 Timer.publish()，但发现将调度队列用于定时器有点不方便。为什么不基于 Dispatch 的 DispatchSourceTimer 开发自己的计时器呢？
struct DispatchTimerConfiguration {
    
    // 1 你希望你的计时器能够在某个队列上触发，但如果你不在乎，使队列成为可选的。在这种情况下，计时器将在其选择的队列上触发
    let queue: DispatchQueue?
    // 2 计时器触发的时间间隔，从订阅时间开始
    let interval: DispatchTimeInterval
    // 3 系统可以延迟传递计时器事件的截止日期之后的最大时间量
    let leeway: DispatchTimeInterval
    // 4 你想要接收的计时器事件数。由于你正在制作自己的计时器，因此请使其灵活并能够在完成之前交付有限数量的事件
    let times: Subscribers.Demand
    
}

// 建立你的 Subscription
/*
 
 Subscription 的作用是：
    接受订阅者的初始 Demend。
    按需生成定时器事件。
    每次订阅者收到一个值并返回一个需求时，都添加到需求计数。
    确保它不会提供比配置中要求的更多的值
 */
private final class DispatchTimerSubscription<S: Subscriber>: Subscription where S.Input == DispatchTime {
    
    // 10 订阅者的配置
    let configuration: DispatchTimerConfiguration
    // 11 计时器将触发的最大次数，你从配置中复制。你将使用它作为每次发送值时递减的计数器
    var times: Subscribers.Demand
    // 12 当前 Demend；例如，订阅者请求的值的数量 - 每次发送值时都会减少它
    var requested: Subscribers.Demand = .none
    // 13 将生成定时器事件的内部 DispatchSourceTimer
    var source: DispatchSourceTimer? = nil
    // 14 订阅者。这清楚地表明，只要订阅没有完成、失败或取消，Subscription 就有责任保留订阅者
    var subscriber: S?
    
    // 初始化程序将时间设置为发布者应接收计时器事件的最大次数，如配置指定的那样。每次发布者发出事件时，此计数器都会递减。当它达到零时，计时器以完成的事件结束
    init(subscriber: S, configuration: DispatchTimerConfiguration) {
        
        self.configuration = configuration
        self.subscriber = subscriber
        self.times = configuration.times
    }
    
    // 一旦订阅者通过订阅发布者获得订阅，它必须从订阅中请求值
    // 15 这个必需的方法接收来自订阅者的请求
    func request(_ demand: Subscribers.Demand) {
        // 16 Demand 是累积的：它们加起来形成订阅者请求的值的总数。验证你是否已经向订阅者发送了足够的值，如配置中指定的那样。也就是说，如果你发送了最大数量的预期值，则与发布者收到的要求无关
        guard times > .none else {
            // 17 如果是这种情况，你可以通知订阅者发布者已完成发送值
            subscriber?.receive(completion: .finished)
            return
        }
        
        // 18 通过添加新需求来增加请求值的总数
        requested += demand
        // 19 检查定时器是否已经存在。如果没有，并且请求的值存在，那么是时候启动它了
        if source == nil, requested > .none {  // 配置你的计时器
            // 20 从你配置的队列中创建 DispatchSourceTimer
            let source = DispatchSource.makeTimerSource(queue: configuration.queue)
            // 21 安排计时器在每 configuration.interval 秒后触发
            source.schedule(deadline: .now() + configuration.interval, repeating: configuration.interval, leeway: configuration.leeway)
            
            // 22 为你的计时器设置事件处理程序。 这是计时器每次触发时调用的简单闭包。 确保保持对 self 的弱引用，否则订阅将永远不会解除分配
            source.setEventHandler { [weak self] in
                // 23 验证当前是否有请求的值——发布者可以在没有当前需求的情况下暂停，正如你将在本章后面了解背压时看到的那样
                guard let self = self, self.requested > .none else { return }
                // 24 减少两个计数器，因为你要发出一个值
                self.requested -= .max(1)
                self.times -= .max(1)
                // 25 向订阅者发送一个值
                _ = self.subscriber?.receive(.now())
                // 26 如果要发送的值的总数达到配置指定的最大值，你可以认为发布者已完成并发出完成事件！
                if self.times == .none {
                    self.subscriber?.receive(completion: .finished)
                }
            }
            
            self.source = source
            source.activate()
        }
    }
    
    // 实现 cancel()，Subscription 必须提供的必需方法
    func cancel() {
        source = nil
        subscriber = nil
    }
}

extension Publishers {
    
    struct DispatchTimer: Publisher {
        
        // 5 你的计时器将当前时间作为 DispatchTime 值发出。 当然，它永远不会失败，所以发布者的 Failure 类型是 Never
        typealias Output = DispatchTime
        typealias Failure = Never
        
        // 6 保留给定配置的副本。 你现在不使用它，但是当你收到订阅者时会需要它
        let configuration: DispatchTimerConfiguration
        
        init(configuration: DispatchTimerConfiguration) {
            
            self.configuration = configuration
        }
        
        // 7 功能是通用的；它需要一个编译时特化来匹配订阅者类型
        func receive<S: Subscriber>(subscriber: S)  where Failure == S.Failure, Output == S.Input {
            
            // 8 大部分动作将发生在你将在短时间内定义的 DispatchTimerSubscription 中
            let subscription = DispatchTimerSubscription(subscriber: subscriber, configuration: configuration)
            
            // 9 阅者会收到一个订阅，然后它可以向该订阅发送值请求
            subscriber.receive(subscription: subscription)
            
        }
    }
    
    static func timer(queue: DispatchQueue? = nil,
                      interval: DispatchTimeInterval,
                      leeway: DispatchTimeInterval = .nanoseconds(0),
                      times: Subscribers.Demand = .unlimited) -> Publishers.DispatchTimer {
        
        return Publishers.DispatchTimer(configuration: .init(queue: queue, interval: interval, leeway: leeway, times: times))
    }
}

//: [Next](@next)
