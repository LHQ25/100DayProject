//
//  03结构化并发.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation

func loadFromDatabase() async throws -> [String] {
    // 假装获取数据
    return ["1234"]
}

func loadSignature() async throws -> String? {
    
    let (data, _) = try await URLSession.shared.data(from: URL(string: "http://127.0.0.1:8000/colors")!)
    return String(data: data, encoding: .utf8)
}

/*
  围绕着 Task 这一核心类型，为每一组并发任务构建出一棵结构化的任务树：
    一个任务具有它自己的优先级和取消标识，它可以拥有若干个子任务并在其中执行异步函数。
    当一个父任务被取消时，这个父任务的取消标识将被设置，并向下传递到所有的子任务中去。
    无论是正常完成还是抛出错误，子任务会将结果向上报告给父任务，在所有子任务完成之前 (不论是正常结束还是抛出)，父任务是不会完成的。
 */
func someSyncMethod() {
    Task {
        try await processFromScratch()
        print("Done \(results)")
    }
}

/* processFromScratch 中的处理依然是串行的：对 loadFromDatabase 的 await 将使这个异步函数在此暂停，直到实际操作结束，接下来才会执行 loadSignature */
//func processFromScratch() async throws {
//
//    let strings = try await loadFromDatabase()
//    if let signature = try await loadSignature() {
//        strings.forEach {
//            results.append($0.appending(signature))
//        }
//    }else{
//        fatalError()
//    }
//}

func processFromScratch() async throws {
    
    /*
     async let 被称为异步绑定，它在当前 Task 上下文中创建新的子任务，并将它用作被绑定的异步函数 (也就是 async let 右侧的表达式) 的运行环境。
     和 Task.init 新建一个任务根节点不同，async let 所创建的子任务是任务树上的叶子节点。
     被异步绑定的操作会立即开始执行，即使在 await 之前执行就已经完成，其结果依然可以等到 await 语句时再进行求值。
     在下面的例子中，loadFromDatabase 和 loadSignature 将被并发执行。
     */
    
    async let loadStrings = loadFromDatabase()
    async let loadSignature = loadSignature()
    
    results = []
    
    let strings = try await loadStrings
    if let signature = try await loadSignature {
        strings.forEach {
            results.append($0.appending(signature))
        }
    }else{
        fatalError()
    }
}

// 模拟 实际事件

func loadResultRemotely() async throws {
    
    // 模拟网络加载延时
    try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
    results = ["1", "2", "3"]
}

/* 除了 async let 外，另一种创建结构化并发的方式，是使用任务组 (Task group)。
 比如，我们希望在执行 loadResultRemotely 的同时，让 processFromScratch 一起运行，可以用 withThrowingTaskGroup 将两个操作写在同一个 task group 中
 */
func someSyncMethod2() {
    Task {
        await withThrowingTaskGroup(of: Void.self, body: { group in
            
            group.addTask {
                try await loadResultRemotely()
            }
            // 对于 processFromScratch，我们为它特别指定了 .low 的优先级，这会导致该任务在另一个低优先级线程中被调度
            group.addTask(priority: .low) {
                try await processFromScratch()
            }
        })
        print("Done: withThrowingTaskGroup")
    }
}

/*
 withThrowingTaskGroup 和它的非抛出版本 withTaskGroup 提供了另一种创建结构化并发的组织方式。
 当在运行时才知道任务数量时，或是我们需要为不同的子任务设置不同优先级时，我们将只能选择使用 Task Group。
 在其他大部分情况下，async let 和 task group 可以混用甚至互相替代
 
 闭包中的 group 满足 AsyncSequence 协议，它让我们可以使用 for await 的方式用类似同步循环的写法来访问异步操作的结果。
 另外，通过调用 group 的 cancelAll，我们可以在适当的情况下将任务标记为取消。
 比如在 loadResultRemotely 很快返回时，我们可以取消掉正在进行的 processFromScratch，以节省计算资源
 */

