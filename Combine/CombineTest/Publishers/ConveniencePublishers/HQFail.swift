//
//  HQFail.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQFail: BaseTest {
    
    func test() {
        
        // 立即 发出 指定的 错误  Rx: Error
//        let fail = Fail<Int, SampleError>(error: SampleError.stringError(msg: "1234"))
        // 显示 指定
        let fail = Fail(outputType: Int.self, failure: SampleError.stringError(msg: "stringError"))
        
        let cancelable = fail
            .print("Fail ->")
            .sink { v in
            debugPrint("Fail completion: \(v)")
        } receiveValue: { v in
            debugPrint("Fail receiveValue: \(v)")
        }
        debugPrint("Fail : \(fail.error)")
        
        cancelable.store(in: &cancelables)

    }
}
