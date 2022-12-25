
import UIKit
import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}


// 1. Never
// 失败类型为 Never 的发布者表示发布者永远不会失败
example(of: "Never sink") {
    
    Just("Hello")
        // 使用 sink(receiveValue:)。 这种特定的 sink 重载使你可以忽略发布者的完成事件，而只处理其发出的值
        .sink(receiveValue: {
            print($0)
        })
    .store(in: &subscriptions)
}

// 2. setFailureType
// 将可靠的发布者转变为可靠的发布者的第一种方法是使用 setFailureType。这是另一个仅适用于失败类型为 Never 的发布者的操作符
enum MyError: Error {
    case ohNo
}
example(of: "setFailureType") {
    
    Just("Hello")
        // 使用 setFailureType 将发布者的失败类型更改为 MyError
        .setFailureType(to: MyError.self)
        // 1 它正在使用 sink(receiveCompletion:receiveValue:)。 sink(receiveValue:) 重载不再可用，因为此发布者可能会以失败事件完成。 结合迫使你处理此类发布者的完成事件
        .sink(receiveCompletion: { completion in
            switch completion {
                // 2 失败类型被严格键入为 MyError，这使你可以针对.failure(.ohNo) 情况而无需进行不必要的强制转换来处理该特定错误
            case .failure(.ohNo):
                print("Finished with Oh No!")
            case .finished:
                print("Finished successfully!")
            }
        }, receiveValue: { value in
            print("Got value: \(value)")
        }).store(in: &subscriptions)
    
    // setFailureType 的作用只是类型系统定义。 由于原始发布者是 Just，因此实际上不会引发任何错误
}

// 3. assign(to:on:)
// 在第 2 节“发布者和订阅者”中学到的 assign 操作符仅适用于不会失败的发布者，与 setFailureType 相同。
// 如果你仔细想想，这完全有道理。 向提供的 key path 发送错误会导致未处理的错误或未定义的行为
example(of: "assign(to:on:)") {
    
    // 1 定义一个具有 id 和 name 属性的 Person 类
    class Person {
        let id = UUID()
        var name = "Unknown"
    }
    
    // 2 创建一个 Person 实例并立即打印其名称
    let person = Person()
    print("1", person.name)
    
    Just("Shai")
        // 只要 Just 发出它的值，assign 就会更新这个人的名字，这是有效的，因为 Just 不会失败。 相反，如果发布者有一个非从不失败的类型，你认为会发生什么
        // .setFailureType(to: Error.self)  // 将失败类型设置为标准 Swift 错误。 这意味着它不再是 Publisher<String, Never>，而是现在的 Publisher<String, Error>
        // Error: Referencing instance method 'assign(to:on:)' on 'Publisher' requires the types 'any Error' and 'Never' be equivalent
        .handleEvents(
            // 3 一旦发布者发送完成事件，使用你之前了解的handleEvents 再次打印此人的 name
            receiveCompletion: { _ in
                print("2", person.name)
            })
        .assign(to: \.name, on: person)
        // 4 最后，使用assign 将人名设置为发布者发出的任何内容
        .store(in: &subscriptions)
    
}

example(of: "assign(to:)") {
    class MyViewModel: ObservableObject {
        
        // 1 在视图模型对象中定义一个@Published 属性。 它的初始值为当前日期
        @Published var currentDate = Date()
        
        init() {
            Timer.publish(every: 1, on: .main, in: .common)
            // 2 创建一个计时器发布者，它每秒发出当前日期
                .autoconnect()
                .prefix(3)
            // 3 使用前缀操作符只接受 3 个日期更新。
                // .assign(to: \.currentDate, on: self)
                .assign(to: &$currentDate)
            // 4 应用 assign(to:on:) 操作符将每个日期更新分配给你的 @Published 属性。
            // .store(in: &subscriptions)
            
        }
        
    }
    
    // 5 实例化你的视图模型，sink 已发布的发布者，并打印出每个值。
    let vm = MyViewModel()
    vm.$currentDate
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 对assign(to:on:) 的调用创建了一个 strongly retains self 的订阅。 本质上——self 挂在订阅上，而订阅挂在 self 上，创建了一个导致内存泄漏的保留周期
    
    // 幸运的是，Apple 的好人意识到这是有问题的，并引入了该操作符的另一个重载 - assign(to:)。
    // 该操作符专门处理通过提供对其投影发布者的 inout 引用来将发布的值重新分配给 @Published 属性。
    
    // .assign(to: &$currentDate)
    
    // 使用 assign(to:) 操作符并将 inout 引用传递给预计的发布者会打破保留周期，让你轻松处理上述问题。
    // 此外，它会在内部自动处理订阅的内存管理，这样你就可以省略 store(in: &subscriptions) 行
    
}

// 4. assertNoFailure
// 当你想在开发过程中保护自己并确认发布者以成失败事件完成时，assertNoFailure 操作符非常有用。它不会阻止上游发出失败事件。但是，如果它检测到错误，它会因致命错误而崩溃
example(of: "assertNoFailure") {
    
    // 1 使用 Just 创建一个可靠的发布者并将其失败类型设置为 MyError
    Just("Hello")
        .setFailureType(to: MyError.self)
        // .tryMap { _ in throw MyError.ohNo } // 由于发布者 failure ，playground 崩溃。 在某种程度上，你可以将 assertFailure() 视为代码的保护机制
        .assertNoFailure()
        // 2 如果发布者以失败事件完成，则使用 assertNoFailure 以致命错误崩溃。 这会将发布者的失败类型转回 Never
        .sink(receiveValue: {
            print("Got value: \($0) ")
        })
        // 3 使用 sink 打印出任何接收到的值。 请注意，由于 assertNoFailure 将失败类型设置回 Never，因此 sink(receiveValue:) 重载再次由你使用。
        .store(in: &subscriptions)
    
}

// 5. 处理失败
// try* 操作符
example(of: "tryMap") {
    
    // 1 定义一个 NameError 错误枚举
    enum NameError: Error {
        case tooShort(String)
        case unknown
    }
    
    // 2 创建发布三个不同字符串的发布者
    let names = ["Marin", "Shai", "Florent"].publisher
    names
    // 3 将每个字符串映射到它的长度
        // .map { value in
        //    return value.count
        // }
        // 替换 -> 如果你的代码接受的名称少于 5 个字符，则它应该引发错误
        .tryMap { value -> Int in
            // 1
            let length = value.count
            // 2
            guard length >= 5 else { throw NameError.tooShort(value) }
            // 3
            return value.count
        }
        .sink(receiveCompletion: {
            print("Completed with \($0)")
        }, receiveValue: {
            print("Got value: \($0)")
        })
    
}

example(of: "map vs tryMap") {
    
    // 1 定义一个用于此示例的 NameError
    enum NameError: Error {
        case tooShort(String)
        case unknown
    }
    
    // 2 创建一个只发出字符串 Hello 的 Just
    Just("Hello")
        .setFailureType(to: NameError.self)
        // 3 使用 setFailureType 设置失败类型为 NameError
        // .tryMap { $0 + " World!" }
        .tryMap { throw NameError.tooShort($0) }
        // 4 使用 map 将另一个字符串附加到已发布的字符串
        .mapError { $0 as? NameError ?? .unknown } // // tryMap 删除了你的严格类型错误并将其替换为通用 Swift.Error 类型
        // mapError 接收上游发布者抛出的任何错误，并让你将其映射到你想要的任何错误
        .sink(receiveCompletion: { completion in
            // 5 最后，使用 sink 的 receiveCompletion 为 NameError 的每个失败情况打印出适当的消息
            switch completion {
            case .finished:
                print("Done!")
            case .failure(.tooShort(let name)):
                print("\(name) is too short!")
            case .failure(.unknown):
                print("An unknown name error occurred")
            }
        }, receiveValue: {
            print("Got value \($0)")
        })
    .store(in: &subscriptions)
    
}

// 4. 设计自己的可能会发生错误的 API
// 在构建你自己的基于 Combine 的代码和 API 时，你通常会使用来自其他来源的 API，这些 API 会返回因各种类型而失败的发布者。在创建自己的 API 时，你通常还希望围绕该 API 提供自己的错误
example(of: "Joke API") {
    
    class DadJokes {
        
        // 1 定义一个 Joke 结构。 API 响应将被解码为 Joke 的一个实例。
        struct Joke: Codable {
            let id: String
            let joke: String
        }
        
        enum Error: Swift.Error, CustomStringConvertible {
            // 1 概述 DadJokes API 中可能出现的所有错误。
            case network
            case jokeDoesntExist(id: String)
            case parsing
            case unknown
            
            // 2 符合 CustomStringConvertible，让你可以为每个错误情况提供友好的描述。
            var description: String {
                switch self {
                case .network:
                    return "Request to API Server failed"
                case .parsing:
                    return "Failed parsing response from server"
                case .jokeDoesntExist(let id):
                    return "Joke with ID \(id) doesn't exist"
                case .unknown:
                    return "An unknown error occurred"
                }
            }
        }
        
        // 2 提供一个 getJoke(id:) 方法，该方法当前返回一个发布者，该发布者发出一个 Joke，并且可能会因标准 Swift.Error 而失败。
        func getJoke(id: String) -> AnyPublisher<Joke, Error> {
            
            // 确保 id 至少包含一个字母。如果不是这种情况，你会立即返回 Fail
            // Fail 是一种特殊的发布者，它可以让你立即且强制地失败并显示提供的错误。它非常适合你希望根据某些条件提前失败的情况。最后，你使用 eraseToAnyPublisher 获得预期的 AnyPublisher<Joke, DadJokes.Error> 类型
            guard id.rangeOfCharacter(from: .letters) != nil
            else {
                return Fail<Joke, Error>(error: .jokeDoesntExist(id: id))
                    .eraseToAnyPublisher()
            }
            
            let url = URL(string: "https://icanhazdadjoke.com/j/\(id)")!
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Accept": "application/json"]
            
            // 3 使用 URLSession.dataTaskPublisher(for:) 调用 icanhazdadjoke API 并使用 JSONDecoder 和 decode 操作符将结果数据解码为 Joke。
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: Joke.self, decoder: JSONDecoder())
                .mapError { error -> DadJokes.Error in
                    switch error {
                    case is URLError:
                        return .network
                    case is DecodingError:
                        return .parsing
                    default:
                        // 失败实际上被视为未知错误，而不是 DadJokes.Error，因为你没有在 mapError 中处理该类型
                        return error as? DadJokes.Error ?? .unknown
                    }
                }
            .eraseToAnyPublisher()
        }
    }
    
    // 4 创建一个 DadJokes 的实例，并定义具有有效和无效笑话 ID 的两个常量。
    let api = DadJokes()
    let jokeID = "9prWnjyImyd"
    let badJokeID = "123456"
    
    // 5 使用有效的笑话 ID 调用 DadJokes.getJoke(id:) 并打印任何完成事件或解码的笑话本身。
    api
        // .getJoke(id: jokeID)
        .getJoke(id: badJokeID)  // 一个不存在的笑话 ID, 可能会报错, 当你发送一个不存在的 ID 时，icanhazdadjoke 的 API 并不会因 HTTP 代码 404（未找到）而失败——正如大多数 API 所期望的那样
        // 使用 tryMap 在将原始数据传递给解码操作符之前执行额外的验证
        .tryMap { data -> Data in
            
            // 6 使用 JSONSerialization 来尝试检查状态字段是否存在且值为 404 — 即，笑话不存在。 如果不是这种情况，你只需返回数据，以便将其推送到下游的解码操作员
            guard let obj = try? JSONSerialization.jsonObject(with: data),
                    let dict = obj as? [String: Any],
                  dict["status"] as? Int == 404
            else { return data  }
            
            // 7 如果你确实找到了 404 状态码，你会抛出一个 .jokeDoesntExist(id:) 错误
            throw DadJokes.Error.jokeDoesntExist(id: id)
        }
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print("Got joke: \($0)")
        })
        .store(in: &subscriptions)
}


// 5. 捕获错误和重试失败的发布者。
// Publisher 是一种表示工作的统一方式的好处在于，你拥有许多操作符，可以让你用很少的代码行完成大量工作
class PhotoService: ObservableObject {
    
    enum Quality {
        case low
        case high
    }
    
//    class Publisher {
//
//    }
    
    func fetchPhoto(quality: Quality, failingTimes: Int = 2) -> AnyPublisher<UIImage, Never> {
        
        return Just(UIImage())
            .eraseToAnyPublisher()
    }
}
let photoService = PhotoService()
example(of: "Catching and retrying") {
    photoService
    .fetchPhoto(quality: .low)
    // 有四次尝试。 初始尝试，加上由重试操作符触发的三次重试。 由于获取高质量照片不断失败，因此操作员会耗尽所有重试尝试并将错误推送到 sink
    .handleEvents(receiveSubscription: { _ in
        print("Trying ...")
    }, receiveCompletion: {
        guard case .failure(let error) = $0 else { return }
        print("Got error: \(error)")
    })
    .retry(3)                       // 如果发布者失败，它将重新订阅上游并重试至你指定的次数。如果所有重试都失败，它只是将错误推送到下游，就像没有重试操作符一样
    .catch { error -> PhotoService.Publisher in
        print("Failed fetching high quality, falling back to low quality")
        return photoService.fetchPhoto(quality: .low)
    }
    .replaceError(with: UIImage(named: "na.jpg")!)
    .sink(receiveCompletion: {
        print("\($0)")
    }, receiveValue: { image in
        image
        print("Got image: \(image)")
    })
    .store(in: &subscriptions)
}
