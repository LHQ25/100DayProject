//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "removeDuplicates -> 过滤重复值") {
    
    // 1 将一个句子分成一个单词数组，然后创建一个新的发布者来发出这些单词
    let words = "hey hey there! want to listen to mister mister ?"
        .components(separatedBy: " ")
        .publisher
    
    // 2 将 removeDuplicates() 应用于你的发布者
    words
        .removeDuplicates()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 不符合 Equatable 的值怎么办？ removeDuplicates 有另一个重载，它接受一个带有两个值的闭包，你将从中返回一个 Bool 来指示值是否相等
    words
        .removeDuplicates{ prev, current in
            prev == current
        }
        .sink(receiveValue: { print("->",$0) })
        .store(in: &subscriptions)
    
}

//: [Next](@next)
