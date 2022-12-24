//: [Previous](@previous)

import Foundation
import Combine

//1. 计时器

// 使用 RunLoop
// 主线程和你创建的任何线程（最好使用 Thread 类）可以拥有自己的 RunLoop。 只需从当前线程调用 RunLoop.current：如果需要，Foundation 会为你创建一个。请注意，除非你了解 RunLoop 是如何运行的——特别是你需要一个 RunLoop ——否则最好只使用运行应用程序主线程的主 RunLoop
let runLoop = RunLoop.main
let subscription = runLoop.schedule(after: runLoop.now,  interval: .seconds(1),  tolerance: .milliseconds(100)) {
    print("Timer fired")
}

// 定义了几种相对较低级别的方法，并且是唯一一种可以让你创建可取消计时器的方法
runLoop.schedule(after: .init(Date(timeIntervalSinceNow: 3.0))) {
    subscription.cancel()
    print("取消")
}

// 2. RunLoop 并不是创建计时器的最佳方式。 使用 Timer 类会更好
 let publisher1 = Timer.publish(every: 1.0, on: .main, in: .common)

// 除非你了解运行循环是如何运行的，否则你应该坚持使用这些默认值
 let publisher2 = Timer.publish(every: 1.0, on: .current, in: .common)

// 计时器返回的发布者是 ConnectablePublisher。
// 它是 Publisher 的一个特殊变体，在你显式调用它的 connect() 方法之前，它不会在订阅时开始触发。
// 还可以使用 autoconnect() 操作符，它会在第一个订阅者订阅时自动连接

// 最佳方法是编写
let publisher3 = Timer  .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()

// 计时器重复发出当前日期，其 Publisher.Output 类型为 Date。 你可以使用 scan 操作符制作一个发出递增值的计时器
let subscription2 = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .scan(0) { counter, _ in
        counter + 1
    }
    .sink { counter in
        print("Counter is \(counter)")
    }

// 3. 使用 DispatchQueue
// 可以使用调度队列来生成计时器事件。 虽然 Dispatch 框架有一个 DispatchTimerSource 事件源，但令人惊讶的是，Combine 没有为其提供计时器接口。
let queue = DispatchQueue.main
// 1 创建一个 subject，你将向其发送计时器值
let source = PassthroughSubject<Int, Never>()
// 2 准备一个 counter，每次计时器触发时，你都会增加它
var counter = 0
// 3 每秒在所选队列上安排一个重复操作。 动作立即开始
let cancellable = queue.schedule(after: queue.now, interval: .seconds(1)) {
    source.send(counter)
    counter += 1
}
// 4 订阅 subject 获取定时器值
let subscription3 = source
    .sink {  print("Timer emitted \($0)")
    }

//: [Next](@next)
