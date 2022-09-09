//
//  05Async_Getter.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation

//MARK: - 4 Async getter
//MARK: - 4.1 异步只读属性
/*
 我们解决了将函数标记为异步的问题，但对于另一种常见的“函数”，还没有进行定义：那就是计算属性。
 除了不接受参数以外，其实计算属性，特别是 getter，和一般函数非常类似：
*/
class File {
    
    var size: Int {
        return heavyOperation()
    }
    
    func heavyOperation() -> Int {
        // 很慢的操作，比如大量 I/O
        return 12313
    }
    
    // 一种解决方式是放弃使用 getter，转而使用回调函数：
    func getSize(completionHandler: @escaping (Int) -> Void) {
        // ...
    }
}

/*
 一般来说，我们都倾向于不在 getter 中进行复杂的耗时工作。
 但是编译器并没有阻止我们在 getter 里进行阻塞线程的长时间操作。
 不论这是由于代码最初书写时候的情况和现在相比已经沧海桑田，年久失修，还是因为 getter 中所使用的别的 API 发生了变化，总之“不在 getter 中进行耗时操作”的假设是人为且脆弱的，编译器并没有对此提供任何保证。
 一旦这种情况发生，对于这个 getter 属性的访问，就可能导致卡顿
 
 但是 getXXX 的写法显得非常不 Swift，并带来了一些重复和模板代码。
 如果类型 API 中同时存在 size getter 和 getSize(completionHandler:) 的话，我想绝大部分使用者会跳过你辛苦准备的文档和苦口婆心的劝告，无脑选择更“简单”的 getter 计算属性。

 除了无法异步操作外，现有 getter 还有另一个问题，那就是无法抛出错误。诚然，我们可以使用返回 nil 可选值来表示错误。
 这种方法可以解决部分问题，但是如果对于 getter 返回值原本就可能使用 nil 表示空值的情况，我们就无法分辨 getter 到底是成功取到了空，还是取值过程中发生了错误。
 另一种选择是返回 Result 来表征错误，不过这样做的话调用方就需要对 Result 的结果进行判断，很快代码的逻辑会被无关核心部分的额外处理淹没，这也不是理想的解决方案
 
 
 在 Swift 5.5 中，getter 得到的强化，它可以使用 async 和 throws 修饰了。上面的 File.size 可以写成 get async throws 的异步 getter
 */

class File2 {
    
    var corrupted: Bool = false
    
    var size: Int {
        get async throws {
            if corrupted {
                 throw NSError()  // 暂不实现
            }
            return try await heavyOperation()
        }
    }
    func heavyOperation() async throws -> Int {
        // ...
        return 0
    }
    
    func reportFileSize() async throws {
        
        // 在使用上，和普通的异步函数类似。因为 async 的 size 现在代表了一个潜在的暂停点，因此对它的调用必须发生在异步环境中，并使用 await：
       let file = File2()
       print("File size is: \(try await file.size)")
    }
    
    enum AttributeKey: Int {
        case a
    }
    
    struct Attribute {
        
    }
    
    func loadAttributes() async -> [Attribute] {
        
        return .init()
    }
    
    // 下标方式
    subscript(_ attribute: AttributeKey) -> Attribute {
        // 比如 await file[.readonly] == true
        get async {
            let attributes = await loadAttributes()
            return attributes[attribute.rawValue]
        }
    }
}
/*
 可以明确地通过 async getter 让编译器提示使用者，这个 getter 可能会耗费较长时间，并避免意外造成的阻塞了。

 异步 getter 在 actor 模型中非常常用：
    actor 的成员变量是被隔离在 actor 中的，外部对它的获取将导致隔离域切换，这是一个潜在的暂停。
    对于从隔离域外对 actor 中成员变量的读取，编译器将为我们合成对应的异步 getter 方法。

 除了 getter 以外，通过下标的读取方法也得到了同样的特性，来提供类似的 async 和 throws 的支持
 */

//MARK: - 4.2 状态依赖
/*
 await 表示了潜在的暂停点，它在程序中并没有实际的语义，更多的是对开发者的一种警示：
 在 await 前后，程序可能会运行在两个世界中。
 在支持异步后，getter 可能会代码中的其他状态“纠缠”起来，在 await 前后我们我们对某个状态进行假设时，需要特别小心。
 */

func prepare() async {
    // do somethings
}

var loaded: Bool = false
var shouldLoad: Bool {
    get async {
        if !loaded {
            await prepare()
            return true
        }
        return false
    }
}

func load() {
    loaded = true
    // ...
}

/*
 异步 getter 的 shouldLoad 应该在 loaded 为 false 时返回 true，告诉调用者此时应当进行加载。
 但是 await prepare() 将使程序暂停。
 和同步函数不同，loaded 的状态可能会在 prepare 执行期间发生变化，比如在暂停期间 load() 函数被外部调用了。
 “正是由于 loaded 原本为 false，所以程序才进到了 await prepare() 条件语句”的这个假设，在 await 之后可能是不成立的。
 如果在准备期间 load 被调用了，那其实此时 loaded 已经为 true，这时候是否还应该按照“loaded 为 false”的假设，为 shouldLoad 返回 true 呢？这需要成为开发者深入考虑的问题。

 对于上面的特定的例子，也许再次检查 loaded 并根据最新值进行返回会是更好的选择
 */

//MARK: - 4.3 setter
/*
 async 和 throws 的支持，现在只针对属性 getter 和下标读取。
 对于计算属性的 setter 和下标写入，异步行为暂时还不支持。
 这并非因为技术上的不可实现，更多的是对于复杂度的考虑，因此将它们排入了较低优先级。

 这里提到的复杂度，在于各种 setter 的附加行为。
 相对于 getter 来说，setter 需要考虑的事情要更多。
 想要为 setter 定义 async 的话，需要考虑的内容至少包括 inout 的行为，didSet 和 willSet 应该在何时调用，属性包装 (Property wrapper) 要怎么处理等话题。
 为 getter 定义异步行为是相对比较简单，而且能为实际编程提供很大帮助的“高性价比”努力。
 相对起来，对 setter 的支持则被延后了。

 如果只是单纯地需要对某个属性以异步方式进行设置，以便在设置属性的同时执行某些耗时操作，我们可以直接暴露一个异步函数
 */

func someOtherAsyncWork() async {
    
}

func checkCanWrite() throws {
    
}

var value: String = ""
func setValue(v: String) async throws {
    await someOtherAsyncWork()
    try checkCanWrite()
    value = v
}
/*
 这可能会带来部分模板代码，但是最大限度保留了兼容性：
    和 setter 相关的 hook 方法 (willSet，didSet) 以及围绕 setter 的其他特性，都不会发生变化。
    在未来的 Swift 版本中，也许我们能看到内建的对 setter 和下标写入的异步支持
 */
