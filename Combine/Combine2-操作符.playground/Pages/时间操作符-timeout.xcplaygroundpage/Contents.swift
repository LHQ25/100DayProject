//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 超时。其主要目的是在语义上区分实际计时和超时条件。 因此，当超时操作符触发时，它要么完成发布者，要么发出你指定的错误。 在这两种情况下，发布者都会终止
example(of: "timeout -> 超时") {
    
    enum TimeoutError: Error {
        case timedOut
    }
    
    let subject = PassthroughSubject<String, TimeoutError>()
    
    // 1 超时将在五秒后触发并完成发布者 -> 并自定义错误
    let timedOutSubject = subject.timeout(.seconds(5), scheduler: DispatchQueue.main, options: nil) {
        .timedOut
    }
    
    let subscription1 = subject.sink(receiveCompletion: { v in
        print(" Subject receiveCompletion: \(v)")
    }) { v in
        print(" Subject emitted: \(v)")
    }
    
    let subscription2 = timedOutSubject.sink(receiveCompletion: { v in
        print(" Timeout receiveCompletion: \(v)")
    }) { v in
        print(" Timeout emitted: \(v)")
    }
    
    subscription1.store(in: &subscriptions)
    subscription2.store(in: &subscriptions)
    
    Timer.publish(every: 6, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                subject.send("1")
            }
            .store(in: &subscriptions)
}

//: [Next](@next)
