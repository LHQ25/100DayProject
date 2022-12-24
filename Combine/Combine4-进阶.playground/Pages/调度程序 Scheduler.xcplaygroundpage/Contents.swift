//: [Previous](@previous)

import SwiftUI
import Foundation
import Combine
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

// 你的代码将在哪个线程上执行的确切细节取决于你选择的 Scheduler
// 记住这个重要的概念：Scheduler 不等于线程

// Scheduler 操作符
/*
 Combine 框架提供了两个基本的操作符来使用调度器：
    subscribe(on:) 和 subscribe(on:options:) 在指定的 Scheduler 上创建订阅（开始工作）。
    receive(on:) 和 receive(on:options:) 在指定的 Scheduler 上传递值。
 
 此外，以下操作符将调度程序和调度程序选项作为参数
    debounce(for:scheduler:options:)
    delay(for:tolerance:scheduler:options:)
    measureInterval(using:options:)
    throttle(for:scheduler:latest:)
    timeout(_:scheduler:options:customError:)
 */

// 介绍 subscribe(on:)
/*
 1. 发布者 receive 订阅者并创建 Subscription。
 2. 订阅者 receive Subscription 并从发布者请求值（虚线）。
 3. 发布者开始工作（通过 Subscription）。
 4. 发布者发出值（通过 Subscription）。
 5. 操作符转换值。
 6. 订阅者收到最终值。
 
 当你的代码订阅发布者时，步骤一、二和三通常发生在当前线程上。 但是当你使用 subscribe(on:) 操作符时，所有这些操作都在你指定的 Scheduler 上运行
 */

// 1 定义了一个名为 ExpensiveComputation 的特殊发布者，它模拟一个长时间运行的计算，在指定的持续时间后发出一个字符串
let computationPublisher = Publishers.ExpensiveComputation(duration: 3)

// 2 一个串行队列，你将使用它来触发特定调度程序上的计算。正如你在上面了解到的，DispatchQueue 符合调度程序协议
let queue = DispatchQueue(label: "serial queue")

// 3 获取当前执行线程号。在 Playground 中，主线程（线程编号 1）是你的代码运行的默认线程
let currentThread = Thread.current.number
print("Start computation publisher on thread \(currentThread)")

let subscription = computationPublisher
    .subscribe(on: queue)               // 可以看到你仍在从主线程订阅，但是将委托 Combine 到你提供的队列以有效地执行订阅。队列在其线程之一上运行代码。由于计算在线程 5 上开始并完成，然后从该线程发出结果值，因此你的接收器也接收该线程上的值
    .receive(on: DispatchQueue.main)    // 它允许你指定应该使用哪个调度程序向订阅者传递值
    .sink { value in
        let thread = Thread.current.number
        print("Received computation result on thread \(thread): '\(value)'")
    }


struct ThreadRecorder {
    
}

struct ThreadRecorderView: View {
    
    var title: String
    var setup: AnyPublisher<ThreadRecorder, Never>
    
    var body: some View {
        Text("1111")
    }
}



extension Publisher {
    
    func recordThread(using: ThreadRecorder) -> AnyPublisher<Any, Never> {
     
        Just(using)
            .eraseToAnyPublisher()
    }
}

extension Thread {
    var number: Int {
        return (self.threadDictionary["number"] as Int?) ?? 0
    }
}

var threadRecorder: ThreadRecorder? = nil

// Scheduler 实现
/*
 Apple 提供了几种调度器协议的具体实现：
    ImmediateScheduler：一个简单的 Scheduler，它立即在当前线程上执行代码，这是默认的执行上下文，除非使用 subscribe(on:)、receive(on:) 或任何其他将调度程序作为参数的操作符进行修改。
    RunLoop：绑定到 Foundation 的 Thread 对象。
    DispatchQueue：可以是串行的或并发的。
    OperationQueue：规范工作项执行的队列。
 */

example(of: "ImmediateScheduler") {
    
    let source = Timer
        .publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .scan(0) { counter, _ in
            counter + 1
        }
    
    // 1 准备一个返回发布者的闭包，使用给定的记录器对象通过 recordThread(using:) 设置当前线程记录
    let setupPublisher = { recorder in
        source
        // 2 在这个阶段，定时器发出一个值，所以你记录当前线程。你已经猜到是哪一个了吗
            .recordThread(using: recorder)
        // 3 确保发布者在共享的 ImmediateScheduler 上传递值
            // .receive(on: ImmediateScheduler.shared)
            .receive(on: DispatchQueue.global())
        // 4 记录你现在所在的线程
            .recordThread(using: recorder)
        // 5 闭包必须返回一个 AnyPublisher 类型。这主要是为了方便内部实现
            .eraseToAnyPublisher()
    }
    
    // 6 准备并实例化一个 ThreadRecorderView，它显示发布的值在各个记录点的线程之间的迁移
    let view = ThreadRecorderView(title: "Using ImmediateScheduler", setup: setupPublisher)
    PlaygroundPage.current.liveView = UIHostingController(rootView: view)
    
    /*
     ImmediateScheduler 选项
        由于大多数操作符在其参数中接受调度程序，你还可以找到一个接受 SchedulerOptions 值的选项参数。
        在 ImmediateScheduler 的情况下，此类型被定义为 Never，因此在使用 ImmediateScheduler 时，你永远不应该为操作符的 options 参数传递值。
     ImmediateScheduler 的陷阱
        关于 ImmediateScheduler 的一件事是它是即时的。
        你将无法使用 Scheduler 协议的任何 schedule(after:) 变体，因为你需要指定延迟的 SchedulerTimeType 没有公共初始化程序，并且对于立即调度毫无意义。
     */
}

example(of: "RunLoop scheduler") {
    
    let source = Timer
        .publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .scan(0) { counter, _ in
            counter + 1
        }
    
    let setupPublisher = { recorder in
        source
        // 1
            .receive(on: DispatchQueue.global())
            .recordThread(using: recorder)
        // 2
            .receive(on: RunLoop.current)    // RunLoop.current 是与调用时当前的线程相关联的 RunLoop。闭包由 ThreadRecorderView 调用，从主线程设置发布者和订阅者。因此，RunLoop.current 就是主线程的 RunLoop
            .recordThread(using: recorder)
            .handleEvents(receiveSubscription: { _ in threadRecorder = recorder })
            .eraseToAnyPublisher()
    }
    
    let view = ThreadRecorderView(title: "Using RunLoop", setup: setupPublisher)
    PlaygroundPage.current.liveView = UIHostingController(rootView: view)
    
    /*
     RunLoop 选项
        与 ImmediateScheduler 一样，RunLoop 不为采用 SchedulerOptions 参数的调用提供任何合适的选项。
     RunLoop 陷阱
        RunLoop 的使用应仅限于主线程的 RunLoop，以及你在需要时控制的 Foundation 线程中可用的 RunLoop。也就是说，任何你自己使用 Thread 对象开始的东西。
        要避免的一个特殊陷阱是在 DispatchQueue 上执行的代码中使用 RunLoop.current。这是因为 DispatchQueue 线程可能是短暂的，这使得它们几乎不可能依赖 RunLoop
     */
}

example(of: "DispatchQueue Scheduler") {
    
    // 使用 DispatchQueue 作为 Scheduler
    
    let serialQueue = DispatchQueue(label: "Serial queue")
    // let sourceQueue = DispatchQueue.main
    let sourceQueue = serialQueue   // DispatchQueue 的无线程保证效果，但你也看到 receive(on:) 操作符从不切换线程！看起来内部正在进行一些优化以避免额外的切换
    
    // 1 当计时器触发时，你将使用 Subject 发出一个值。你不关心实际的输出类型，因此你只需使用 Void
    let source = PassthroughSubject<Void, Never>()
    // 2 队列完全能够生成定时器，但没有用于队列定时器的 Publisher API。 必须使用调度程序协议中的 schedule() 方法的重复变体。它立即开始并返回一个 Cancellable。每次计时器触发时，你都会通过 source 发送一个 Void 值。
    let subscription = sourceQueue.schedule(after: sourceQueue.now, interval: .seconds(1)) {
        source.send()
    }
    
    // 开始练习 scheduler
    let setupPublisher = { recorder in
        // 计时器在主队列上触发并通过 Subject 发送 Void 值。
        source
        .recordThread(using: recorder)
        // 发布者在你的串行队列上接收值
        // .receive(on: serialQueue)
        .receive(on: serialQueue,  options: DispatchQueue.SchedulerOptions(qos: .userInteractive)) // DispatchQueue.SchedulerOptions 的实例传递给指定最高服务质量的选项：.userInteractive。它指示操作系统尽最大努力将价值交付优先于不太重要的任务。当你想尽快更新用户界面时，可以使用此功能。相反，如果快速交付的压力较小，你可以使用 .background 服务质量
        .recordThread(using: recorder)
        .eraseToAnyPublisher()
    }
    
    let view = ThreadRecorderView(title: "Using DispatchQueue", setup: setupPublisher)
    PlaygroundPage.current.liveView = UIHostingController(rootView: view)
}

example(of: "OperationQueue") {
    
    let queue = OperationQueue()  // 这令人费解！按顺序发出但无序到达！
    
    // 修改 ->
    // 每个 OperationQueue 中都有一个参数可以解释一切：它是 maxConcurrentOperationCount。它默认为系统定义的数字，允许操作队列同时执行大量操作。由于你的发布者几乎在同一时间发出所有项目，它们被 Dispatch 的并发队列分派到多个线程
    queue.maxConcurrentOperationCount = 1  // 获得真正的顺序执行——将 maxConcurrentOperationCount 设置为 1 相当于使用串行队列——并且你的值按顺序到达
    
    let subscription = (1...10).publisher
        .receive(on: queue)     // 每个值都是在不同的线程上接收的！如果你查看有关 OperationQueue 的文档，有一条关于线程的说明，其中说 OperationQueue 使用 Dispatch 框架（因此是 DispatchQueue）来执行操作。这意味着它不保证它会为每个交付的值使用相同的底层线程
        .sink { value in
            print("Received \(value) on thread \(Thread.current.number)")
        }
    
    /*
     OperationQueue 选项
        OperationQueue 没有可用的 SchedulerOptions。它实际上是别名为 RunLoop.SchedulerOptions 的类型，它本身没有提供任何选项。
     OperationQueue 陷阱
        你刚刚看到 OperationQueue 默认并发执行操作。你需要非常清楚这一点，因为它可能会给你带来麻烦：默认情况下，OperationQueue 的行为类似于并发 DispatchQueue。
        但是，当你每次发布者发出值时都有大量工作要执行时，它可能是一个很好的工具。你可以通过调整 maxConcurrentOperationCount 参数来控制负载
     */
}

//: [Next](@next)
