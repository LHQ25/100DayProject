//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// 如果上游发布者发出指定的值，则 contains 操作符将发出 true 并取消订阅，如果发出的值都不等于指定的值，则返回 false
example(of: "contains") {
    
    // 1 创建一个发出五个不同字母（A 到 E）的发布者，并创建一个与 contains 一起使用的字母值
    let publisher = ["A", "B", "C", "D", "E"].publisher
    let letter = "C"
    // let letter = "F" // 在这种情况下， contains 等待发布者发出 F。但是，发布者在没有发出 F 的情况下完成，因此 contains 发出 false 并且你会看到打印出的相应消息
    
    // 2 使用 contains 检查上游发布者是否发出了 letter: C 的值
    publisher
        .print("publisher")
        .contains(letter)
        .sink(receiveValue: { contains in
            // 3 根据是否发出值打印适当的消息
            print(contains ? "Publisher emitted \(letter)!": "Publisher never emitted \(letter)!")
        })
    .store(in: &subscriptions)
    
    // 你收到一条消息，表明 C 是由发布者发出的。你可能还注意到 contains 是惰性的，因为它只消耗执行其工作所需的上游值。一旦找到 C，它就会取消订阅并且不会产生任何进一步的值
}

example(of: "contains(where:)") {
    
    // 1 定义一个带有 id 和 name 的 Person 结构体
    struct Person {
        let id: Int
        let name: String
    }
    
    // 2 创建发布人的三个不同实例的发布者
    let people = [(123, "Shai Mishali"), (777, "Marin Todorov"), (214, "Florent Pillet")]
        .map(Person.init)
        .publisher
    
    // 3 使用contains查看其中任何一个的 id 是否为 800
    people
        // .contains(where: { $0.id == 800 }) // 它没有找到任何匹配项，因为没有一个发出的人的 id 为 800
        .contains(where: { $0.id == 800 || $0.name == "Marin Todorov" })  // 找到了与条件匹配的值，因为 Marin 确实是你列表中的人之一
        .sink(receiveValue: { contains in
            // 4 根据发出的结果打印适当的消息
            print(contains ? "Criteria matches!": "Couldn't find a match for the criteria")
        }).store(in: &subscriptions)
    
    //
}

//: [Next](@next)
