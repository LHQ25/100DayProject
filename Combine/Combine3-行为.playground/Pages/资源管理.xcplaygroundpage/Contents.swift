//: [Previous](@previous)

import Foundation
import Combine

// 1. share() 操作符
/*
 该操作符的目的是让你通过引用而不是通过值来获取发布者。 发布者通常是结构体：当你将发布者传递给函数或将其存储在多个属性中时，Swift 会多次复制它。 当你订阅每个副本时，发布者只能做一件事：开始其工作并交付值。
 share() 操作符返回 Publishers.Share 类的实例。通常，发布者被实现为结构，但在 share() 的情况下，如前所述，操作符获取对 Share 发布者的引用而不是使用值语义，这允许它共享底层发布者。
 这个新发布者“共享”上游发布者。它将与第一个传入订阅者一起订阅一次上游发布者。然后它将从上游发布者接收到的值转发给这个订阅者以及所有在它之后订阅的人。
 注意：新订阅者只会收到上游发布者在订阅后发出的值。不涉及缓冲或重放。如果订阅者在上游发布者完成后订阅共享发布者，则该新订阅者只会收到完成事件
 */
let shared = URLSession.shared
    .dataTaskPublisher(for: URL(string: "http://192.168.17.171:8000/test")!)
    .map(\.data)
    .print("shared")
    .share()

print("subscribing first")

// 第一个订阅触发对 DataTaskPublisher 的订阅。
let subscription1 = shared.sink(receiveCompletion: { _ in
    
}, receiveValue: {
    print("subscription1 received: '\($0)'")
})

print("subscribing second")
// 第二次订阅没有任何改变：发布者继续运行。没有第二个请求发出。
let subscription2 = shared.sink(receiveCompletion: { _ in
    
}, receiveValue: {
    print("subscription2 received: '\($0)'")
})
// 当请求完成时，发布者将结果数据发送给两个订阅者，然后完成。

// 当 DataTaskPublisher 不共享时，它收到了两个订阅！ 在这种情况下，请求会运行两次，每次订阅一次
// 注释 share() 就可以看到

// 2. multicast(_:) 操作符
/*
 即使在上游发布者完成后，要与发布者共享单个订阅并将值重播给新订阅者，你需要类似 shareReplay() 操作符。不幸的是，这个操作符不是 Combine 的一部分。但是，你将在后文中学习如何创建一个。
 在“网络”中，你使用了 multicast(_:)。此操作符基于 share() 构建，并使用你选择的 Subject 将值发布给订阅者。 multicast(_:) 的独特之处在于它返回的发布者是一个 ConnectablePublisher。这意味着它不会订阅上游发布者，直到你调用它的 connect() 方法。这让你有足够的时间来设置你需要的所有订阅者，然后再让它连接到上游发布者并开始工作
 */
// 1 准备一个 subject，它传递上游发布者发出的值和完成事件
let subject = PassthroughSubject<Data, URLError>()
// 2 使用上述 subject 准备多播发布者
let multicasted = URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
    .map(\.data)
    .print("multicast")
    .multicast(subject: subject)

// 3 订阅共享的——即多播的——发布者，就像本章前面的那样
let subscription3 = multicasted
    .sink(receiveCompletion: { _ in
        
    }, receiveValue: {
        print("subscription1 received: '\($0)'")
    })
let subscription4 = multicasted
    .sink(receiveCompletion: { _ in
        
    }, receiveValue: {
        print("subscription2 received: '\($0)'")
    })
// 4 指示发布者连接到上游发布者
let cancellable = multicasted.connect()
// 一个多播发布者，和所有的 ConnectablePublisher 一样，也提供了一个 autoconnect() 方法，这使它像 share() 一样工作：第一次订阅它时，它会连接到上游发布者并立即开始工作。
// 这在上游发布者发出单个值并且你可以使用 CurrentValueSubject 与订阅者共享它的情况下很有用。
// 对于大多数现代应用程序来说，共享订阅工作，特别是资源密集型流程（例如网络）是必须的。不注意这一点不仅会导致内存问题，而且可能会用大量不必要的网络请求轰炸你的服务器

// 3. Future
// 虽然 share() 和 multicast(_:) 为你提供了成熟的发布者，Combine 还提供了另一种让你共享计算结果的方法：Future。
// 你可以通过将接收 Promise 参数的闭包交给 Future 来创建它。 只要你有可用的结果（成功或失败），你就会进一步履行承诺

// 1 提供一个模拟 Future 执行的工作（可能是异步的）的功能
func performSomeWork() throws -> Int {
    print("Performing some work and returning a result")
    return 5
}
// 2 创造新的 Future。请注意，工作立即开始，无需等待订阅者
let future = Future<Int, Error> { fulfill in
    do {
        let result = try performSomeWork()
        // 3 如果工作成功，则以结果履行 Promise
        fulfill(.success(result))
    } catch {
        // 4 如果工作失败，它将错误传递给 Promise
        fulfill(.failure(error))
    }
}
print("Subscribing to future...")
// 5 订阅一次表明我们收到了结果
let subscription5 = future.sink(receiveCompletion: { _ in
    print("subscription1 completed")
}, receiveValue: {
    print("subscription1 received: '\($0)'")
})
// 6 第二次订阅表明我们也收到了结果，没有执行两次工作
let subscription6 = future.sink(receiveCompletion: { _ in
    print("subscription2 completed")
}, receiveValue: {
    print("subscription2 received: '\($0)'")
})

/*
 Future 是一个类，而不是一个结构。
 
 创建后，它立即调用你的闭包开始计算结果并尽快履行承诺。
 它存储已履行的 Promise 的结果并将其交付给当前和未来的订阅者。
 在实践中，这意味着 Future 是一种方便的方式，可以立即开始执行某些工作（无需等待订阅），同时只执行一次工作并将结果交付给任意数量的订阅者。但它执行工作并返回单个结果，而不是结果流，因此用例比成熟的发布者要窄。
 当你需要共享网络请求产生的单个结果时，它是一个很好的选择！
 
 注意：即使你从未订阅 Future，创建它也会调用你的闭包并执行工作。你不能依赖 Deferred 来推迟闭包执行，直到订阅者进来，因为 Deferred 是一个结构体，每次有新订阅者时都会创建一个新的 Future
 */

//: [Next](@next)
