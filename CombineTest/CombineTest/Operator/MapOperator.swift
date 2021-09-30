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
    }
    
    static func mapTest() {
    
    // 数据转换
    check("Map") {
        Just(3)
            .map { v in
                return "string - \(v)"
            }
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
}

// MARK: - CustomResult
class CustomResult {
    
    var result: Int = 1
    
    func addSomeNum(old: Int) {
        
        result += old
    }
}
