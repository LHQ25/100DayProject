//: [Previous](@previous)
import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// output 操作符将查找上游发布者在指定索引处发出的值
example(of: "output(at:)") {
    
    // 1 创建一个发出三个字母的发布者
    let publisher = ["A", "B", "C"].publisher
    
    // 2 使用 output(at:) 只允许在索引 1 处发出的值——即第二个值
    publisher
        .print("publisher")
        .output(at: 1)
        .sink(receiveValue: { print("Value at index 1 is \($0)") })
        .store(in: &subscriptions)
    
    // 输出表明索引 1 处的值是 B。但是，你可能已经注意到另一个有趣的事实：操作符在每个发出的值之后都需要一个值，因为它知道它只是在寻找单个项目
}


// output(at:) 发出在指定索引处发出的单个值时， output(in:) 发出其索引在给定范围内的值
example(of: "output(in:)") {
    
    // 1 创建一个发出五个不同字母的发布者
    let publisher = ["A", "B", "C", "D", "E"].publisher
    
    // 2 使用 output(in:) 操作符只允许在索引 1 到 3 中发出的值通过，然后打印出这些值
    publisher
        .output(in: 1...3)
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print("Value in range: \($0)")
        })
        .store(in: &subscriptions)
    
    // 操作符发出索引范围内的单个值，而不是它们的集合。 操作符打印值 B、C 和 D，因为它们分别位于索引 1、2 和 3 中。 然后，由于该范围内的所有项目都已发出，因此它会在收到所提供范围内的所有值后立即取消订阅
}

//: [Next](@next)
