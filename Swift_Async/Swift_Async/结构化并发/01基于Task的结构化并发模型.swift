//
//  01基于Task的结构化并发模型.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/7.
//

import Foundation

/*
 在 Swift 并发编程中，结构化并发需要依赖异步函数，而异步函数又必须运行在某个任务上下文中，因此可以说，想要进行结构化并发，必须具有任务上下文。
 实际上，Swift 结构化并发就是以任务为基本要素进行组织的。
 */

// MARK: - 当前任务
// Swift 并发编程把异步操作抽象为任务，在任意的异步函数中，我们总可是使用 withUnsafeCurrentTask 来获取和检查当前任务
func foo() async {
    withUnsafeCurrentTask { task in
        // 3
        if let task = task {
            //4
            debugPrint("cancelled: \(task.isCancelled)") // false
            
            debugPrint(task.priority) // TaskPrioitey(rawValue: 33)
        }else{
            print("no task")
        }
    }
}
func test_current_task() {
    
    withUnsafeCurrentTask { task in
        //1
        debugPrint(task as Any)
        // await foo() // -> Cannot pass function of type '(UnsafeCurrentTask?) async -> ()' to parameter expecting synchronous function type
    }
    Task {
        //2
        await foo()
    }
}
/*
 1. withUnsafeCurrentTask 本身不是异步函数，你也可以在普通的同步函数中使用它。如果当前的函数并没有运行在任何任务上下文环境中，也就是说，到 withUnsafeCurrentTask 为止的调用链中如果没有异步函数的话，这里得到的 task 会是 nil。
 2. 使用 Task 的初始化方法，可以得到一个新的任务环境。在上一章中我们已经看到过几种开始任务的方式了。
 3. 对于 foo 的调用，发生在上一步的 Task 闭包作用范围中，它的运行环境就是这个新创建的 Task。
 4. 对于获取到的 task，可以访问它的 isCancelled 和 priority 属性检查它是否已经被取消以及当前的优先级。我们甚至可以调用 cancel() 来取消这个任务。
 
 要注意任务的存在与否和函数本身是不是异步函数并没有必然关系，这是显然的：
 同步函数也可以在任务上下文中被调用。
 比如下面的 syncFunc 中，withUnsafeCurrentTask 也会给回一个有效任务：
 */
func syncFUnc() {
    withUnsafeCurrentTask { task in
        debugPrint(task as Any)
    }
}
/*
 使用 withUnsafeCurrentTask 获取到的任务实际上是一个 UnsafeCurrentTask 值。
 和 Swift 中其他的 Unsafe 系 API 类似，Swift 仅保证它在 withUnsafeCurrentTask 的闭包中有效。
 你不能存储这个值，也不能在闭包之外调用或访问它的属性和方法，那会导致未定义的行为。
 因为检查当前任务的状态相对是比较常用的操作，Swift 为此准备了一个“简便方法”：
 使用 Task 的静态属性来获取当前状态，比如：
 extension Task where Success == Never, Failure == Never {
 static var isCancelled: Bool { get }
 static var currentPriority: TaskPriority { get }
 }
 
 虽然被定义为 static var，但是它们并不表示针对所有 Task 类型通用的某个全局属性，而是表示当前任务的情况。
 因为一个异步函数的运行环境必须有且仅会有一个任务上下文，所以使用 static 变量来表示这唯一一个任务的特性，是可以理解的。
 相比于每次去获取 UnsafeCurrentTask，这种写法更加简单。
 比如，我们可以在不同的任务上下文中使用 Task.isCancelled 检查任务的取消情况：
 */
func test_current_task_check() {
    Task {
        let t1 = Task {
            debugPrint("t1 \(Task.isCancelled)")
        }
        
        let t2 = Task {
            debugPrint("t2 \(Task.isCancelled)")
        }
        
        t1.cancel()
        
        debugPrint("t \(Task.isCancelled)")
    }
}

// MARK: - 任务层级
/*
 上例中虽然 t1 和 t2 是在外层 Task 中再新生成并进行并发的，但是它们之间没有从属关系，并不是结构化的。
 这一点从 t: false 先于其他输出就可以看出，t1 和 t2 的执行都是在外层 Task 闭包结束后才进行的，它们逃逸出去了，这和结构化并发的收束规定不符。
 
 想要创建结构化的并发任务，就需要让内层的 t1 和 t2 与外层 Task 具有某种从属关系。
 你可以已经猜到了，外层任务作为根节点，内层任务作为叶子节点，就可以使用树的数据结构，来描述各个任务的从属关系，并进而构建结构化的并发了。
 这个层级关系，和 UI 开发时的 View 层级关系十分相似。
 通过用树的方式组织任务层级，我们可以获取下面这些有用特性：
 1. 一个任务具有它自己的优先级和取消标识，它可以拥有若干个子任务 (叶子节点) 并在其中执行异步函数。
 2. 当一个父任务被取消时，这个父任务的取消标识将被设置，并向下传递到所有的子任务中去。
 3. 无论是正常完成还是抛出错误，子任务会将结果向上报告给父任务，在所有子任务正常完成或者抛出之前，父任务是不会被完成的。
 
 当任务的根节点退出时，我们通过等待所有的子节点，来保证并发任务都已经退出。
 树形结构允许我们在某个子节点扩展出更多的二层子节点，来组织更复杂的任务。
 这个子节点也许要遵守同样的规则，等待它的二层子节点们完成后，它自身才能完成。
 这样一来，在这棵树上的所有任务就都结构化了。
 在 Swift 并发中，在任务树上创建一个叶子节点，有两种方法：
 1. 通过任务组 (task group)
 2. 通过 async let 的异步绑定语法。
 */

// MARK: - 任务组
func start() async {
    print("Start")
    // 1
    await withTaskGroup(of: Int.self) { group in
        for i in 0 ..< 3 {
            // 2
            group.addTask {
                await work(i)
            }
        }
        print("Task added")
        // 4
        for await result in group {
            print("Get result: \(result)")
        }
        // 5
        print("Task ended")
    }
    print("End")
}
func work(_ value: Int) async -> Int {
    // 3
    print("Start work \(value)")
    await Task.sleep(UInt64(value) * NSEC_PER_SEC)
    print("Work \(value) done")
    return value
}
/*
 childTaskResultType 指定子任务们的返回类型。
 同一个任务组中的子任务只能拥有同样的返回类型，这是为了让 TaskGroup 的 API 更加易用，让它可以满足带有强类型的 AsyncSequence 协议所需要的假设。
 returning 定义了整个任务组的返回值类型，它拥有默认值，通过推断就可以得到，我们一般不需要理会。
 在 body 的参数中能得到一个 inout 修饰的 TaskGroup，我们可以通过使用它来向当前任务上下文添加结构化并发子任务。
 
 addTask API 把新的任务添加到当前任务中。
 被添加的任务会在调度器获取到可用资源后立即开始执行。
 
 在实际工作开始时，我们进行了一次 print 输出，这让我们可以更容易地观测到事件的顺序。
 group 满足 AsyncSequence，因此我们可以使用 for await 的语法来获取子任务的执行结果。
 group 中的某个任务完成时，它的结果将被放到异步序列的缓冲区中。
 每当 group 的 next 会被调用时，如果缓冲区里有值，异步序列就将它作为下一个值给出；
 如果缓冲区为空，那么就等待下一个任务完成，这是异步序列的标准行为。
 
 for await 的结束意味着异步序列的 next 方法返回了 nil，此时group 中的子任务已经全部执行完毕了，withTaskGroup 的闭包也来到最后。
 */

// MARK: - 隐式等待
/*
 为了获取子任务的结果，我们在上例中使用 for await 明确地等待 group 完成。
 这从语义上明确地满足结构化并发的要求：
 子任务会在控制流到达底部前结束。
 不过一个常见的疑问是，其实编译器并没有强制我们书写 for await 代码。
 如果我们因为某种原因，比如由于用不到这些结果，而导致忘了等待 group，会发生什么呢？
 任务组会不会因为没有等待，而导致原来的控制流不会暂停，就这样继续运行并结束？
 这样是不是违反了结构化并发的需要？
 好消息是，即使我们没有明确 await 任务组，编译器在检测到结构化并发作用域结束时，会为我们自动添加上 await 并在等待所有任务结束后再继续控制流
 */
func test7() {
    Task {
        await withTaskGroup(of: Int.self) { group in
            for i in 0 ..< 3 {
                group.addTask {
                    await work(i)
                }
            }
            print("Task added")
            // for await...
            print("Task ended")
        }
    }
}
/*
 虽然 “Task ended” 的输出似乎提早了，但代表整个任务组完成的 “End” 的输出依然处于最后，它一定会在子任务全部完成之后才发生。
 对于结构化的任务组，编译器会为在离开作用域时我们自动生成 await group 的代码
 */
func test8(){
    Task{
        await withTaskGroup(of: Int.self) { group in
            for i in 0 ..< 3 {
                group.addTask {
                    await work(i)
                }
            }
            print("Task added")
            print("Task ended")
            // 编译器自动生成的代码
            for await _ in group { }
        }
        print("End")
    }
}
/*
 它满足结构化并发控制流的单入单出，将子任务的生命周期控制在任务组的作用域内，这也是结构化并发的最主要目的。
 即使我们手动 await 了 group 中的部分结果，然后退出了这个异步序列，结构化并发依然会保证在整个闭包退出前，让所有的子任务得以完成：
 */
func test9() {
    Task {
        await withTaskGroup(of: Int.self) { group in
            for i in 0 ..< 3 {
                group.addTask {
                    await work(i)
                }
            }
            print("Task added")
            for await result in group {
                print("Get result: \(result)")
                // 在首个子任务完成后就跳出
                break
            }
            print("Task ended")
            // 编译器自动生成的代码
            await group.waitForAll()
        }
    }
}

// MARK: - 任务组的值捕获
/*
 任务组中的每个子任务都拥有返回值，上面例子中 work 返回的 Int 就是子任务的返回值。
 当 for await 一个任务组时，就可以获取到每个子任务的返回值。
 任务组必须在所有子任务完成后才能完成，因此我们有机会“整理”所有子任务的返回结果，并为整个任务组设定一个返回值。比如把所有的 work 结果加起来：
 */
func test10() {
    Task {
        let v: Int = await withTaskGroup(of: Int.self) { group in
            var value = 0
            for i in 0 ..< 3 {
                group.addTask {
                    return await work(i)
                }
            }
            for await result in group {
                value += result
            }
            return value
        }
        print("End. Result: \(v)")
    }
}
// 每次 work 子任务完成后，结果的 result 都会和 value 累加，运行这段代码将输出结果 3
/*
 在将代码通过 addTask 添加到任务组时，我们必须有清醒的认识：
    这些代码有可能以并发方式同时运行。
 编译器可以检测到这里我们在一个明显的并发上下文中改变了某个共享状态。
 不加限制地从并发环境中访问是危险操作，可能造成崩溃。
 得益于结构化并发，现在编译器可以理解任务上下文的区别，在静态检查时就发现这一点，从而从根本上避免了这里的内存风险
 */

// MARK: - 任务组逃逸
/*
 和 withUnsafeCurrentTask 中的 task 类似，withTaskGroup 闭包中的 group 也不应该被外部持有并在作用范围之外使用。
 虽然 Swift 编译器现在没有阻止我们这样做，但是在 withTaskGroup 闭包外使用 group 的话，将完全破坏结构化并发的假设：
 */
// 错误的代码，不要这样做
func start_1() async {
    var g: TaskGroup<Int>? = nil
    await withTaskGroup(of: Int.self) { group in
        g = group
        //...
    }
    g?.addTask {
        await work(1)
    }
    print("End")
}
/*
 通过 g?.addTask 添加的任务有可能在 start 完成后继续运行，这回到了非结构并发的老路；
    但它也可能让整个任务组进入到难以预测的状态，这将摧毁程序的执行假设。
 TaskGroup 实际上并不是用来存储 Task 的容器，它也不提供组织任务时需要的树形数据结构，这个类型仅仅只是作为对底层接口的包装，提供了创建任务节点的方法。
 要注意，在闭包作用范围外添加任务的行为是未定义的，随着 Swift 的升级，今后有可能直接产生运行时的崩溃。
 虽然现在并没有提供任何语言特性来确保 group 不被复制出去，但是我们绝对应该避免这种反模式的做法
 */

// MARK: - async let 异步绑定
/*
 除了任务组以外，async let 是另一种创建结构化并发子任务的方式。withTaskGroup 提供了一种非常“正规”的创建结构化并发的方式：
    它明确地描绘了结构化任务的作用返回，确保在闭包内部生成的每个子任务都在 group 结束时被 await。
 通过对 group 这个异步序列进行迭代，我们可以按照异步任务完成的顺序对结果进行处理。只要遵守一定的使用约定，就可以保证并发结构化的正确工作并从中受益。
 
 但是，这些优点有时候也正是 withTaskGroup 不足：
    每次我们想要使用 withTaskGroup 时，往往都需要遵循同样的模板，包括创建任务组、定义和添加子任务、使用 await 等待完成等，这些都是模板代码。
 而且对于所有子任务的返回值必须是同样类型的要求，也让灵活性下降或者要求更多的额外实现 (比如将各个任务的返回值用新类型封装等)。
 withTaskGroup 的核心在于，生成子任务并将它的返回值 (或者错误) 向上汇报给父任务，然后父任务将各个子任务的结果汇总起来，最终结束当前的结构化并发作用域。
 这种数据流模式十分常见，如果能让它简单一些，会大幅简化我们使用结构化并发的难度。
 async let 的语法正是为了简化结构化并发的使用而诞生的。
 
 在 withTaskGroup 的例子中的代码，使用 async let 可以改写为下面的形式：
 */
func start_2() async {
    print("Start")
    async let v0 = work(0)
    async let v1 = work(1)
    async let v2 = work(2)
    print("Task added")
    let result = await v0 + v1 + v2
    print("Task ended")
    print("End. Result: \(result)")
}
/*
 async let 和 let 类似，它定义一个本地常量，并通过等号右侧的表达式来初始化这个常量。
 区别在于，这个初始化表达式必须是一个异步函数的调用，通过将这个异步函数“绑定”到常量值上，Swift 会创建一个并发执行的子任务，并在其中执行该异步函数。async let 赋值后，子任务会立即开始执行。
 如果想要获取执行的结果 (也就是子任务的返回值)，可以对赋值的常量使用 await 等待它的完成。
 
 在上例中，我们使用了单一 await 来等待 v0、v1 和 v2 完成。和 try 一样，对于有多个表达式都需要暂停等待的情况，我们只需要使用一个 await 就可以了。当然，如果我们愿意，也可以把三个表达式分开来写：
 */
func start_3() async {
    print("Start")
    async let v0 = work(0)
    async let v1 = work(1)
    async let v2 = work(2)
    
    let r0 = await v0
    let r1 = await v1
    let r2 = await v2
    
    print("Task added")
    let result = r0 + r1 + r2
    print("Task ended")
    print("End. Result: \(result)")
}
/*
 需要特别强调，虽然这里我们顺次进行了 await，看起来好像是在等 v0 求值完毕后，再开始 v1 的暂停；
 然后在 v1 求值后再开始 v2。但是实际上，在 async let 时，这些子任务就一同开始以并发的方式进行了。
 在例子中，完成 work(n) 的耗时为 n 秒，所以上面的写法将在第 0 秒，第 1 秒和第 2 秒分别得出 v0，v1 和 v2 的值，而不是在第 0 秒，第 1 秒和第 3 秒 (1 秒 + 2 秒) 后才得到对应值。
 由此衍生的另一个疑问是，如果我们修改 await 的顺序，会发生什么呢？
 
 如果是考察每个子任务实际完成的时序，那么答案是没有变化：在 async let 创建子任务时，这个任务就开始执行了，因此 v0、v1 和 v2 真正执行的耗时，依旧是 0 秒，1 秒和 2 秒。但是，使用 await 最终获取 v0 值的时刻，是严格排在获取 v2 值之后的：当 v0 任务完成后，它的结果将被暂存在它自身的续体栈上，等待执行上下文通过 await 切换到自己时，才会把结果返回。也就是说在上例中，通过 async let 把任务绑定并开始执行后，await v1 会在 1 秒后完成；再经过 1 秒时间，await v2 完成；然后紧接着，await v0 会把 2 秒之前就已经完成的结果立即返回给 result0：
 
 这个例子中虽然最终的时序上会和之前有细微不同，但是这并没有违反结构化并发的规定。而且在绝大多数场景下，这也不会影响并发的结果和逻辑。不论是前面提到的任务组，还是 async let，它们所生成的子任务都是结构化的
 */

// MARK: - 隐式取消
/*
 在使用 async let 时，编译器也没有强制我们书写类似 await v0 这样的等待语句。
 有了 TaskGroup 中的经验以及 Swift 里“默认安全”的行为规范，我们不难猜测出，对于没有 await 的异步绑定，编译器也帮我们做了某些“手脚”，以保证单进单出的结构化并发依然成立。
 如果没有 await，那么 Swift 并发会在被绑定的常量离开作用域时，隐式地将绑定的子任务取消掉，然后进行 await。也就是说，对于这样的代码
 */
func start_4() async {
    async let v0 = work(0)
    debugPrint("end")
}
// 等效于
func start_4_1() async {
    async let v0 = work(0)
    debugPrint("end")
    
    // 下面是编译器自动生成的伪代码
    // 注意和 Task group 的不同
    // v0 绑定的任务被取消
    // 伪代码，实际上绑定中并没有 `task` 这个属性
    // v0.task.cancel()
    // 隐式 await，满足结构化并发
    _ = await v0
}
/*
 和 TaskGroup API 的不同之处在于，被绑定的任务将先被取消，然后才进行 await。
 这给了我们额外的机会去清理或者中止那些没有被使用的任务。
 不过，这种“隐藏行为”在异步函数可以抛出的时候，可能会造成很多的困惑。
 现在，你只需要记住，和 TaskGroup 一样，就算没有 await，async let 依然满足结构化并发要求这一结论就可以了。
 */

// MARK: - 对比任务组
/*
 既然同样是为了书写结构化并发的程序，async let 经常会用来和任务组作比较。
 在语义上，两者所表达的范式是很类似的，因此也会有人认为 async let 只是任务组 API 的语法糖：
    因为任务组 API 的使用太过于繁琐了，而异步绑定毕竟在语法上要简洁很多。
 
 但实际上它们之间是有差异的。
    async let 不能动态地表达任务的数量，能够生成的子任务数量在编译时必须是已经确定好的。
 比如，对于一个输入的数组，我们可以通过 TaskGroup 开始对应数量的子任务，但是我们却无法用 async let 改写这段代码：
 */
func startAll(_ items: [Int]) async {
    await withTaskGroup(of: Int.self) { group in
        for item in items {
            group.addTask { await work(item) }
        }
        for await value in group {
            print("Value: \(value)")
        }
    }
}

/*
 除了上面那些只能使用某一种方式创建的结构化并发任务外，对于可以互换的情况，任务组 API 和异步绑定 API 的区别在于提供了两种不同风格的编程方式。
 一个大致的使用原则是，如果我们需要比较“严肃”地界定结构化并发的起始，那么用任务组的闭包将它限制起来，并发的结构会显得更加清晰；
 而如果我们只是想要快速地并发开始少数几个任务，并减少其他模板代码的干扰，那么使用 async let 进行异步绑定，会让代码更简洁易读。
 */

// MARK: - 结构化并发的组合
/*
 在只使用一次 withTaskGroup 或者一组 async let 的单一层级的维度上，我们可能很难看出结构化并发的优势，因为这时对于任务的调度还处于可控状态：
 我们完全可以使用传统的技术，通过添加一些信号量，来“手动”控制保证并发任务最终可以合并到一起。但是，随着系统逐渐复杂，可能会面临在一些并发的子任务中再次进行任务并发的需求。也就是，形成多个层级的子任务系统。
 在这种情况下，想依靠原始的信号量来进行任务管理会变得异常复杂。
 这也是结构化并发这一抽象真正能发挥全部功效的情况。
 通过嵌套使用 withTaskGroup 或者 async let，可以在一般人能够轻易理解的范围内，灵活地构建出这种多层级的并发任务。
 最简单的方式，是在 withTaskGroup 中为 group 添加 task 时再开启一个 withTaskGroup：
 */
func start_5() async {
    // 第一层任务组
    await withTaskGroup(of: Int.self) { group in
        group.addTask {
            // 第二层任务组
            await withTaskGroup(of: Int.self) { innerGroup in
                innerGroup.addTask {
                    await work(0)
                }
                innerGroup.addTask {
                    await work(2)
                }
                return await innerGroup.reduce(0) {
                    result, value in
                    result + value
                }
            }
        }
        group.addTask {
            await work(1)
        }
    }
    print("End")
}
/*
 对于上面使用 work 函数的例子来说，多加的一层 innerGroup 在执行时并不会造成太大区别：
    三个任务依然是按照结构化并发执行。
    不过，这种层级的划分，给了我们更精确控制并发行为的机会。
    在结构化并发的任务模型中，子任务会从其父任务中继承任务优先级以及任务的本地值 (task local value)；
    在处理任务取消时，除了父任务会将取消传递给子任务外，在子任务中的抛出也会将取消向上传递。
    不论是当我们需要精确地在某一组任务中设置这些行为，或者只是单纯地为了更好的可读性，这种通过嵌套得到更加细分的任务层级的方法，都会对我们的目标有所帮助。

    任务本地值指的是那些仅存在于当前任务上下文中的，由外界注入的值
 
 相对于 withTaskGroup 的嵌套，使用 async let 会更有技巧性一些。
 async let 赋值等号右边，接受的是一个对异步函数的调用。
 这个异步函数可以是像 work 这样的具体具名的函数，也可以是一个匿名函数。
 比如，上面的 withTaskGroup 嵌套的例子，使用 async let，可以简单地写为：
 */
func start_6() async {
    async let v02: Int = {
        async let v0 = work(0)
        async let v2 = work(2)
        return await v0 + v2
    }()
    async let v1 = work(1)
    _ = await v02 + v1
    print("End")
}
// 这里在 v02 等号右侧的是一个匿名的异步函数闭包调用，其中通过两个新的 async let 开始了嵌套的子任务。特别注意，上例中的写法和下面这样的 await 有本质不同：
func start_7() async {
    async let v02: Int = {
        return await work(0) + work(2)
    }()
    // ...
}
/*
 await work(0) + work(2) 将会顺次执行 work(0) 和 work(2)，并把它们的结果相加。这时两个操作不是并发执行的，也不涉及新的子任务。
 
 当然，我们也可以把两个嵌套的 async let 提取到一个署名的函数中，这样调用就会回到我们所熟悉的方式
 */
func start_8() async {
    async let v02 = work02()
    //...
}
func work02() async -> Int {
    async let v0 = work(0)
    async let v2 = work(2)
    return await v0 + v2
}
/*
 大部分时候，把子任务的部分提取成具名的函数会更好。
 不过对于这个简单的例子，直接使用匿名函数，让 work(0)、work(2) 与另一个子任务中的 work(1) 并列起来，可能结构会更清楚。
 
 因为 withTaskGroup 和 async let 都产生结构性并发任务，因此有时候我们也可以将它们混合起来使用。
 比如在 async let 的右侧写一个 withTaskGroup；
 或者在 group.addTask 中用 async let 绑定新的任务。
 不过不论如何，这种“静态”的任务生成方式，理解起来都是相对容易的：
    只要我们能将生成的任务层级和我们想要的任务层级对应起来，两者混用也不会有什么问题。
 */
