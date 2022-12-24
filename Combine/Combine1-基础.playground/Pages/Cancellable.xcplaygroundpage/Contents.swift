import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

/*
 当订阅者完成其工作并且不再希望从发布者接收值时，最好取消订阅以释放资源并停止发生任何相应的活动，例如网络调用。
 订阅将 AnyCancellable 的实例作为“cancellation token”返回，这使得你可以在完成订阅后取消订阅。 AnyCancellable 符合 Cancellable 协议，该协议正是为此目的需要 cancel() 方法。
 在前面的订阅者示例的底部，你添加了代码 subscription.cancel()。你可以在订阅上调用 cancel()，因为 Subscription 协议继承自 Cancellable。
 如果你没有在订阅上显式调用 cancel()，它将一直持续到发布者完成，或者直到正常的内存管理导致存储的订阅取消初始化。届时，它会取消订阅。
 注意：忽略 Playground 中订阅的返回值也可以（例如，_ = just.sink...）。但是，需要注意的是：如果你没有在完整项目中存储订阅，则该订阅将在程序流退出创建它的范围后立即取消！
 */

example(of: "Custom Subscriber -> 创建自定义订阅者") {
    // 1 通过 range 的发布者属性创建整数发布者
    let publisher = (1...6).publisher
    // 2 定义一个自定义订阅者，IntSubscriber
    final class IntSubscriber: Subscriber {
        // 3 实现类型别名以指定此订阅者可以接收整数输入并且永远不会收到错误
        typealias Input = Int
        typealias Failure = Never
        // 4 实现所需的方法，以 receive(subscription:) 开头，由发布者调用；并在该方法中，在 subscription 上调用 .request(_:)，指定订阅者愿意在订阅时接收最多三个值
        func receive(subscription: Subscription) {
             subscription.request(.max(3))
        }
        // 5 收到后打印每个值
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value", input)
            // .none，表示订阅者不会调整自己的需求； .none 等价于 .max(0)
            // return .none
            // 你没有收到完成事件。 这是因为发布者具有有限数量的值，并且你指定了 .max(3) 的需求
            // return .unlimited
            // 你将看到与返回 .unlimited 时相同的输出，因为每次收到事件时，你都指定要将最大值增加 1
            return .max(1)
        }
        // 6 打印完成事件
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    // 发布者要发布任何内容，就需要订阅者
    let subscriber = IntSubscriber()
    publisher.subscribe(subscriber)
}
