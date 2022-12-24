//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "scan -> 增量转换输出") {
    
    // 1
    var dailyGainLoss: Int { .random(in: -10...10) }
    
    // 2
    let august2019 = (0..<22)
        .map { _ in dailyGainLoss }
        .publisher
    
    // 3
    august2019
        .scan(50) { latest, current in
            max(0, latest + current)
        }
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
    
    august2019
        // 还有一个抛出错误的 tryScan 操作符，其工作方式类似。 如果闭包抛出错误，则 tryScan 会因该错误而失败
        .tryScan(50) { latest, current in
            max(0, latest + current)
        }
        // 替换错误
        .replaceError(with: 999)
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
    
}

//: [Next](@next)
