//
//  03操作异步序列.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation
//MARK: - 操作异步序列
/*
 大部分同步序列上的扩展方法，比如 map，filter，contains 等，在异步序列中也是存在的。
 因此，基本上来说，只要你会使用同步序列，那么这些概念在异步序列中是完全共通的。
 */
 // 从斐波那契数列中取前五个偶数，乘以 2 并输出。
 let seq = AsyncFibonacciSequence()
    .filter { $0.isMultiple(of: 2) }
    .prefix(5)
    .map { $0 * 2 }
    
// for try await v in seq {
//    print(v) // 输出： 0 4 16 68 288
// }

// MARK: - Sequence 类型和延迟操作
/*
 这些扩展方法大多定义在 AsyncSequence 的 protocol extension 中并返回另一个 AsyncSequence。因此对于所有的 AsyncSequence 类型都适用，这也是为什么上面的各个操作调用可以链式进行的原因。
 不过，对比同步的 Sequence，异步的 AsyncSequence 在返回类型和接受的参数上都有一些区别。拿 Sequence 的 map 举例，它的定义是：
 extension Sequence {
    func map<T>(_ transform: (Self.Element) throws -> T ) rethrows -> [T] {
 }
 
 虽然定义在了 Sequence 上，但是它返回的是数组形式的 [T] (或者写作 Array<T>，[T] 只是它的一种简写)。
 Array 确实满足 Sequence 协议，但它只是一种特殊的序列：
    一个数组的元素是有限的。Sequence.map 做的事情是穷尽整个序列，对其中的每一个元素，把它当作参数去调用 transform，然后把所有的结果作为数组返回。
    当被调用的 Sequence 会产生无限元素时 (就比如斐波那契数列)，map 求值也将没有尽头：next() 会被持续调用并产生一个无限循环:
    // 错误代码
    let f = FibonacciSequence().map { $0 }
 */
// 想要让这样的无限序列也能使用 map，我们可以将原来的序列变形为 LazySequence。通过简单地在原序列上访问 lazy，就可以得到一个这样的“延迟求值”的序列
//let lazySeq = AsyncFibonacciSequence().lazy
// lazySeq: LazySequence<FibonacciSequence>
//let mapped = lazySeq.map { $0 }
// mapped:
// LazyMapSequence<
//    LazySequence<FibonacciSequence>.Elements,
//    LazySequence<FibonacciSequence>.Element
// >

//考察 lazySeq 的类型，可以看到，它现在并不再是普通的 Sequence 或 Array，而变成了一个新序列 LazySequence。这个新类型定义了自己的 map 函数，并返回延迟加载的 LazyMapSequence。通过在这些“内部序列”中增加延迟求值的逻辑，我们可以不再第一时间就对序列中的元素进行变形，而是等到代码实际访问到这些元素时，再对它们进行操作

// MARK: - 异步序列的高阶方法
