//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

/*
 节流(Throttle)
 debounce 允许的延迟模式非常有用，Combine 提供了一个相关的操作：throttle(for:scheduler:latest:)。 它非常接近防抖
 */
example(of: "throttle -> 节流") {
    
    let throttleDelay = 2.0
    
    // 1 源发布者将发出字符串
    let subject = PassthroughSubject<String, Never>()
    
    // 2 由于你将 latest 设置为 false，因此你的 throttled subject 现在将仅在每个一秒间隔内发出从 subject 接收到的第一个值
    let throttled = subject
        .throttle(for: .seconds(throttleDelay), scheduler: DispatchQueue.main, latest: false)
        // 3 和之前的操作符 debounce 一样，在此处添加 share() 操作符可以保证所有订阅者同时从节流主题看到相同的输出
        .share()
    
    
    let subscription1 = subject.sink { string in
        print(" Subject emitted: \(string)")
    }
    
    let subscription2 = throttled.sink { string in
        print("Throttled emitted: \(string)")
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
    
    // 防抖等待它接收到的值暂停，然后在指定的时间间隔后发出最新的值。
    // 节流等待指定的时间间隔，然后发出它在该时间间隔内收到的第一个或最新的值。它不关心暂停
}

//: [Next](@next)
