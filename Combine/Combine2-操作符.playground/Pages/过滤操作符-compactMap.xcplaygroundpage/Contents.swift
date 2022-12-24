//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()
example(of: "compactMap -> 移去 nil 值(Compacting values)") {

    // 1 创建一个发布有限字符串列表的发布者
    let strings = ["a", "1.24", "3", "def", "45", "0.23"].publisher
    // 2 使用 compactMap 尝试从每个单独的字符串初始化一个 Float。 如果失败，则返回 nil。 这些 nil 值会被 compactMap 操作符自动过滤掉
    strings
        .compactMap { Float($0) }
        .sink(receiveValue: {
            // 3 只打印成功转换为浮点数的字符串
            print($0)
        })
    .store(in: &subscriptions)
    
}

//: [Next](@next)
