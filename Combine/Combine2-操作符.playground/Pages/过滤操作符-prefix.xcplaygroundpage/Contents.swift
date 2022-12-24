//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 限制值(Limiting values)
// 在上一节中，你已经学习了如何删除（或跳过）值，直到满足特定条件。该条件可能匹配某个静态值、谓词闭包或对不同发布者的依赖。
// 本节解决相反的需求：接收值直到满足某些条件，然后强制发布者完成。例如，考虑一个可能发出未知数量的值的请求，但你只想要一次发出而不关心其余的值。
// 结合使用前缀系列操作符解决了这组问题。 尽管名称并不完全直观，但这些操作符提供的功能对于许多现实生活中的情况都很有用。
// 前缀族类操作符似于 drop，提供 prefix(_:)、 prefix(while:) 和 prefix(untilOutputFrom:)。 但是，前缀操作符不会在满足某些条件之前删除值，而是在满足该条件之前获取值

example(of: "prefix") {
    
    // 1 创建一个发布者，它发出从 1 到 10 的数字
    let numbers = (1...10).publisher
    
    // 2 使用 prefix(2) 只允许发射前两个值。 一旦发出两个值，发布者就完成了
    numbers
    .prefix(2)
    .sink(receiveCompletion: {
        print("Completed with: \($0)")
    }, receiveValue: { print($0) })
    .store(in: &subscriptions)
    
    // 就像 first(where:) 一样，这个操作符是 lazy 的，这意味着它只占用它需要的值，然后终止，这也可以防止数字产生超出 1 和 2 的其他值，因为它完成了
    
}

example(of: "prefix(while:)") {
    
    // 1 创建一个发出 1 到 10 之间值的发布者
    let numbers = (1...10).publisher
    
    // 2 使用 prefix(while:) 让小于 3 的值通过。一旦发出等于或大于 3 的值，发布者就完成了
    numbers
        .prefix(while: { $0 < 3 })
        .sink(receiveCompletion: {
            print("Completed with: \($0)")
        }, receiveValue: {
            print($0)
        })
    .store(in: &subscriptions)
    
}


example(of: "prefix(untilOutputFrom:)") {
    
    // 1 创建两个你可以手动发送值的 PassthroughSubjects。 第一个是 isReady 而第二个代表用户的点击
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2 使用 prefix(untilOutputFrom: isReady) 让点击事件通过，直到 isReady 发出至少一个值
    taps
        .prefix(untilOutputFrom: isReady)
        .sink(receiveCompletion: {
            print("Completed with: \($0)")
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
    
    // 3 通过 subject 发送五个“点击”，与上图完全相同。 第二次点击后，你发送 isReady 一个值
    (1...5).forEach { n in
        taps.send(n)
        if n == 2 {
            isReady.send()
        }
    }
    
}

//: [Next](@next)
