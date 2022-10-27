//
//  HQFuture.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQFuture: BaseTest {
    
    func test() {
        
        // 支持 并发 异步
        let future = Future<Int, SampleError> { promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(Result.success(3))
            }
            // or
            // promise(Result.failure(.sampleError))
        }
        
        // 异步 订阅 方式就收不到值
        let cancelable = future
            .print("Future ->")
            .sink { v in
            debugPrint("Future completion: \(v)")
        } receiveValue: { v in
            
            debugPrint("Future receiveValue: \(v)")
        }
        
//        debugPrint("Future : \(try await future.value)")

        
        // 并发 方式 获取值
        let value = Task {
            if #available(iOS 15.0, *) {
               let v = try? await future.value
                debugPrint("并发获取值： Future async: \(v)")
                return v
            } else {
                return nil
            }
        }
        
        cancelable.store(in: &cancelables)

    }
}
