//
//  04Actor模型和数据隔离.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation

// 资源竞争的问题导致出现的一种新的数据模型
/*
 Swift 并发引入了一种在业界已经被多次证明有效的新的数据共享模型，actor 模型 (参与者模型)，来解决这些问题。
 可以认为 actor 就是一个“封装了私有队列”的 class。将 class 改为 actor，我们就可以得到一个 actor 类型。
 这个类型的特性和 class 很相似，它拥有引用语义，在它上面定义属性和方法的方式和普通的 class 没有什么不同
 */

actor Holder {
    
    var results: [String] = []
    
    func setResults(_ results: [String]) {
        self.results = results
    }
    
    func append(_ value: String) {
        results.append(value)
    }
    
    /*
     actor 内部会提供一个隔离域：
        在 actor 内部对自身存储属性或其他方法的访问，比如在 append(_:) 函数中使用 results 时，可以不加任何限制，这些代码都会被自动隔离在被封装的“私有队列”里。
        但是从外部对 actor 的成员进行访问时，编译器会要求切换到 actor 的隔离域，以确保数据安全。
        在这个要求发生时，当前执行的程序可能会发生暂停。
        编译器将自动把要跨隔离域的函数转换为异步函数，并要求我们使用 await 来进行调用。

     虽然实际底层实现中，actor 并非持有一个私有队列
     */
}

func processFromScratch_actor() async throws {

    async let loadStrings = loadFromDatabase()
    async let loadSignature = loadSignature()
    
    // results = []
    // 在访问相关成员时，添加 await 即可
    var holder = Holder()
    await holder.setResults([])
    
    let strings = try await loadStrings
    if let signature = try await loadSignature {
        strings.forEach {
            results.append($0.appending(signature))
        }
    }else{
        fatalError()
    }
}
