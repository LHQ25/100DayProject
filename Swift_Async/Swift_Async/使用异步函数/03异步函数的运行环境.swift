//
//  03异步函数的运行环境.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/7.
//

import Foundation
/*
 和可抛出错误的函数一样，异步函数也具有“传染性”：
    由于运行一个异步函数可能会带来潜在的暂停点，因此它必须要用 await 明确标记。
    而 await 又只能在 async 标记的异步函数中使用。于是，将一个函数转换为异步函数时，往往也意味着它的所有调用者也需要变成异步函数。
 
 处理 throws 时，在最上层，我们会使用 do 的代码块来提供一个可抛出的环境，并在 catch 中捕获错误。
 类似地，对于异步函数的使用，我们也可以“追溯”到一个最上层：
    它作为初始环境，为其他的异步函数运行提供合适的环境。
 */

// MARK: - Task 相关 API
/*
 将代码从同步世界“转接”到异步世界时，最重要也是最常使用的方法是利用 Task 的相关 API 创建任务环境。
 Task.init 和 Task.detached 都能在当前环境中创建一个非结构化的任务上下文，
 它们的主要区别在于是否从当前上下文 (如果存在的话) 中继承一些特性。
 简单来说，如果你想要在当前同步上下文中，开启一个异步上下文来调用异步方法的话，大多数情况下 Task.init 是最佳选择，这个初始化方法接受一个类型为 () async -> Success 的异步闭包，你可以在里面调用其他的异步函数
 */
func asyncMethod() async -> Bool {
    try? await Task.sleep(nanoseconds: 1000)
    return true
}
func syncMethod() {
    Task {
        await asyncMethod()
    }
}
/*
 这个异步闭包的返回值是 Success，它也会作为 Task 执行结束后的结果值，被传送到自身上下文之外。如果你是在一个异步上下文中创建 Task 的话，还可以通过访问它的 value 属性来获取任务结束后的“返回值”：
 */
func anotherAsyncMethod() async {
    let task = Task {
        await asyncMethod()
    }
    let result = await task.value
    debugPrint(result) // true
}

// MARK: - @main 提供异步运行环境
/*
 如果你要创建的不是一个 iOS 或者 macOS app，而是一个 Swift 的命令行工具或者 server 端程序的话，会需要一个明确的 main 函数作为入口。从 Swift 5.3 开始，可以使用 @main 来标记一个基于类型的程序入口。在引入 Swift 并发后，对于被标记的 @main 类型，我们可以直接将 main 函数声明为 async。这样一来，程序开始时我们就可以拥有一个异步运行环境了：
 @main
 struct MyApp {
    static func main() async {
        await Task.sleep(NSEC_PER_SEC)
        print("Done")
    }
 }
 
 一切异步函数都需要自己的任务运行环境，main 也不例外。
 @main 所标记的类型作为程序入口，会被整个程序传统意义上“真正的” main 函数 (它是一个同步函数) 调用。
 上面的程序编译后，相当于在真正的 main 中执行了：
 
    除了 @main 标记的基于类型的的程序入口外，我们也可以直接在 main.swift 顶层调用异步函数。实际上这种做法 Swift 也会用相同的方式为我们创建一个游离的任务环境
 */

// MARK: - SwiftUI
// 为了能在 SwiftUI 中简单地使用异步函数，Apple 为 View 添加了一个 task modifier：
