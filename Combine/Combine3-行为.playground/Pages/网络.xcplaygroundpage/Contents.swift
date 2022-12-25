//: [Previous](@previous)

import Foundation
import Combine

struct Model: Codable {
    var platformIcon: String
    var title: String
    var platformName: String
    var indexURL: String
}

let url2 = URL(string: "http://192.168.17.171:8000/test")

// 1 保留最终的 subscription 至关重要； 否则，它会立即被取消，并且请求永远不会执行
let subscription4 = URLSession.shared
    // 2 你正在使用将 URL 作为参数的 dataTaskPublisher(for:) 的重载
    .dataTaskPublisher(for: url2!)
//    .tryMap { data, _ in
//        try JSONDecoder().decode([Model].self, from: data)
//    }
    .map(\.data).decode(type: [Model].self, decoder: JSONDecoder())  // 在 tryMap 中解码 JSON，该方法有效，但 Combine 提供了一个操作符来帮助减少代码
    .sink(receiveCompletion: { value in
        if case .failure(let err) = value {
            print("Retrieving data failed with error \(err)")
        }
    }, receiveValue: { model in
        // 4 结果是包含 Data 对象和 URLResponse 的元组
        print("Retrieved data of size \(model.count), response = \(model)")
    })
    

// 向多个订阅者发布网络数据
let url = URL(string: "https://www.raywenderlich.com")!
let publisher = URLSession.shared
    // 1 创建你的 DataTaskPublisher，map 到它的 data，然后 multicast。你传递的闭包必须返回适当类型的 subject。 或者，你可以将现有 subject 传递给multicast(subject:)。 你将在后文中了解有关多播的更多信息
    .dataTaskPublisher(for: url)
    .map(\.data)
    // 一种解决方案是使用 multicast() 操作符，它创建一个 ConnectablePublisher，通过 Subject 发布值。 它允许你多次订阅 subject，然后在你准备好时调用发布者的 connect() 方法
    .multicast { PassthroughSubject<Data, URLError>() }

// 2 首次订阅发布者。 由于它是一个 ConnectablePublisher，它不会立即开始工作
let subscription1 = publisher
    .sink(receiveCompletion: { completion in
        if case .failure(let err) = completion {
            print("Sink1 Retrieving data failed with error \(err)")
        }
    }, receiveValue: { object in
        print("Sink1 Retrieved object \(object)")
    })

// 3 再次订阅
let subscription2 = publisher
    .sink(receiveCompletion: { completion in
        if case .failure(let err) = completion {
            print("Sink2 Retrieving data failed with error \(err)")
        }
    }, receiveValue: { object in
        print("Sink2 Retrieved object \(object)")
        
    })

// 4 准备好后连接发布者。 它将开始工作并向所有订阅者推送值
let subscription = publisher.connect()

// 使用此代码，你可以一次性发送请求并与两个订阅者共享结果。
// 注意：确保存储所有 Cancelable；否则，它们将在离开当前代码范围时被释放和取消，这在这种特定情况下是立即的


//: [Next](@next)
