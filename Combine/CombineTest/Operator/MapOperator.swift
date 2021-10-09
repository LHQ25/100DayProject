//
//  MapOperator.swift
//  CombineTest
//
//  Created by cbkj on 2021/9/30.
//

import Foundation
import Combine

struct MapOperator {
    
    static func loadMapOperator() {
        
        mapTest()
        
        tryMapTest()
        
        mapErrorTest()
        
        replaceNilTest()
        
        scanTest()
        
        tryScanTest()
        
        setFailureTypeTest()
        
        flatMapTesdt()
        
        switchToLeastTest()
    }
    
    static func mapTest() {
        
        // 数据转换
        check("Map") {
            Just(3)
                .map { v in
                    return "string - \(v)"
                }
        }
        
        
        //使用键路径识别属性
        check("Map - keyPath") {
            Just(CustomData(name: "name1", age: 111))
                .map(\.name)
        }
        
        // 过个路径
        check("Map - keyPath2") {
            Just(CustomData(name: "name1", age: 111))
                .map(\.name, \.age)
        }
    }
    
    static func tryMapTest() {
    
    // 尝试数据转换, 会抛出错误
//        check("tryMap") {
//
//        }
    print("----- tryMap -----")
    defer {
        print("")
    }
    
    Just(3)
        .print()
        .tryMap({ v in
            Result<String, Error>.success("string - \(v)")
        })
        .sink { error in
            switch error {
            case let .failure(error):
                print("error:", error)
            case .finished:
                print("finished")
            }
            
        } receiveValue: { result in
            switch result {
            case let .success(v):
                print(v)
            case let .failure(error):
                print("error:", error)
            }
        }.cancel()

}
    
    static func mapErrorTest() {
    
    // 错误类型 转换为自己需要的错误类型
//        check("tryMap") {
//
//        }
    print("----- mapError -----")
    defer {
        print("")
    }
    
    Fail<Any, NSError>(error: NSError(domain: "HQ", code: -1, userInfo: nil))
        .print()
        .mapError({ error in
            SampleError.customError(error: error)
        })
        .sink {_ in }
            receiveValue: { _ in
        }.cancel()

}
    
    static func replaceNilTest() {
        
        
        // 替换 nil 为指定元素
        check("replaceNil") {
            
            Just<String?>(nil)
                .replaceNil(with: "replaceNil - recvice")
        }
        
    }
    
    static func scanTest() {
        
        print("----  scan  ----")
        defer {
            print("")
        }
        Just(123)
            .print()
            .scan(CustomResult()) { r, oldValue in
                r.addSomeNum(old: oldValue)
                return r
            }
            .sink { cr in
                print(cr.result)
            }.cancel()

        
    }
    
    static func tryScanTest() {
        
        print("----  tryScan  ----")
        defer {
            print("")
        }
        Just(333)
            .print()
            .tryScan(CustomResult()) { r, oldValue in
                r.addSomeNum(old: oldValue)
                return r
            }
            .sink { result in
                switch result {
                case let .failure(error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { result in
                print(result.result)
            }.cancel()
    }
    
    static func setFailureTypeTest() {
        
        
        // 失败时 设置Error类型, 修改之前设置错误类型
        print("----  tryScan  ----")
        defer {
            print("")
        }
        Just(0)
            .print()
            .setFailureType(to: SampleError.self)
            .tryScan(CustomResult()) { r, oldValue in
                r.addSomeNum(old: oldValue)
                return r
            }
            .sink { result in
                switch result {
                case let .failure(error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { result in
                print(result.result)
            }.cancel()
    }
    
    static func flatMapTesdt() {
        
        
        /// 将上游Publisher中的所有元素转换为Publisher，最多为您指定的最大Publisher数
        /// 转换为其它publisher
        check("flatMap - maxPublishers") {
                Just([[20, 2, 11], [1, 4, 5]])
                    .flatMap(maxPublishers: .unlimited) { data in
                        Just(data.randomElement())
                    }
        }
        
        check("flatMap") {
                Just([1, 4, 5])
                    .flatMap({ data in
                        Just("\(data.randomElement())")
                    })
        }
    }
    
    static var cancel: AnyCancellable?
    static func switchToLeastTest() {

        // 此运算符与上游Publisher合作，将元素流展平，使其看起来好像来自单个元素流。
        // 它在新Publisher到达时切换内部Publisher，但为下游订阅者保持外部Publisher不变。
        
        print("----- \("switchToLatest") -----")
        defer { print("") }
        let subject = PassthroughSubject<Int, Never>()
        let cancel = subject
            .print()
            .setFailureType(to: URLError.self)
            .map() { index -> URLSession.DataTaskPublisher in
                let url = URL(string: "https://example.org/get?index=\(index)")!
                return URLSession.shared.dataTaskPublisher(for: url)
            }
            .switchToLatest()
            .sink(receiveCompletion: { print("Complete: \($0)") },
                  receiveValue: { (data, response) in
                    guard let url = response.url else { print("Bad response."); return }
                    print("URL: \(url)")
            })

        for index in 1...5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(index/10)) {
                subject.send(index)
            }
        }
    }
}

// MARK: - CustomResult
class CustomResult {
    
    var result: Int = 1
    
    func addSomeNum(old: Int) {
        
        result += old
    }
}
