//
//  05异步序列和响应式编程.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/7.
//

import Foundation
import Combine
import UIKit

/*
 AsyncStream 允许我们将一系列事件 (包括正常事件值、结束、以及错误) 通过续体的形式转换为一个异步序列。
 如果你对 Combine 框架比较熟悉的话，可能还记得其中的 Publisher 也正代表了这样一个事件流。
 因为它们所代表的数据模型一致，所以将任意 Publisher 转换为异步序列是轻而易举的，只需要用 AsyncStream 进行简单包装即可
 */
extension Publisher {
    
    var asAsyncStream: AsyncThrowingStream<Output, Error> {
        AsyncThrowingStream(Output.self){ continuation in
            let cancelable = sink { completion in
                switch completion {
                case .finished:
                    continuation.finish()
                case .failure(let err):
                    continuation.finish(throwing: err)
                }
            } receiveValue: { output in
                continuation.yield(output)
            }
            
            continuation.onTermination = { @Sendable _ in
                cancelable.cancel()
            }
        }
    }
}
/*
 反过来，把一个异步序列 (不止是 AsyncStream，也包括更一般性的 AsyncSequence) 转换为 Publisher 也并不困难。
 虽然可以互相转换，但是这并不意味着 Combine 和异步序列可以完全等价互换
 */

// 测试
func test_05() {
    
    let stream = Timer.publish(every: 1, on: .main, in: .default)
        .autoconnect()
        .asAsyncStream
    
    Task {
        
        for try await v in stream {
            print(v)
        }
    }
}

// MARK: - 异步序列的错误处理
/*
 最显著的区别来自于它们对于错误的处理方式。
 Combine 的 Publisher 通过 associatedtype 的方式，明确地规定了可能值 Output 和错误值 Failure 的类型。
 进一步，对使用 Operator 进行组合，或者使用 Subscriber 进行订阅时，除了要求可能值的类型一致外，也要求错误值的类型相互匹配。
 另外，对于错误类型的转换，Combine 中也提供了诸如 mapError 和 setFailureType 这类专门处理错误类型的操作。
 可以说，在 Combine 的世界中，所有的错误都是被严格对待的，它们的类型至关重要，且被编译器强制保证。
 
 而另一方，Swift 函数，包括异步序列，在遇到错误时都是使用 throw 来进行的。想要一个异步序列支持错误处理，我们会使用支持错误抛出的 AsyncThrowingStream：
 */
func test_06() {
    Task {
        var s: AsyncThrowingStream<Int, Error>!
        do {
            for try await v in s {
                //...
            }
        } catch  {
            print(error)
        }
    }
}
/*
 在 catch 中，将捕获的 error: Error 转换为实际的 MyError，需要一个 if let 绑定。
 而且这个转换并没有很强的编译器保证：
    即使 s 类型的错误类型在之后变成了其他类型，使用侧的代码依然能够无警告地编译通过。
    这时 catch 中的这个转换将会失败，这让我们非常容易在重构或者外部库升级时错过应有的处理。
 
 究其原因，这在于 throw 永远不会抛出一个具体的 Error 类型。
 关于 throw 是否应该抛出强类型错误这个问题，从 Swift 支持 throw 后就一直是社区争论的焦点。
 社区开发者们对 Combine 的错误处理方式表现出一致的满意，但如果在 throw 中加入强类型，也可能导致抛出错误的类型层层叠加，最终变得十分复杂。
 除了仔细检查，并用测试用例对错误转换方面进行覆盖以外，当前我们似乎并没有什么更好的选择来处理这个问题
 */

// MARK: - 调度和执行
/*
 在涉及到执行方式和时间维度时，Combine 使用 Scheduler 协议进行抽象。
 通过指定调度器 (scheduler)，Combine 实现了一系列有关时间的操作 (比如 delay、debounce 和 throttle 等)，并可以在下游指定谁应该接收事件 (使用 receive(on:options:))。
 通过调度器，Combine 可以很灵活地组织和自定义异步事件的行为，为整个框架的使用提供了相当的便利。
 
 而相对来说，异步序列的调度和执行就要僵硬一些。
 包括异步序列在内的异步函数必须在某个任务中运行，而在什么时间什么线程上运行这些任务，则是由内部的执行器 (executor) 来决定的。
 Swift 的并发模型提供了几种默认的内建执行器，它们的主要目标是保证续体切换的性能或者保证数据安全。
 现在 Swift 并发还不支持自定义执行器，所以我们没有太多方法来干涉异步序列的执行方式。
 对于很多 Combine 中内建存在的 Publisher 或者轻而易举就能实现的事件流，在异步序列中实现起来可能要困难一些。
 
 正如其名，Combine 更擅长于将不同的事件流进行变形和合并，生成新的事件流：
    它的重点在于为响应式编程范式提供工具。
 而 Swift 异步序列的侧重点有所不同，更多时候，它服务于任务 API 及 actor，用来解决并发编程中的痛点。
 因此单纯地想用 Combine 代替异步序列，或者反过来用异步序列代替 Combine，笔者认为并不是合理的做法。
 */
