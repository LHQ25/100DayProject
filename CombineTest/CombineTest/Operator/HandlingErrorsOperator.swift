//
//  HandlingErrorsOperator.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct HandlingErrorsOperator {
    
    
    static func loadOperatorsTest() {
     
        assertNoFailureTest()
        
        catchTest()
        
        retryTest()
    }
    
    static func assertNoFailureTest() {
        
        print("----- \("assertNoFailure") -----")
        defer { print("") }
        
        let pub = PassthroughSubject<Int, SampleError>()
       
        // 当上游发布者失败时引发致命错误，否则重新发布所有收到的输入。
//        check("assertNoFailure") {
//            
//            pub.assertNoFailure()
//        }
        let _ = pub.print()
            .sink { _ in
                
            } receiveValue: { _ in
                
            }
        
        pub.send(2)
        pub.send(3)
        pub.send(completion: .failure(.sampleError))
        pub.send(4)
    }
    
    static func catchTest() {
        
        let pub = PassthroughSubject<Int, SampleError>()
            
        // 当通过将上游Publisher替换为另一个Publisher来处理来自上游Publisher的错误。
        check("catch") {

            pub.map({ _ in SampleError.stringError(msg: "CCCCC") })
                .catch { error in
                    Just(SampleError.sampleError)
                }
        }
        
        check("tryCatch") {

            pub.map({ _ in SampleError.stringError(msg: "CCCCC") })
                .tryCatch { error -> Just<SampleError> in
                    throw SampleError.stringError(msg: "tryCatch")
//                    return Just(SampleError.sampleError)
                }
        }
        
        pub.send(999)
    }
    
    static func retryTest() {
        
        // 尝试与上游Publisher重新创建失败的订阅，次数不超过您指定的次数。
        let pub = PassthroughSubject<Int, SampleError>()
            
        // 当通过将上游Publisher替换为另一个Publisher来处理来自上游Publisher的错误。
        check("retry") {

            pub.retry(2)
        }
        
        pub.send(completion: .failure(.sampleError))
    }
}
