//
//  Async_Sequences_2.swift
//  Swift_Async
//
//  Created by 9527 on 2022/6/26.
//

import Foundation

//MARK: - 异步序列
/*
 async/await 定义的异步函数，提供了一种直观的方式定义“未来”：
 可以认为异步函数将会返回未来某个时间点的值。
 如果我们希望表达的不是未来某一个时间点的值，而是未来一系列多个时间点的值，会需要使用一种新的表达方式，那就是异步序列 (Async Sequences)。

 在同一个异步函数中，await 的次数是不受限制的。
 也就是说，一个异步函数的执行，可以暂停多次。
 每次暂停异步函数的剩余部分会形成新的续体，并在暂停完成后等待底层调度将控制权重新返回当前异步函数。
 因此，一个异步函数是可以获取到多个未来时间点的值的。
 当这些值具有某种联系，成为一个序列时，我们可以将它们进行抽象，并用一个协议 (protocol) 来规定它们的重要特性。
 这个协议就是异步序列 AsyncSequence。
 异步序列在 Apple SDK 的一些地方都有体现，也是结构化并发的构成要件之一。
 */

public protocol AsyncSequence {
   associatedtype AsyncIterator : AsyncIteratorProtocol
   func makeAsyncIterator() -> Self.AsyncIterator
}

class AsyncSequenceDemo: NSObject {
    
    //MARK: 1 同步序列和异步序列
    /*
     序列 (Sequence)。它是 Swift 标准库中一个非常基本的协议，用来定义可以通过逐个迭代列举 (iterate) 而得到的一系列值。
     在同步世界中，Sequence 事实上做的事情就是定义如何产生一个迭代器 (Iterator)：

     public protocol Sequence {
        associatedtype Iterator : IteratorProtocol
        func makeIterator() -> Self.Iterator
     }
     
     Iterator 类型需要遵守的 IteratorProtocol 更加简单，它只需要一个 next 方法：
     在被调用时，如果序列中还有值，那么就返回这个值，如果序列已经结束，则返回 nil：

     public protocol IteratorProtocol {
        associatedtype Element
        mutating func next() -> Self.Element?
     }

     一般来说，只有在实现一个自定义序列类型的时候，才需要关心迭代器。
     除此之外，你几乎不会直接去使用它，因为 for 循环才是我们在遍历序列时最常用的方式。
     定义序列的最直接的好处，是让编译器在处理 for 循环时，可以将它简单地视为一个语法糖。对于这样的代码
     for element in someSequence {
        doSomething(with: element)
     }
     
     大部分序列的迭代器都只产生有限序列，因此 iterator.next() 最终会返回 nil，并让 while 终止。但是也完全可以实现一个无限序列
     
     Sequence 提供的只是一个用于创建迭代器的入口。而实际持有序列信息的角色，是迭代器本身。

     在 FibonacciSequence 中，迭代器对 next 的计算十分简单。但是同步序列的 next() 方法和其他同步方法一样，是可能会造成阻塞的。
     如果我们能将 next 写为异步函数，那么在获取序列中下一个元素时，这个迭代器将有能力放弃自己执行的线程，从而避免阻塞。
     这种支持异步函数方式求值的序列，就是异步序列
     */
    
    //MARK: - 2. 异步迭代器
    /*
     异步序列也是由一个协议定义的：

     public protocol AsyncSequence {
        associatedtype AsyncIterator : AsyncIteratorProtocol
        func makeAsyncIterator() -> Self.AsyncIterator
     }
     除了要求异步版本的迭代器，它在结构上和 Sequence 是完全一致的。你可以已经猜到了，异步迭代器的协议 AsyncIteratorProtocol 中，除了 next 是一个异步函数以外，其他也和同步版本的 IteratorProtocol 一样
     
     protocol AsyncIteratorProtocol {
        associatedtype Element
        mutating func next() async throws -> Self.Element?
     }
     next 在这里被标记为 async 并具备 throws 的能力，这些定义赋予了异步序列更多的可能性。
     比如，通过某个网络 API 去获取。这时 next 将涉及潜在的暂停点
     */
    struct AsyncFibonacciSequence: AsyncSequence {
        typealias Element = Int
        
        struct AsyncIterator: AsyncIteratorProtocol {
            var currentIndex = 0
            mutating func next() async throws -> Int? {
                defer { currentIndex += 1 }
                return try await loadFibNumber(at: currentIndex)
            }
            
            func loadFibNumber(at index: Int) async throws -> Int? {
                // 网络获取
                return nil
            }
            
            // 对于涉及到的 loadFibNumber，为了简化，我们用一个 Task.sleep 来模拟这个耗时操作。
            func loadFibNumber(at index: Int) async throws -> Int {
                // 使用 Task.sleep 模拟 API 调用...
                await Task.sleep(NSEC_PER_SEC)
                return fibNumber(at: index)
            }
            
            func fibNumber(at index: Int) -> Int {
                if index == 0 { return 0 }
                if index == 1 { return 1 }
                return fibNumber(at: index - 2) + fibNumber(at: index - 1)
            }
        }
        
        func makeAsyncIterator() -> AsyncIterator {
            .init()
        }
    }
    
    //MARK: - 2.1 for await
    /*
     为异步序列定义类似的结构，其主要目的是为了能让开发者用类似的 for...in 的语法，简单地对异步序列中的元素进行迭代。
     不过和同步序列不同的是，异步序列中的获取每个元素时都是一个潜在暂停点，因此需要 await 明确标记。
     对上面定义的异步斐波那契序列的使用如下
     */
    let asyncFib = AsyncFibonacciSequence()
    /*
     
     for try await v in asyncFib {
        if v < 20 {
            print("Async Fib: \(v)")
        } else {
            break
        }
     }
     这段代码将从 0 开始列举小于 20 的斐波那契数。因为在获取每个元素时我们进行了等待，因此可以在控制台上看到每隔一秒才会进行一次输出。
     和同步序列一样，编译器在遇到 for await 时，依然会将它“翻译”成 while let 的版本：此时 next 是异步函数的事实，强制我们使用 await 对它进行调用。上面的代码等效于：

     let asyncFib = AsyncFibonacciSequence()
     var iter = asyncFib.makeAsyncIterator()
     while let v = try await iter.next() {
        // ...
     }
     */
    
    //MARK: - 2.2 异步迭代器的值语义
    /*
     对于上面的 AsyncFibonacciSequence 的使用，有一个有趣的问题，那就是在 v < 20 的条件不再满足，序列迭代停止后，如果再次开始迭代序列，会是怎样的结果？
     也就是说，下面的代码会输出什么？

     let asyncFib = AsyncFibonacciSequence()
     for try await v in asyncFib {
        if v < 20 {
            // continue
        } else {
            break
        }
     }
     
     for try await v in asyncFib {
        print("Next value: \(v)")
     }
     
     它会是从头开始的第一个数字 0 呢？还是会是数列中大于 20 的后一个数字 34？(对于数列 ..5, 8, 13, 21, 34 ..，当迭代到 21 时跳出第一个 for await 循环，数列中的下一个数字应该是 34)。

     我们知道，当每次使用 for 语句开始迭代时，makeAsyncIterator 函数都会被调用，返回一个迭代器。
     在当前的 AsyncFibonacciSequence 实现中，每次的迭代器都是全新的，因此在调用 next 进行迭代时，迭代器总是从最初的状态开始。
     所以上面的代码会输出 0。这种情况下，序列满足值语义 (value semantic)：任意的两次迭代互相不会产生影响，它们是独立存在的。到目前为止，我们看到的迭代器都满足值语义。
     */
    
    //MARK: - 2.3 引用语义迭代器和单次遍历
    /*
     不排除有一些情况下，我们会希望数列从中断的地方继续执行，而不是从头开始。
     比如 loadFibNumber 的时候网络出现了暂时的错误，而在我们处理完这个错误后，发现对序列的加载是可以继续进行的，我们可能会希望获取序列中的下一个数字，而非从头开始。
     这类需求可以进一步引申到像是 UI 产生的事件流、下载的断点续传、I/O 读写等等。
     这类问题在日常中其实并不罕见，这时候我们就需要序列只能被遍历一次，它需要具有引用语义 (reference semantic)。

     要将 AsyncFibonacciSequence 按照引用语义进行改写，最简单的方式就是让 makeAsyncIterator 返回同一个 iterator。为了做到这一点，我们可以将序列和迭代器都改成 class，并在序列中持有一个 iterator：
     */
    // 将序列改为 class
    class ClassFibonacciSequence: AsyncSequence {
        // 将迭代器改为 class
        class AsyncIterator: AsyncIteratorProtocol {
            func next() async throws -> Int? {
                defer { currentIndex += 1 }
                return try await loadFibNumber(at: currentIndex)
            }
            
            typealias Element = Int
            var currentIndex = 0
            
            // 对于涉及到的 loadFibNumber，为了简化，我们用一个 Task.sleep 来模拟这个耗时操作。
            func loadFibNumber(at index: Int) async throws -> Int {
                // 使用 Task.sleep 模拟 API 调用...
                await Task.sleep(NSEC_PER_SEC)
                return fibNumber(at: index)
            }
            
            func fibNumber(at index: Int) -> Int {
                if index == 0 { return 0 }
                if index == 1 { return 1 }
                return fibNumber(at: index - 2) + fibNumber(at: index - 1)
            }
        }
        
        // 保存当前的迭代器
        private var iterator: AsyncIterator?
        
        // 如果已经存在迭代器了，则直接使用它
        func makeAsyncIterator() -> AsyncIterator {
            if iterator == nil {
                iterator = .init()
            }
            return iterator!
        }
    }
    /*
     这样，即使中断了，在 makeAsyncIterator 被调用时，迭代器中的 currentIndex 会是之前停止时的最终值，对于序列的遍历将继续下去。

     在之前的实现中，AsyncSequence 和 AsyncIteratorProtocol 是不同的类型：前者负责提供统一接口，创建迭代器；
     后者负责计算和存储状态，它是实际上负责产生序列值的类型。我们可以让 AsyncSequence 本身满足 AsyncIteratorProtocol，这样能将状态存储在自身，从而更简单地提供引用语义。
     只需要将 currentIndex 提取出来，用引用语义包装，就能得到一个单次遍历的更简单的实现了
     */
    class Box<T> {
        var value: T
        init(_ value: T) { self.value = value }
    }
    struct BoxedAsyncFibonacciSequence: AsyncSequence, AsyncIteratorProtocol {
        typealias Element = Int
        var currentIndex = Box(0)
        mutating func next() async throws -> Int? {
            defer { currentIndex.value += 1 }
            return try await loadFibNumber(at: currentIndex.value)
        }
        func makeAsyncIterator() -> Self {
            self
        }
        
        // 对于涉及到的 loadFibNumber，为了简化，我们用一个 Task.sleep 来模拟这个耗时操作。
        func loadFibNumber(at index: Int) async throws -> Int {
            // 使用 Task.sleep 模拟 API 调用...
            await Task.sleep(NSEC_PER_SEC)
            return fibNumber(at: index)
        }
        
        func fibNumber(at index: Int) -> Int {
            if index == 0 { return 0 }
            if index == 1 { return 1 }
            return fibNumber(at: index - 2) + fibNumber(at: index - 1)
        }
    }
    /*
     在后面关于结构化并发和 TaskGroup 相关的部分，我们会看到相关的任务管理的 API 也是具有引用语义的异步序列。
     这种单次遍历的特点，将保证任务不会被 (错误地) 多次执行。
     另外，在那边我们还会看到如何处理序列的取消操作，以及要特别注意的相关事项
     */
    
    //MARK: - 操作异步序列
    /*
     大部分同步序列上的扩展方法，比如 map，filter，contains 等，在异步序列中也是存在的。
     因此，基本上来说，只要你会使用同步序列，那么这些概念在异步序列中是完全共通的。

     // 从斐波那契数列中取前五个偶数，乘以 2 并输出。
     let seq = AsyncFibonacciSequence()
        .filter { $0.isMultiple(of: 2) }
        .prefix(5)
        .map { $0 * 2 }
        
     for try await v in seq {
        print(v)
     }
     // 输出：
     // 0 4 16 68 288
     */
}

