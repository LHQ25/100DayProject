//
//  04AsyncStream.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/6.
//

import Foundation

// 使用续体 (continuations)，将一个已有的基于回调或代理的函数转换为异步函数了。比如一个 load(completion:) 函数：
func load_1(_ completion: @escaping (([String?], Error?) -> Void)) {
    
}
// 要提供它的异步函数版本，可以使用 withUnsafeThrowingContinuation 包装：
func load_1() async throws -> [String?] {
    try await withUnsafeThrowingContinuation { continuation in
        load_1 { (value, error) in
            continuation.resume(returning: value)
        }
    }
}
/*
 通过 continuation 进行转换的这种方式，要求 continuation 的 resume，不论成功还是失败，只能进行一次调用。或者说，它只接受一个未来值：
    成功时的返回值或者失败时的抛出值。
 
 但是“未来的单次值”只能覆盖一部分使用情景，如果某个回调或者某个代理方法有可能被多次调用的话，我们将会得到不止一个，而是一系列未来的值：
    这就是一个异步序列。
 
 对于将这种将多次调用的异步操作转换为一个异步序列的需求，Swift 提供了 AsyncStream 类型。
 和 with*Continuation API 类似，AsyncStream 也允许我们通过在提供的续体上调用函数，来控制异步函数的执行：
 */

/*
 AsyncStream 的 init 方法接受 build 闭包作为输入，它拥有一个表示当前续体的参数 Continuation。当新的异步值产生时，我们通过调用 yield 来在异步序列中添加一个值；当所有事件完成，这个序列不再会产生新的值时，我们需要调用 finish 来表示完结。
 除了 AsyncStream 外，和 Swift 并发话题下的其他一些 API 类似，也存在可抛出错误的版本 AsyncThrowingStream：在可抛出版本中，Continuation 可以接受 finish(throwing:) 表示出错，其他部分和 AsyncStream 并没有太多区别
 */
func async_stream_test() {
    
}
// 通过使用 AsyncStream 的初始化方法，可以创建一个同等的异步序列
var timerStream = AsyncStream<Date>{ continuation in
    
    let initial = Date()
    
    //1
    Task {
        // Timer.scheduledTimer 方法将在当前 runloop 中以默认模式添加计时器。如果不为它准备一个新的任务环境，在 await 时计时器会在 runloop 中一直等待，无法正确工作
        let t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            let now = Date()
            print("Call yield")
            continuation.yield(Date())
            
            let diff = now.timeIntervalSince(initial)
            if diff > 0 {
                print("Call finish")
                continuation.finish()
            }
        }
        
        // 2
        // 可以通过设定续体的 onTermination 属性，在异步序列结束时进行一些清理工作。这个闭包要求满足 @Sendable。涉及数据安全的部分  @Sendable 标记
        continuation.onTermination = { @Sendable state in
            
            debugPrint("onTermination: \(state)")
            t.invalidate()
        }
    }
}
// 由于 AsyncStream 是遵守 AsyncSequence 协议的，我们可以类似地通过 for await 的迭代语法进行使用
//let t = Task{
//    let timer = timerStream
//    for await v in timer {
//        debugPrint(v)
//    }
//}
/*
 在 10 秒后，timerStream 进入到 diff > 10 的分支，continuation.finish() 被调用，进而触发 onTermination 闭包，且得到的结果为 finished。除了序列完结之外，在运行序列的任务被取消时，AsyncStream 续体的 onTermination 也会被调用，在这种情况下，参数 Termination 将会是 enum 中的另一个成员 cancelled
 */

//try await Task.sleep(2 * NSEC_PER_SEC)
//t.cancel()

// MARK: - 缓冲策略
/*
 在 AsyncStream 的初始化方法中，除了 build 之外，还有几个可选参数
    第一个参数 elementType 是为了编译器和内部实现需要所附加的条件，在创建 timerStream 时，我们明确指定了元素的泛型类型为 AsyncStream<Date>。如果不直接指定泛型类型，我们也可以通过这个参数来创建 AsyncStream： AsyncStream(Date.self){ }。 除了帮助推断数据类型以外，没有太多的实际用处
 
    bufferingPolicy 则实打实地影响 AsyncStream 的行为。在 timerStream 中，Timer 在 AsyncStream 创建时就已经开始运行并计时了。接下来 yield 方法将被每秒调用一次。如果 for await 没有能及时“消化”这些值的话，它们将被暂时存储到 AsyncStream 的内部缓冲区中
 
        AsyncStream 在内部实现了一个由互斥锁保护的高效队列，用来作为 yield 调用的缓冲区。在每次 for await 时，AsyncStream 的迭代器 (不要忘记 AsyncStream 是满足异步序列协议的) 的 next 方法会向这个内部存储队列请求一个值，并将它返回。只有在缓冲区中没有值时，这个 await 才进入真正的等待状态。
 
        在创建 AsyncStream 时没有指明的情况下，bufferingPolicy 参数接受的是默认值 .unbounded。
        它会尝试无限量地缓冲接收到的值，直到 for await 迭代开始。在大多数用例下，这个行为符合直觉，并简化了 AsyncStream 的使用。但是这种无界行为天然地存在风险：当可能需要缓冲的数据量没有上限时，这种策略是否可用，取决于内存极限和迭代哪一个会先来到。而且在很多情况下，也许迭代速度会比缓冲速度更慢，这也可能让缓冲区中产生大量的数据堆积，进而造成内存崩溃等问题。
 
        只要异步的发送端的速度快于接收端，就可能会出现这样的问题。在 UI 开发中，也能举出其他很多例子：例如 app 从服务器不断收到数据，并需要将这些数据渲染到屏幕上。作为纯数据行为，前者的速度会远远大于涉及到 UI 渲染的后者，如果不采用一些手段和措施，最终界面卡顿或者程序崩溃，都将是预期中的结果。
 
    除了 .unbounded 外，bufferingPolicy 参数还提供了两种可能的选择
    bufferingOldest 将在达到上限后抛弃掉新收到的数据，
    bufferingNewest 则相反，它会抛弃最旧的数据。
    这两种缓冲策略思路是一致的：通过限制缓冲区的大小，来丢弃一些数据，从而达到安全。
 */
var timerStream2 = AsyncStream<Date>(bufferingPolicy: .bufferingNewest(3)){ continuation in
    // 只要缓冲区中的值超过 3 个时，序列就将丢弃最旧的值，直到序列缓冲区开始消耗
    let initial = Date()
    
    //1
    Task {
        // Timer.scheduledTimer 方法将在当前 runloop 中以默认模式添加计时器。如果不为它准备一个新的任务环境，在 await 时计时器会在 runloop 中一直等待，无法正确工作
        let t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            let now = Date()
            print("Call yield")
            continuation.yield(Date())
            
            let diff = now.timeIntervalSince(initial)
            if diff > 0 {
                print("Call finish")
                continuation.finish()
            }
        }
        
        // 2
        // 可以通过设定续体的 onTermination 属性，在异步序列结束时进行一些清理工作。这个闭包要求满足 @Sendable。涉及数据安全的部分  @Sendable 标记
        continuation.onTermination = { @Sendable state in
            
            debugPrint("onTermination: \(state)")
            t.invalidate()
        }
    }
}
/*
 在极端情况下，bufferingOldest 或者 bufferingNewest 的绑定值可能被设为 0。这种情况意味着 AsyncStream 中不存在可用的缓冲区，continuation 的 yield 方法所产生的值将被直接抛弃掉。这个特性可以让我们拥有在运行时通过设置缓冲区策略来暂时“关闭”异步序列的能力。
 */

// MARK: - 背压
/*
 在处理一些 UI 的问题时，比如对超大量的数据进行弹幕渲染，于用户来说可能是没有意义的。因此使用 bufferingOldest 或 bufferingNewest 丢弃一部分数据，有时候可以帮助我们更合理地完成任务。但是对于像是文件复制这样的工作，显然不能采用“丢弃”的方式来粗暴处理。为了避免数据堆积导致的缓冲区爆炸，我们需要一种方式来协调向缓冲区写入的速度和从缓冲区读取的速度。用文件复制的例子来说，就是限制其读取速度，让它和写入速度相匹配。换言之，在 AsyncStream 中，这意味着只有在 for await 中请求下一个元素时，序列才生成并提供这个元素。
 在事件处理和响应式编程中，我们借用一个流体力学的术语，把这种由数据消耗端按照自己的速率来控制数据发生端的行为，叫做狭义的背压 (backpressure)。AsyncStream 除了接受 build 闭包的初始化方法外，还提供了一个直接返回数据元素的初始化方法，它可以让我们使用背压的方式控制异步序列的产生：
 struct AsyncStream<Element> {
 
    init(unfolding produce: @escaping () async -> Element?, onCancel: (@Sendable () -> Void)? = nil){}
 }
    参数的 unfolding 将被用作序列迭代器的 next 函数，每当 for await 请求值时，它会被调用并生成一个新的值。
    用这个初始化方法，我们可以创建一个类似于上面的 timer stream。只不过它的行为略有不同：
        它不再是由 Timer 驱动并自动填充缓冲区，而是在每次数据消耗者进行 for await 时，等待一秒并返回序列中的下一个值：

 */
func test1() async {
    let timerStream3 = AsyncStream<Date>{
        await Task.sleep(NSEC_PER_SEC)
        return Date()
    } onCancel: { @Sendable in
        print("onCancel ed")
    }
    
    for await v in timerStream3 {
        print(v)
    }
}
// 实际看起来效果和之前 Timer 驱动的序列并无二致，但实际上现在序列的发送已经由使用方来决定了，序列也不再涉及缓冲区的问题。

// MARK: - 序列完结
/*
    AsyncStream 和 with*Continuation 有一些相似：
        它们同样捕获并提供一个续体用来操作。with*Continuation 中要求 continuation 的 resume 调用且仅调用一次，来表征异步函数从续体中以成功或者失败的结果继续，多次调用 resume 将导致意外行为。
    
    在前面的例子中，我们已经看到了 AsyncStream 的用法。其中 continuation 的 yield 可以被多次调用以产生若干序列值。通过调用 continuation 的 finish 方法，则可以终结一个序列。
    不过，在 AsyncStream 终结后，你依然可以继续使用 yield 发送数据。下面的代码是完全合法的
 
    continuation.yield(Date())
    continuation.yield(Date())
    continuation.finish()
    // 序列结束后再次 yield
    let result = continuation.yield(Date())
    // result: YieldResult.terminated
 
    调用 finish 方法或者取消运行序列的任务，都会让序列续体进入到完结状态。之后的 yield 并不会将数据写入缓冲区，而是直接返回 .terminated 来告诉 AsyncStream 已经完结了。在某些情况下，除了 onTermination 外，也可以通过这个 yield 的 .terminated 返回来进行资源的清理工作 (比如例中让 Timer 无效化)。但是这样做会导致清理工作依赖于终结后的下一次事件，让待清理的资源的生命周期变长，因此并不推荐这么做。
    
    AsyncStream 本身是 struct，但为了保证单次遍历，它的内部使用了引用语义的 class 作为存储，来对序列的当前状态进行维护。在调用 continuation 上的方法时，实际上是对这个状态进行检查和设置。这涉及到用锁进行数据同步，也是这些方法可以随意调用的代价。事实上，在创建一个 AsyncStream 时，我们应该尽量避免在序列完结后再次发送数据的行为，这样不论对使用者和维护者来说，都可以减轻心智模型上的负担。
 */

// MARK: - 多任务迭代

