import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

//let can =

example(of: "assign(to:on:) -> assign(to:on:) 运算符能够将接收到的值分配给对象的 KVO 兼容属性") {
    // 1 定义一个具有属性的类，该属性具有打印新值的didSet 属性观察器
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
    // 2 创建该类的实例
    let object = SomeObject()
    // 3 从字符串数组创建发布者
    let publisher = ["Hello", "world!"].publisher
    // 4 订阅发布者，将收到的每个值分配给对象的 value 属性
    _ = publisher.assign(to: \.value, on: object)
}

// assign 操作符的一个变体，重新发布发布者可用于通过另一个用 @Published 属性包装器标记的属性发出的值
example(of: "assign(to:) -> 使用 assign(to:) 重新发布") {
    // 1 定义并创建一个类的实例，该实例的属性使用@Published 属性包装器注解，除了可作为常规属性访问之外，它还为值创建了一个发布者
    class SomeObject {
        @Published var value = 0
    }
    let object = SomeObject()
    // 2 使用 @Published 属性上的 $ 前缀来访问其底层发布者，订阅它，并打印出收到的每个值
    object.$value.sink {
        print($0)
    }
    // 3 创建一个数字发布者并将它发出的每个值分配给 object 的值发布者。 请注意使用 & 来表示对属性的 inout 引用
    (0..<10).publisher.assign(to: &object.$value)
}

class MyObject {
    @Published var word: String = ""
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        // 使用 assign(to: \.word, on: self) 并存储生成的 AnyCancellable 会导致引用循环。 用 assign(to: &$word) 替换 assign(to:on:) 可以防止这个问题
        ["A", "B", "C"].publisher.assign(to: \.word, on: self).store(in: &subscriptions)
    }
}
