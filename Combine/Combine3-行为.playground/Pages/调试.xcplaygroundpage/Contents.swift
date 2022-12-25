import Foundation
import Combine

// 理解异步代码中的事件流一直是一个挑战。在 Combine 的上下文中尤其如此，因为发布者中的操作符链可能不会立即发出事件。 例如，像 throttle(for:scheduler:latest:) 这样的操作符不会发出它们接收到的所有事件，所以你需要了解发生了什么。 Combine 提供了一些操作符来帮助调试你的反应流

// 1. print(_:to:) 操作符是你在不确定是否有任何内容通过你的发布者时应该使用的第一个操作符
let subscription = (1...3).publisher
    .print("publisher")
    .sink { _ in }
/*
 在收到订阅时打印并显示其上游发布者的描述。
 打印订户的 demand request，以便你查看请求的项目数量。
 打印上游发布者发出的每个值。
 最后，打印完成事件
 */


// 2. 有一个额外的参数接受一个 TextOutputStream 对象。 你可以使用它来重定向字符串以打印到记录器。 你还可以在日志中添加信息，例如当前日期和时间等
class TimeLogger: TextOutputStream {
    
    private var previous = Date()
    private let formatter = NumberFormatter()
    
    init() {
        formatter.maximumFractionDigits = 5
        formatter.minimumFractionDigits = 5
    }
    
    func write(_ string: String) {
        
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let now = Date()
        print("+\(formatter.string(for: now.timeIntervalSince(previous))!)s: \(string)")
        previous = now
    }
}

let subscription2 = (1...3).publisher
    .print("publisher", to: TimeLogger())
    .sink { _ in }


// 3. 执行副作用
// 除了打印信息外，对特定事件执行操作通常很有用。 我们将此称为执行副作用，因为你“在一边”采取的操作不会直接影响下游的其他发布者，但会产生类似于修改外部变量的效果
let request = URLSession.shared
    .dataTaskPublisher(for: URL(string: "http://192.168.17.171:8000/test")!)

let subscription3 = request
    // 让你可以拦截发布者生命周期中的所有事件，然后在每个步骤中采取行动
    .handleEvents(receiveSubscription: { _ in
        print("Network request will start")
    }, receiveOutput: { _ in
        print("Network request data received")
    }, receiveCancel: {
        print("Network request cancelled")
    })
    .sink(receiveCompletion: { completion in
        print("Sink received completion: \(completion)")
    }) { (data, _) in
        print("Sink received data: \(data)")
    }

// 4. 使用 Debugger 操作符作为最后的手段
// Debugger 操作符是你在万不得已的时候确实需要使用的操作符，因为没有其他方法可以帮助你找出问题所在

// 第一个简单的操作符是 breakpointOnError()。 顾名思义，当你使用此操作符时，如果任何上游发布者发出错误，Xcode 将在调试器中中断，让你查看堆栈，并希望找到你的发布者错误的原因和位置

// 一个更完整的变体是 breakpoint（receiveSubscription:receiveOutput:receiveCompletion:)。 它允许你拦截所有事件并根据具体情况决定是否要暂停

// 假设上游发布者发出整数值，但值 11 到 14 永远不会发生，你可以将断点配置为仅在这种情况下中断并让你调查！你还可以有条件地中断订阅和完成，但不能像 handleEvents 操作符那样拦截 Cancel
