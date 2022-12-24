//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

example(of: "async/await") {
    
    let subject = CurrentValueSubject<Int, Never>(0)
    
    // Task 创建一个新的异步任务——闭包代码将与本代码示例中的其余代码异步运行
    Task {
        // 此代码块中的关键 API 是 subject 的 values 属性。
        // values 返回一个异步序列，其中包含subject 或发布者发出的元素。你可以像上面那样在一个简单的 for 循环中迭代该异步序列
        for await element in subject.values {
            print("Element: \(element)")
            
        }
        // 一旦发布者完成，无论是成功还是失败，循环都会结束
        print("Completed.")
    }
    
    subject.send(1)
    subject.send(2)
    subject.send(3)
    subject.send(completion: .finished)
    
    // 在 Future 发出单个元素（如果有）的情况下，values 属性没有多大意义。 这就是为什么 Future 有一个 value 属性，你可以使用它来异步获取未来的结果
}

//: [Next](@next)
