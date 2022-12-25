//: [Previous](@previous)

import Foundation
import Combine
import UIKit

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

// switchToLatest 很复杂，但非常有用。它使你可以在取消挂起的发布者订阅的同时即时切换整个发布者订阅，从而切换到最新的发布者订阅。
example(of: "switchToLatest") {
    
    // 1 创建三个接受整数且没有错误的 PassthroughSubject
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    let publisher3 = PassthroughSubject<Int, Never>()
    
    // 2 再创建一个 PassthroughSubject 接受其他 PassthroughSubject。你可以通过它发送 publisher1、publisher2 或 publisher3
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    
    // 3 在你的发布者上使用 switchToLatest。现在，每次你通过发布者主题发送不同的发布者时，你都会切换到新的发布者并取消之前的订阅
    publishers
        .switchToLatest()
        .sink(receiveCompletion: { _ in
            print("Completed!")
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
    
    // 4 将 publisher1 发送给 publishers，然后将 1 和 2 发送给 publisher1
    publishers.send(publisher1)
    publisher1.send(1)
    publisher1.send(2)
    
    // 5 发送 publisher2，取消对 publisher1的订阅。然后，你将 3 发送到 publisher1，但它被忽略了，然后将 4 和 5 发送到 publisher2，因为存在对 publisher2 的活动订阅，所以它们被推送
    publishers.send(publisher2)
    publisher1.send(3)
    publisher2.send(4)
    publisher2.send(5)
    
    // 6 发送 publisher3，取消对 publisher2 的订阅。和之前一样，你发送 6 到 publisher2 并被忽略，然后发送 7、8 和 9，它们通过订阅推送到 publisher3
    publishers.send(publisher3)
    publisher2.send(6)
    publisher3.send(7)
    publisher3.send(8)
    publisher3.send(9)
    
    // 7 最后，你将完成事件发送给当前发布者，publisher3，并将另一个完成事件发送给发布者。这样就完成了所有活动订阅
    publisher3.send(completion: .finished)
    publishers.send(completion: .finished)
    
}

// 如果你不确定为什么这在实际应用中很有用，请考虑以下场景：你的用户点击触发网络请求的按钮。 紧接着，用户再次点击按钮，触发第二个网络请求。 但是你如何摆脱挂起的请求，只使用最新的请求呢？ switchToLatest ！
example(of: "switchToLatest - Network Request") {
    
    let url = URL(string: "https://source.unsplash.com/random")!
    
    // 1 定义一个函数 getImage()，它执行网络请求获取随机图像。这使用 URLSession.dataTaskPublisher，它是 Foundation 的众多 Combine 扩展之一
    func getImage() -> AnyPublisher<UIImage?, Never> {
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .print("image")
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    // 2 创建一个 PassthroughSubject 来模拟用户对按钮的点击
    let taps = PassthroughSubject<Void, Never>()
    taps
        .map { _ in getImage() }
        // 3 在点击按钮后，通过调用 getImage() 将点击映射到随机图像的新网络请求。这实质上将 Publisher<Void, Never> 转换为 Publisher<Publisher<UIImage?, Never>, Never> — 发布者的发布者
        .switchToLatest()
        // 4 使用 switchToLatest() 就像在前面的例子中一样，因为你有一个发布者的发布者。这保证只有一个发布者会发出值，并会自动取消任何剩余的订阅
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
    
    // 5 使用 DispatchQueue 模拟三个延迟的按钮点击。第一次点击是立即的，第二次点击是在三秒后出现的，最后一次点击是在第二次点击之后的十分之一秒后出现的
    taps.send()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        taps.send()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
        taps.send()
    }
    
}

//: [Next](@next)
