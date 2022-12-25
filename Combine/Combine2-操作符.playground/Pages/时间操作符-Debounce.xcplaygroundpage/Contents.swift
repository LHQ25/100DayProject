//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "debounce -> 防抖") {
    
    // 1 创建一个发出字符串的发布者
    let subject = PassthroughSubject<String, Never>()
    
    // 2 使用 debounce 等待对象发射一秒钟。 然后，它将发送在该一秒间隔内发送的最后一个值（如果有）。 这具有允许每秒最多发送一个值的效果
    let debounced = subject.debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
        // 3 你将多次订阅 debounced。 为了保证结果的一致性，你使用 share() 创建单个订阅点，这将同时向所有订阅者显示相同的结果
        .share()
    
    let subscription1 = subject.sink { string in
        print(" Subject emitted: \(string)")
    }
    
    let subscription2 = debounced.sink { string in
        print("Debounced emitted: \(string)")
    }
    
    subscription1.store(in: &subscriptions)
    subscription2.store(in: &subscriptions)
    
    Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                subject.send("1")
            }
            .store(in: &subscriptions)
    
    // 注意：要注意的一件事是发布者的完成事件。如果你的发布者在发出最后一个值之后立即完成，且在为防抖配置的时间之前，你将永远不会看到去抖动发布者中的最后一个值！
    
}

//: [Next](@next)
