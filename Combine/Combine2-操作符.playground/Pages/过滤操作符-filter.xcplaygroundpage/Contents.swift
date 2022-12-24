//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "filter") {
    
    // 1 创建一个新的发布者，它将发出有限数量的值——从 1 到 10，然后使用序列类型的发布者属性完成
    let numbers = (1...10).publisher
    // 2 使用过滤器操作符，传入一个谓词，在该谓词中，你只允许通过是三的倍数的数字
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { n in
            print("\(n) is a multiple of 3!")
            
        })
        .store(in: &subscriptions)
    
}

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
