//
//  02非结构化任务.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/8.
//

import Foundation
/*
 TaskGroup.addTask 和 async let 是 Swift 并发中“唯二”的创建结构化并发任务的 API。
 它们从当前的任务运行环境中继承任务优先级等属性，为即将开始的异步操作创建新的任务环境，然后将新的任务作为子任务添加到当前任务环境中。
 
 除此之外，我们也看到过使用 Task.init 和 Task.detached 来创建新任务，并在其中执行异步函数的方式：
 */
func start_9() async {
    Task {
        await work(1)
    }
    Task.detached {
        await work(2)
    }
    print("End")
}
/*
 这类任务具有最高的灵活性，它们可以在任何地方被创建。
 它们生成一棵新的任务树，并位于顶层，不属于任何其他任务的子任务，生命周期不和其他作用域绑定，当然也没有结构化并发的特性。对比三者，可以看出它们之间明显的不同：

    TaskGroup.addTask 和 async let - 创建结构化的子任务，继承优先级和本地值。
    Task.init - 创建非结构化的任务根节点，从当前任务中继承运行环境：比如 actor 隔离域，优先级和本地值等。
    Task.detached - 创建非结构化的任务根节点，不从当前任务中继承优先级和本地值等运行环境，完全新的游离任务环境。

 有一种迷思认为，我们在新建根节点任务时，应该尽量使用 Task.init 而避免选用生成一个完全“游离任务”的 Task.detached。
 其实这并不全然正确，有时候我们希望从当前任务环境中继承一些事实，但也有时候我们确实想要一个“干净”的任务环境。
 比如 @main 标记的异步程序入口和 SwiftUI task 修饰符，都使用的是 Task.detached。
 具体是不是有可能从当前任务环境中继承属性，或者应不应该继承这些属性，需要具体问题具体分析。
 创建非结构化任务时，我们可以得到一个具体的 Task 值，它充当了这个新建任务的标识。
 从 Task.init 或 Task.detached 的闭包中返回的值，将作为整个 Task 运行结束后的值。
 使用 Task.value 这个异步只读属性，我们可以获取到整个 Task 的返回值：
 */
// 想要访问这个值，和其他任意异步属性一样，需要使用 await：
func start_10() async {
    let t1 = Task { await work(1) }
    let t2 = Task.detached { await work(2) }
    let v1 = await t1.value
    let v2 = await t2.value
}
/*
 一旦创建任务，其中的异步任务就会被马上提交并执行。
 所以上面的代码依然是并发的：
    t1 和 t2 之间没有暂停，将同时执行，t1 任务在 1 秒后完成，而 t2 在两秒后完成。
 await t1.value 和 await t2.value 的顺序并不影响最终的执行耗时，即使是我们先 await 了 t2，t1 的预先计算的结果也会被暂存起来，并在它被 await 的时候给出。
 
 用 Task.init 或 Task.detached 明确创建的 Task，是没有结构化并发特性的。
 Task 值超过作用域并不会导致自动取消或是 await 行为。想要取消一个这样的 Task，必须持有返回的 Task 值并明确调用 cancel：
 */
