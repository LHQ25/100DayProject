//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 查看一个不操纵时间而只是测量时间的特定操作符。当你需要找出发布者发出的两个连续值之间经过的时间时，measureInterval(using:) 操作符是你的工具
example(of: "measureInterval") {
    
    let subject = PassthroughSubject<String, Never>()
    
    // 1
    let measureSubject = subject.measureInterval(using: DispatchQueue.main)
    
    let subscription1 = subject.sink(receiveCompletion: { v in
        print(" Subject receiveCompletion: \(v)")
    }) { v in
        print(" Subject emitted: \(v)")
    }
    
    let subscription2 = measureSubject.sink(receiveCompletion: { v in
        print(" MeasureInterval receiveCompletion: \(v)")
    }) { v in
        print(" MeasureInterval emitted: \(Double(v.magnitude) / 1_000_000_000.0)")
    }
    
    subscription1.store(in: &subscriptions)
    subscription2.store(in: &subscriptions)
    
    Timer.publish(every: 2, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                subject.send("1")
            }
            .store(in: &subscriptions)
}

//: [Next](@next)
