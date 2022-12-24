//
//  03使用续体改写函数.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation

protocol WorkDelegate {
    func workDidDone(values: [String])
    func workDidFailed(error: Error)
}


//MARK: - 3. 使用续体改写函数
/*
 函数体本身要如何“异步化”。
 在异步函数被引入之前，处理和响应异步事件的主要方式是闭包回调和代理 (delegate) 方法。
 可能你的代码库里已经大量存在这样的处理方式了，如果你想要提供一套异步函数的接口，但在内部依然复用闭包回调或是代理方法的话，最方便的迁移方式就是捕获续体并暂停运行，然后在异步操作完成时告知这个续体结果，让异步函数从暂停点重新开始。

Swift 提供了一组全局函数，让我们暂停当前任务，并捕获当前的续体
 func withUnsafeContinuation<T>(_ fn: (UnsafeContinuation<T, Never>) -> Void) async -> T
 func withUnsafeThrowingContinuation<T>(_ fn: (UnsafeContinuation<T, Error>) -> Void) async throws -> T
 func withCheckedContinuation<T>(function: String = #function, _ body: (CheckedContinuation<T, Never>) -> Void) async -> T
 func withCheckedThrowingContinuation<T>(function: String = #function, _ body: (CheckedContinuation<T, Error>) -> Void) async throws -> T
 
 普通版本和 Throwing 版本的区别在于这个异步函数是否可以抛出错误，如果不可抛出，那么续体 Continuation 的泛型错误类型将被固定为 Never。在结构化并发的部分 API 中 (比如 withTaskGroup 和 withThrowingTaskGroup)
 */

//MARK: - 3.1 续体 resume
/*
 在某个异步函数中调用 with*Continuation 后，这个异步函数暂停，函数的剩余部分作为续体被捕获，代表续体的 UnsafeContinuation 或 CheckedContinuation 被传递给闭包参数，而这个闭包也会在当前的任务上下文中立即运行。
 这个 Continuation 上的 resume 函数，在未来必须且仅需被调用一次，来将控制权交回给调用者
 */
func load2(completion: @escaping ([String]?, Error?)->Void) {
    // dosomethings
}
func load2() async throws -> [String] {
    try await withUnsafeThrowingContinuation { continuation in
        load2 { values, error in
            if let error = error {
                continuation.resume(throwing: error)    // 正确返回的情况
            } else if let values = values {
                continuation.resume(returning: values)  // 发生错误的情况
            } else {
                assertionFailure("Both parameters are nil")
            }
        }
        // 当 continuation 上的这两者任一被调用时，整个异步函数要么抛出错误，要么返回正常值
    }
}
/*
 Unsafe 和 Checked 版本的区别在于是否对 continuation 的调用状况进行运行时的检查。
 continuation 必须在未来继续，只是一个开发者和编译器的约定。
 Unsafe 的版本不进行任何检查，它假设开发者会正确使用这个 API：
 如果 continuation 没能继续 (也就是 continuation 在被释放前，它上面的任意一个 resume 方法都没有调用)，
 那么异步函数将永远停留在暂停点不再继续；反过来，如果 resume 被调用了多次，程序的运行状态将出现错误
 
 和 Unsafe 的版本稍有不同，Checked 的版本能稍微给我们一些提示。在没能继续的情况下，运行时会在控制台进行输出
 // SWIFT TASK CONTINUATION MISUSE: load() leaked its continuation!
 
 在调用 resume 多次时，这个错误将产生崩溃
 // 崩溃，错误信息：
 // Fatal error: SWIFT TASK CONTINUATION MISUSE: load()
 // tried to resume its continuation more than once, returning...
 
 由于 Checked 的一系列特性都和运行时相关，因此对续体的使用情况进行检查 (以及存储额外的调试信息)，会带来额外的开销。
 因此，在一些性能关键的地方，在确认无误的情况下，使用 Unsafe 版本会提升一些性能。
 因为除了 Checked 和 Unsafe 之外，两个 API 在语法上并没有区别，所以按照 Debug 版本和 Release 版本的编译条件进行互换也并不困难。
 不过需要记住的是，就算使用 Checked 版本，也不意味着万事大吉，它只是一个很弱的运行时检查：
 对于没有调用 resume 的情况，虽然异步函数会在续体超出捕获域后自动继续，但是没有 resume 的任务依然被泄漏了；
 对于多次调用 resume 的情况，运行时崩溃的严重性更是不言而喻。
 Checked 能做的只是帮助我们更容易地发现这些错误
 */

//MARK: - 3.2 续体暂存
/*
除了在回调版本的异步代码中使用外，我们也可以把捕获到的续体暂存起来，这种方式很适合将 delegate 方式的异步操作转换为异步函数：
 */

class Worker: WorkDelegate {
    
    // 变量 暂时存储
    var continuation: CheckedContinuation<[String], Error>?
    
    func performWork(delegate: WorkDelegate) {
        
        continuation?.resume(returning: [])
    }
    
    func doWork() async throws -> [String] {
        try await withCheckedThrowingContinuation({ continuation in
            self.continuation = continuation
            performWork(delegate: self)
        })
    }
    
    func workDidDone(values: [String]) {
        continuation?.resume(returning: values)
        continuation = nil
    }
    func workDidFailed(error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
/*
 很多时候，delegate 方法可能被调用不止一次,但是作为 continuation 来说，不论成败，它只支持一次 resume 调用。
 通过 resume 调用后将 self.continuation 置为 nil 来避免重复调用。
 根据具体情况，你可能可能会需要选择不同的处理方法。如果一个续体需要被多次调用，并产生一系列值，我们会需要涉及到 AsyncSequence 和 AsyncStream 的使用
 */

//MARK: - 3.3 续体和 Future
/*
 如果你对 Combine 比较熟悉，也许已经隐约感受到，续体和 Future 有一些相似：
 Future 通过提供一个 Promise 来接受未来的 Result<Output, Failure> 值，并提供给订阅者，
 而续体的行为模式也一样，甚至续体版本也准备了接受 Result 类型的重载：
 
 extension CheckedContinuation {
    func resume(with result: Result<T, E>)
 }
 
 在一定程度上，认为 async 函数 (或者更准确说，由续体转换的异步函数) 可以取代 Future：
 同样是在返回一个未来的值，async 显然提供了更加简洁的写法。
 相对于 Combine 基于订阅的使用方式和 Scheduler 决定的线程模型，直接使用异步函数需要操心的地方要少很多。
 但是续体异步函数和 Future 依然有不同。
 异步函数必定在一定的任务上下文之中执行，这个上下文决定了任务的取消状态、优先级等；
 单个 Future 如果不和 Combine 框架中的其他 Publisher 或者 Operators 结合 (combine) 使用的话，它能提供的特性远远不及异步函数丰富
 */
