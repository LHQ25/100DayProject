//
//  全局actor.swift
//  Swift_Async
//
//  Created by 9527 on 2022/11/17.
//

import Foundation

//MARK: - MainActor

extension DispatchQueue {
    
    // 在使用 DispatchQueue.main 时，有一种做法是先判断当前是否是主线程，如果是的话，则直接执行需要的操作；如果当前不是主线程，那么再进行派发
    static func mainAsyncOrExecute(_ work: @escaping ()->Void) {
        if Thread.current.isMainThread {
            work()
        } else {
            main.async { work() }
        }
    }
}

// MainActor 是标准库中定义的一个特殊 actor 类型。整个程序只有一个主线程，因此 MainActor 类型也只应该提供唯一一个对应主线程的 actor 隔离域。它通过 shared 来提供一个全局实例，以满足这个要求。所有被限制在 MainActor 隔离域中的代码，事实上都被隔离在 MainActor.shared 的 actor 隔离域中

// 整个类型都被标记为 @MainActor：这意味着其中所有的方法和属性都会被限定在 MainActor 规定的隔离域中
@MainActor class C1 {
    func method() {}
}

// 部分方法被标记为 @MainActor
class C2 {
    @MainActor var value: Int?
    @MainActor func method() {}
    func nonisolatedMethod() {}
}

// 定义在全局范围的变量或者函数，也可以用 @MainActor 限定它的作用返回
@MainActor var globalValue: String = ""

class MainActor_Sample {
    
    func foo() async {
        
        Task { await C1().method }
        
        // 在使用它们时，需要切换到 MainActor 隔离域。和其他一般的 actor 一样，可以通过 await 来完成这个 actor 跳跃；
        // 也可以通过将 Task 闭包标记为 @MainActor 来将整个闭包“切换”到与 C1 同样的隔离域，这样就可以使用同步的方式访问 C1 的成员了
        Task { @MainActor in
            
            C1().method
        }
        Task { @MainActor in
            
            globalValue = "hello"
        }
    }
    
    func bar() async {
        await C1().method()
    }
}
