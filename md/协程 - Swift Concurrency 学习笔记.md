# Swift Concurrency 学习笔记

Swift 5.5里新增了Swift Concurrency，语法和Web前端里的异步非常之像，语法学习起来比较简单。

## 基本使用

关键词就是`async`和`await`。不同的是需要放入`Task`里执行，并且一定需要加`await`关键字。

```swift
func fn() async {
    print("async function")
}

Task {
    await fn()
}
复制代码
```

另外一种是可以抛出错误的`async`函数。

```swift
func fn() async throws -> String{
    throw URLError(.badURL)
    return "async"
}
复制代码
```

调用会抛出错误的`async`函数的时候需要使用`try`关键字。

```swift
Task{
    let result = try await fn()
    print(result)
}
复制代码
```

这样是不会输入任何结果的，因为已经抛出错误了，在这种情况需要用`do-catch`语句。

```swift
Task {
    do {
        let result = try await fn()
        print(result)
    } catch {
        print(error.localizedDescription) // 输出了错误信息
    }
}
复制代码
```

使用`do-catch`可以捕获错误，另外还有2种`try`的修饰，`try!`和`try?`，可以不使用`do-catch`。

```swift
let result = try! await fn() // 程序会直接崩溃，不会走do-catch，捕获不了错误
print(result)
复制代码
```

`try!`是非常不建议使用的。

```swift
let result = try? await fn() // 报错会返回nil
print(result) // nil
复制代码
```

`try?`在出现错误的时候会返回`nil`，在不需要捕获具体错误信息的时候非常有用。

## Task

`Task`接受一个闭包作为参数，返回一个实例。

### 取消 Task

`Task`会返回实例，通过该实例的`cancel()`方法可取消任务。

```swift
func fn() async {
    try? await Task.sleep(for: .seconds(2))
    print("async function")
}

let task = Task {
    await fn()
}
task.cancel()
复制代码
```

但是实际我们还是会输出"async function"，只是跳过了等待2秒。

所以我们需要调用`Task.isCancelled`或者`Task.checkCancellation()`来确保不再执行。

```swift
func fn() async {
    try? await Task.sleep(for: .seconds(2))
    if Task.isCancelled { return }
    print("async function")
}
复制代码
```

### Task的优先级

`Task`中有优先级的概念

```Swift
Task(priority: .background) {
    print("background: \(Task.currentPriority)")
}
Task(priority: .high) {
    print("high: \(Task.currentPriority)")
}
Task(priority: .low) {
    print("low: \(Task.currentPriority)")
}
Task(priority: .medium) {
    print("medium: \(Task.currentPriority)")
}
Task(priority: .userInitiated) {
    print("userInitiated: \(Task.currentPriority)")
}
Task(priority: .utility) {
    print("utility: \(Task.currentPriority)")
}
复制代码
```

输出

```css
medium: TaskPriority(rawValue: 21)
high: TaskPriority(rawValue: 25)
low: TaskPriority(rawValue: 17)
userInitiated: TaskPriority(rawValue: 25)
utility: TaskPriority(rawValue: 17)
background: TaskPriority(rawValue: 9)
复制代码
```

优先级并不一定匹配，有时候会有优先级提升的情况。

子任务会继承父任务的优先级。

```swift
Task(priority: .high) {
    Task {
        print(Task.currentPriority) // TaskPriority(rawValue: 25)
    }
}
复制代码
```

通过`Task.detached`来分离任务。

```swift
Task(priority: .high) {
    Task.detached {
        print(Task.currentPriority) // TaskPriority(rawValue: 21)
    }
}
复制代码
```

### 挂起Task

`Task.yield()`可以挂起当前任务。

```swift
Task {
    print("task 1")
}
Task {
    print("task 2")
}

// 输出
// task 1
// task 2
复制代码
```

使用`Task.yield()`。

```swift
Task {
    await Task.yield()
    print("task 1")
}
Task {
    print("task 2")
}
// 输出
// task 2
// task 1
复制代码
```

## async let

`await`是阻塞的，意味着当前`await`函数在没执行完之前是不会执行下一行的。

```swift
func fn() async -> String {
    try? await Task.sleep(for: .seconds(2))
    return "async function"
}

Task {
    let result = await fn()
    print(result) // 等待两秒后输出async function
}
复制代码
```

有些情况需要并行运行多个`async`函数，这个时候则会用到`async let`。

```swift
Task {
    async let fn1 = fn()
    async let fn2 = fn()

    let result = await [fn1, fn2]
    
    print(result) // ["async function", "async function"]
}
复制代码
```

## TaskGroup

如果任务过多，或者是循环里创建并行任务，`async let`就不是那么得心应手了，这种情况我们应该使用`withTaskGroup`和`withThrowingTaskGroup`。

```swift
Task {
        let string = await withTaskGroup(of: Int.self) { group in
            for i in 0 ... 10 {
                group.addTask {
                    try? await Task.sleep(for: .seconds(2))
                    return i
                }
            }
            var collected = [Int]()
            for await value in group {
                collected.append(value)
            }
            return collected
        }
        print(string)
    }
复制代码
```

`of`为子任务返回类型，在`TaskGroup`里我们也能通过`group.cancelAll()`和`group.isCanceled`配合来取消任务。

## Continuations

`Continuations`用于将以前的异步回调函数变成`async`函数，类似前端里的`new Promise(resolve,reject)`。

现有以下代码

```swift
func fn(_ cb: @escaping (String) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        cb("completed")
    }
}
复制代码
```

这段代码是通过`@escaping`闭包的形式来获取结果，不能通过`await`获取，只需要使用`withCheckedContinuation`就可以将函数改造为`async`函数。

```swift
func asyncFn() async -> String {
    await withCheckedContinuation { continuation in
        fn { continuation.resume(returning: $0) }
    }
}

Task {
  let result = await asyncFn()
  print(result)
}
复制代码
```

除了`withCheckedContinuation`，还有`withCheckedThrowingContinuation`可以抛出错误。

## actor

在很多语言里，都有线程锁这个概念，避免多个线程同一时间访问同一数据，造成错误。

Swift Concurrency里通过`actor`来解决这个问题。`actor`里的属性和方法都是线程安全的。

```swift
actor MyActor {
    var value:String = "test"
    
    func printValue(){
        print(value)
    }
}
复制代码
```

`actor`内默认属性和方法都是异步的，需要通过`await`来调用。

```swift
Task {
    let myActor = MyActor()
    await myActor.printValue()
    print(await myActor.value)
}
复制代码
```

如果需要某个方法不用`await`调用，需要使用`nonisolated`关键字。

```swift
actor MyActor {
    nonisolated func nonisolatedFn(){
        print("nonisolated")
    }
}

let myActor = MyActor()
myActor.nonisolatedFn()
复制代码
```

## MainActor

现有以下代码

```swift
class VM: ObservableObject {
    @Published var value = "value"

    func change() {
        Task{
            try? await Task.sleep(for:.seconds(2))
            self.value = "change"
        }
    }
}

Text(vm.value)
    .onTapGesture {
        vm.change()
    }
复制代码
```

当点击`Text`两秒后会修改值。这时候会提示。

```vbnet
[SwiftUI] Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates
复制代码
```

因为UI改动都应该发生在主线程，可以使用老办法`Dispatch.main.async`来解决。在Swift Concurrency里有多个方法。

```swift
func change() {
    Task {
        try? await Task.sleep(for: .seconds(2))
        await MainActor.run{
            self.value = "change"
        }
    }
}
复制代码
```

或者

```swift
    func change() {
        Task {@MainActor in
            try? await Task.sleep(for: .seconds(2))
            self.value = "change"
        }
    }
复制代码
```

也可以使用`@MainActor`将方法或者类标记运行在主队列。

## SwiftUI中使用

SwiftUI中直接`.task`修饰符即可。

```swift
Text("Hello World 🌍")
    .task {
        await fn()
    }
复制代码
```

同时有一点比较好的是在`onDisappear`的时候会自动取消`Task`。

## 结语

作为初学者，Swift Concurrency简化了很多异步相关的问题，不需要再去使用闭包了，不会造成回调地狱，结合SwiftUI使用比Combine更简单友好，非常不错。





作者：ZHANGYU
链接：https://juejin.cn/post/7181121378471378981
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。