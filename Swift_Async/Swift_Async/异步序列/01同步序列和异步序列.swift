//
//  01同步序列和异步序列.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation
//MARK: 1 同步序列和异步序列
/*
 序列 (Sequence)。它是 Swift 标准库中一个非常基本的协议，用来定义可以通过逐个迭代列举 (iterate) 而得到的一系列值。
 在同步世界中，Sequence 事实上做的事情就是定义如何产生一个迭代器 (Iterator)：

public protocol aaa: Sequence {
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
 
 // 可以理解为转换成
 
 var iterator = someSequence.makeIterator()
 while let element = iterator.next() {
 doSomething(with: element)
 }
 
 大部分序列的迭代器都只产生有限序列，因此 iterator.next() 最终会返回 nil，并让 while 终止。但是也完全可以实现一个无限序列
 
 Sequence 提供的只是一个用于创建迭代器的入口。而实际持有序列信息的角色，是迭代器本身。

 在 FibonacciSequence 中，迭代器对 next 的计算十分简单。但是同步序列的 next() 方法和其他同步方法一样，是可能会造成阻塞的。
 如果我们能将 next 写为异步函数，那么在获取序列中下一个元素时，这个迭代器将有能力放弃自己执行的线程，从而避免阻塞。
 这种支持异步函数方式求值的序列，就是异步序列
 */
struct FibonacciSequece {
    
    struct Iterator: IteratorProtocol {
        var state = (0, 1)
        
        mutating func next() -> Int? {
            let upcomingNumber = state.0
            state = (state.1, state.0 + state.1)
            return upcomingNumber
        }
        
        func makeiterator() -> Iterator {
            .init()
        }
    }
}
/*
 Sequence 提供的只是一个用于创建迭代器的入口。
 而实际持有序列信息的角色，是迭代器本身。
 在 FibonacciSequence 中，迭代器对 next 的计算十分简单。
 但是同步序列的 next() 方法和其他同步方法一样，是可能会造成阻塞的。
 如果我们能将 next 写为异步函数，那么在获取序列中下一个元素时，这个迭代器将有能力放弃自己执行的线程，从而避免阻塞。
 这种支持异步函数方式求值的序列，就是异步序列
 */
