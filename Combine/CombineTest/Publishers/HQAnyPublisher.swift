//
//  HQAnyPublisher.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/22.
//

import Foundation
import Combine

class HQAnyPublisher: BaseTest {
    
    func test() {
        
        //
        let pass = PassthroughSubject<Int, SampleError>()
        // or  任意 publisher 都可以通过以下方式 暴露给外部定义，而不必被外界任意使用
//        let anyPublisher = pass.eraseToAnyPublisher()
        
        // 包装  隐藏细节
        let anyPublisher = AnyPublisher(pass)
        anyPublisher.sink { v in
            debugPrint("AnyPublisher completion: \(v)")
        } receiveValue: { v in
            debugPrint("AnyPublisher receiveValue: \(v)")
        }.store(in: &cancelables)
        
        //
        pass.send(23)
        pass.send(completion: .finished)
    }
}
