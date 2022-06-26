//
//  CreateAsyncFunction.swift
//  Swift_Async
//
//  Created by 9527 on 2022/6/26.
//

import Foundation

protocol WorkDelegate {
    func workDidDone(values: [String])
    func workDidFailed(error: Error)
}

/// 创建异步函数
class CreateAsyncFunction: NSObject {
    
    //MARK: - 1. 线程放弃和暂停点
    /*
     和同步函数最大的不同在于，异步函数可以放弃自己当前占有的线程。
     有一些关于异步函数的讨论，会把异步函数的运行理解为：编译器把异步函数切割成多个部分，每个部分拥有自己分离的存储空间，并可以由运行环境进行调度。
     我们可以把每个这种被切割后剩余的执行单元称作续体 (continuation)，
     而一个异步函数，在执行时，就是多个续体依次运行的结果。

     现在只需要将异步函数想象成和普通函数一样的东西，只不过它具有放弃线程进行暂停，并在稍后再从暂停点继续执行的特殊能力就可以了

     不论是同步函数还是异步函数，对它们的调用只是最简单的 apply 指令。
     异步函数虽然具有放弃线程的能力，但它自己本身并不会使用这个能力：
     它只会通过对另外的异步函数进行方法调用，或是通过主动创建续体，才能有机会暂停。
     这些被调用的方法和续体，有时会要求当前异步函数放弃线程并等待某些事情完成 (比如续体完结)。
     当完成后，本来的函数将会继续执行。

     await 充当的角色，就是标记出一个潜在的暂停点 (suspend point)。
     在异步函数中，可能发生暂停的地方，编译器会要求我们明确使用 await 将它标记出来。
     除此之外，await并没有其他更多的语义或是运行时的特性。
     当控制权回到异步函数中时，它会从之前停止的地方开始继续运行。但是“桃花依旧笑春风”的同时，“人面不知何处去”也会是一个事实：虽然部分状态，比如原来的输入参数等，在 await 前后会被保留，但是返回到当前异步函数时，它并不一定还运行在和之前同样的线程中，
     异步函数所在类型中的实例成员也可能发生了变化。await 是一个明确的标识，编译器强制我们写明 await 的意义，就是要警示开发者，await 两侧的代码会处在完全不同的世界中。

     但另一方面，await 仅仅只是一个潜在的暂停点，而非必然的暂停点,实际上会不会触发“暂停”，需要看被调用的函数的具体实现和运行时提供的执行器是否需要触发暂停。
     很多的异步函数并不仅仅是异步函数，它们可能是某个 actor 中的同步函数，但作为 actor 的一部分运行，在外界调用时表现为异步函数。
     Swift 会保证这样的函数能切换到它们自己的 actor 隔离域里完成执行
     */
    
    //MARK: - 2. 转换函数签名
    /*
     异步函数的目标是使用类似同步的方式来书写异步操作的代码，来修正闭包回调方式的问题，并最终取而代之。
     随着 Swift 并发在将来的普及，相信今后我们一定会遇到需要将回调方式的异步操作迁移到异步函数的情况，这中间很大部分的工作量会落在如何将闭包回调的代码改写为异步函数这件事上
     */
    
    //MARK: - 2.1 修改函数签名
    /*
     对于基于回调的异步操作，一般性的转换原则就是将回调去掉，为函数加上 async 修饰。
     如果回调接受 Error? 表示错误的话，新的异步函数应当可以 throws，最后把回调参数当作异步函数的返回值即可
     
     func calculate(input: Int, completion: @escaping (Int) -> Void)
     // 转换为
     func calculate(input: Int) async -> Int
     func load(completion: @escaping ([String]?, Error?) -> Void)
     // 转换为
     func load() async throws -> [String]
     
     当遇到可抛出的异步函数时，编译器要求我们将 async 放在 throws 前；
     在这类函数的调用侧，编译器同样做出了强制规定，要求将 try 放在 await 之前
     */

    //MARK: - 2.2 带有返回的情况
    /*
     有些情况下，带有闭包的异步操作函数本身也具有返回值
     func data(from url: URL, delegate: URLSessionTaskDelegate? = nil ) async throws -> (Data, URLResponse)
     
     在 URLSessionDataTask 这个特例下，这没有造成太大问题。URLSessionDataTask 需要承担的最大的任务，就是取消网络请求。异步函数都是运行在某个任务环境中的，因此可以通过取消任务来间接取消运行中的网络请求。虽然这需要一些额外的努力，但是是可以优雅地做到的
     
     */
    
    //MARK: - 2.3 @completionHandlerAsync

    /*
     异步函数具有极强的“传染性”：一旦你把某个函数转变为异步函数后，对它进行调用的函数往往都需要转变为异步函数。
     为了保证迁移的顺利，Apple 建议进行从下向上的迁移：先对底层负责具体任务的最小单元开始，将它改变为异步函数，然后逐渐向上去修改它的调用者。

     为了保证迁移的顺利，一种值得鼓励的做法是，在为一个原本基于回调的函数添加异步函数版本的同时，暂时保留这个已有的回调版本。
     
     可以为原本的回调版本添加 @completionHandlerAsync 注解，告诉编译器存当前函数存在一个异步版本。
     当使用者在其他异步函数中调用了这个回调版本时，编译器将提醒使用者可以迁移到更合适的异步版本”
     
     @completionHandlerAsync 和 @available 标记很类似。
     它接收一个字符串，并在检测到被标记的函数在异步环境下被调用时，为编译器提供信息，帮助使用者用 “fix-it” 按钮迁移到异步版本。
     和一般的 @available 的不同之处在于，在同步环境下 @completionHandlerAsync 并不会对 calculate(input:completion:) 的调用发出警告，它只在异步函数中进行迁移提示，因此提供了更为准确的信息
    */
    // @completionHandlerAsync("calculate(input:)")
    func calculate(input: Int, completion: @escaping (Int) -> Void) {
        completion(input + 100)
    }

    func calculate(input: Int) async throws -> Int {
        return input + 100
    }
    
    //MARK: - 3. 使用续体改写函数

    /*
     函数体本身要如何“异步化”。
     在异步函数被引入之前，处理和响应异步事件的主要方式是闭包回调和代理 (delegate) 方法。
     可能你的代码库里已经大量存在这样的处理方式了，如果你想要提供一套异步函数的接口，但在内部依然复用闭包回调或是代理方法的话，最方便的迁移方式就是捕获续体并暂停运行，然后在异步操作完成时告知这个续体结果，让异步函数从暂停点重新开始。

    Swift 提供了一组全局函数，让我们暂停当前任务，并捕获当前的续体
     func withUnsafeContinuation<T>(_ fn: (UnsafeContinuation<T, Never>) -> Void) async -> T
     func withUnsafeThrowingContinuation<T>(_ fn: (UnsafeContinuation<T, Error>) -> Void) async throws -> T
     func withCheckedContinuation<T>(function: String = #function, _ body: (CheckedContinuation<T, Never>) -> Void) async -> T
     func withCheckedThrowingContinuation<T>(function: String = #function, _ body: (CheckedContinuation<T, Error>) -> Void) async throws -> T
     
     普通版本和 Throwing 版本的区别在于这个异步函数是否可以抛出错误，如果不可抛出，那么续体 Continuation 的泛型错误类型将被固定为 Never。在结构化并发的部分 API 中 (比如 withTaskGroup 和 withThrowingTaskGroup)
     */
    
    //MARK: - 3.1 续体 resume
    /*
     在某个异步函数中调用 with*Continuation 后，这个异步函数暂停，函数的剩余部分作为续体被捕获，代表续体的 UnsafeContinuation 或 CheckedContinuation 被传递给闭包参数，而这个闭包也会在当前的任务上下文中立即运行。
     这个 Continuation 上的 resume 函数，在未来必须且仅需被调用一次，来将控制权交回给调用者
     */
    func load(completion: @escaping ([String]?, Error?)->Void) {
        // dosomethings
    }
    func load() async throws -> [String] {
        try await withUnsafeThrowingContinuation { continuation in
            load { values, error in
                if let error = error {
                    continuation.resume(throwing: error)    // 正确返回的情况
                } else if let values = values {
                    continuation.resume(returning: values)  // 发生错误的情况
                } else {
                    assertionFailure("Both parameters are nil")
                }
            }
            // 当 continuation 上的这两者任一被调用时，整个异步函数要么抛出错误，要么返回正常值
        }
    }
    /*
     Unsafe 和 Checked 版本的区别在于是否对 continuation 的调用状况进行运行时的检查。
     continuation 必须在未来继续，只是一个开发者和编译器的约定。
     Unsafe 的版本不进行任何检查，它假设开发者会正确使用这个 API：
     如果 continuation 没能继续 (也就是 continuation 在被释放前，它上面的任意一个 resume 方法都没有调用)，
     那么异步函数将永远停留在暂停点不再继续；反过来，如果 resume 被调用了多次，程序的运行状态将出现错误
     
     和 Unsafe 的版本稍有不同，Checked 的版本能稍微给我们一些提示。在没能继续的情况下，运行时会在控制台进行输出
     // SWIFT TASK CONTINUATION MISUSE: load() leaked its continuation!
     
     在调用 resume 多次时，这个错误将产生崩溃
     // 崩溃，错误信息：
     // Fatal error: SWIFT TASK CONTINUATION MISUSE: load()
     // tried to resume its continuation more than once, returning...
     
     由于 Checked 的一系列特性都和运行时相关，因此对续体的使用情况进行检查 (以及存储额外的调试信息)，会带来额外的开销。
     因此，在一些性能关键的地方，在确认无误的情况下，使用 Unsafe 版本会提升一些性能。
     因为除了 Checked 和 Unsafe 之外，两个 API 在语法上并没有区别，所以按照 Debug 版本和 Release 版本的编译条件进行互换也并不困难。
     不过需要记住的是，就算使用 Checked 版本，也不意味着万事大吉，它只是一个很弱的运行时检查：
     对于没有调用 resume 的情况，虽然异步函数会在续体超出捕获域后自动继续，但是没有 resume 的任务依然被泄漏了；
     对于多次调用 resume 的情况，运行时崩溃的严重性更是不言而喻。
     Checked 能做的只是帮助我们更容易地发现这些错误
     */
    
    //MARK: - 3.2 续体暂存
    /*
    除了在回调版本的异步代码中使用外，我们也可以把捕获到的续体暂存起来，这种方式很适合将 delegate 方式的异步操作转换为异步函数：
     */

    class Worker: WorkDelegate {
        
        // 变量 暂时存储
        var continuation: CheckedContinuation<[String], Error>?
        
        func performWork(delegate: WorkDelegate) {
            
        }
        
        func doWork() async throws -> [String] {
            try await withCheckedThrowingContinuation({ continuation in
                self.continuation = continuation
                performWork(delegate: self)
            })
        }
        
        func workDidDone(values: [String]) {
            continuation?.resume(returning: values)
            continuation = nil
        }
        func workDidFailed(error: Error) {
            continuation?.resume(throwing: error)
            continuation = nil
        }
    }
    /*
     很多时候，delegate 方法可能被调用不止一次,但是作为 continuation 来说，不论成败，它只支持一次 resume 调用。
     通过 resume 调用后将 self.continuation 置为 nil 来避免重复调用。
     根据具体情况，你可能可能会需要选择不同的处理方法。如果一个续体需要被多次调用，并产生一系列值，我们会需要涉及到 AsyncSequence 和 AsyncStream 的使用
     */
    
    //MARK: - 3.3 续体和 Future
    /*
     如果你对 Combine 比较熟悉，也许已经隐约感受到，续体和 Future 有一些相似：
     Future 通过提供一个 Promise 来接受未来的 Result<Output, Failure> 值，并提供给订阅者，
     而续体的行为模式也一样，甚至续体版本也准备了接受 Result 类型的重载：
     
     extension CheckedContinuation {
        func resume(with result: Result<T, E>)
     }
     
     在一定程度上，认为 async 函数 (或者更准确说，由续体转换的异步函数) 可以取代 Future：
     同样是在返回一个未来的值，async 显然提供了更加简洁的写法。
     相对于 Combine 基于订阅的使用方式和 Scheduler 决定的线程模型，直接使用异步函数需要操心的地方要少很多。
     但是续体异步函数和 Future 依然有不同。
     异步函数必定在一定的任务上下文之中执行，这个上下文决定了任务的取消状态、优先级等；
     单个 Future 如果不和 Combine 框架中的其他 Publisher 或者 Operators 结合 (combine) 使用的话，它能提供的特性远远不及异步函数丰富
     */
    
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
}


