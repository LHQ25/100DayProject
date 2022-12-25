//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "map") {
    
    // var subscriptions = Set<AnyCancellable>()
    
    // 1 创建一个数字格式化程序来拼出每个数字
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    // 2 创建整数发布者
    [123, 4, 56].publisher
        // 3 使用 map，传递一个获取上游值的闭包，并返回使用格式化程序返回数字的拼写字符串的结果
        .map {
            formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
        }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
}

struct Coordinate {
    var x: Double
    var y: Double
}

func quadrantOf(x: Double, y: Double) -> String {
    "x: \(x), y: \(y)"
}

example(of: "mapping key paths -> 映射 KeyPath") {
    
    // var subscriptions = Set<AnyCancellable>()
    
    // 1 创建一个永远不会发出错误的坐标发布者
    let publisher = PassthroughSubject<Coordinate, Never>()
    // 2 开始订阅发布者
    publisher
        // 3 使用它们的关键路径映射到 Coordinate 的 x 和 y 属性
        .map(\.x, \.y)
        .sink(receiveValue: { x, y in
            // 4 打印一条语句，指出提供 x 和 y 值的象限
            print("The coordinate at (\(x), \(y)) is in quadrant", quadrantOf(x: x, y: y))
        })
        .store(in: &subscriptions)
    // 5 通过发布者发送一些坐标
    publisher.send(Coordinate(x: 10, y: -8))
    publisher.send(Coordinate(x: 0, y: 5))
    
}


// 包括 map 在内的几个操作符都有一个带有 try 前缀的对应项，该前缀接受一个抛出的闭包。 如果你抛出错误，操作符将在下游发出该错误
example(of: "tryMap") {
    
    // 1 创建表示不存在的目录名称的字符串的发布者
    Just("Directory name that does not exist")
        // 2 使用 tryMap 尝试获取该不存在目录的内容
        .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
        // 3 接收并打印出任何值或完成事件
        .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
    .store(in: &subscriptions)
    
    // 在调用抛出方法时仍需要使用 try 关键字
    
}

// MARK: - 展平发布者(Flattening publishers)
example(of: "flatMap") {
    
    // 1 定义一个函数，该函数接受一个整数数组，每个整数表示一个 ASCII 码，并返回一个类型擦除的字符串发布者，该发布者从不发出错误
    func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
        // 2 如果字符代码在 0.255 范围内，则创建一个将其转换为字符串的 Just 发布者，其中包括标准和扩展的可打印 ASCII 字符
        Just(codes.compactMap { code in
            guard (32...255).contains(code) else { return nil }
            return String(UnicodeScalar(code) ?? " ")
        }
             // 3 使用 Join 将字符串连接在一起
            .joined())
        // 4 擦除发布者类型，匹配函数的返回类型
        .eraseToAnyPublisher()
    }
    
    // flatMap 操作符将多个上游发布者展平为一个下游发布者。flatMap 返回的发布者与它接收的上游发布者的类型不同，而且通常都是不同的。
    // 在 Combine 中 flatMap 的一个常见用例是，当你想要将一个发布者发出的元素传递给一个本身返回一个发布者的方法，并最终订阅第二个发布者发出的元素时
    
    // 5 将 ASCII 字符代码数组转换为发布者，并将其发出的元素收集到单个数组中
    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33].publisher
        .collect()
        // 6 使用 flatMap 将数组元素传递给你的 decode 函数
        .flatMap(decode)
        // 7 订阅由 decode(_:) 返回的发布者发出的元素并打印出这些值
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    // flatMap 将所有接收到的发布者的输出展平为一个新发布者。这可能会引起内存问题，因为它会缓冲与你发送它一样多的发布者，以更新它在下游发出的单个发布者
}

//: [Next](@next)
