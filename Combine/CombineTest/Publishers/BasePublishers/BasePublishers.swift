//
//  ConveniencePublishers.swift
//  CombineTest
//
//  Created by cbkj on 2021/9/30.
//

import Foundation
import Combine

struct BasePublishersTest {
    
    static func loadTest() {
        
        // Empty
        // emptyTest()
        
        // Just
        // justTest()
        
        // Deferred
        // deferredTest()
        
        // Fail
        // failTest()
        
        // Record
        // recordTest()
        
        // Future
        // futureTest()
    }
    
    static func emptyTest() {
    
        /*
         “Empty 是一个最简单的发布者，它只在被订阅的时候发布一个完成事件 (receive finished)。
         这个 publisher 不会输出任何的 output 值，只能用于表示某个事件已经发生”
         */
        check("Empty") {
            Empty<Int, SampleError>()
        }
    }
    
    static func justTest() {
    
        /*
         “如果我们想要 publisher 在完成之前发出一个值的话，
         可以使用 Just，它表示一个单一的值，
         在被订阅后，这个值会被发送出去，紧接着是 finished”
         */
        check("Just") {
            Just("3")
        }
        /*
            在 Just 的输出中，和 Empty 相比，
            多了一个 “receive value: (1)” 的 output 事件。
            除了 output 和 finished 以外，我们还看到两者都有两行额外的内容：“receive subscription” 和 “request unlimited”。Publisher 在接收到订阅，并且接受到请求要求提供若干个事件后，才开始对外发布事件
         */
    }
    
    static func deferredTest() {
    
        /*
         被订阅是才会创建去一个Publisher
         */
        check("Deferred") {
            
            Deferred {
                // 返回一个Publisher
                Just(12345)
            }
        }
    }
    
    static func failTest() {
    
        /*
         仅发布一个错误Publisher,然后立即终止Publisher数据流
         */
        check("Fail") {
            Fail<Int, SampleError>(outputType: Int.self, failure: .sampleError)
        }
    }
    
    
    static func recordTest() {
        
        // 每次被订阅都会发生之前定义好的Record， 类似于RxSwift中的Relay
        
        // - 1
//        check("Record1") { () -> Record<String, Error> in
//
//            // 第一种初始化方式
//            // Record<Int, Error>(output: [1,2,3,4,5], completion: .finished)
//
//            // 第二种初始化方式
//            let rr1 = Record<String, Error>.Recording(output: ["a", "b", "c"], completion: .finished)
//            return Record<String, Error>(recording: rr1)
//
//            // 第三种
////            return Record<String, Error> { record in }
//        }
        
        // - 2
        let r = Record<String, Error>(output: ["a", "b", "c"], completion: .finished)
        check("Record1") { () -> Record<String, Error> in
            r
        }
        check("Record2") { () -> Record<String, Error> in
            Record<String, Error>(recording: r.recording)
        }
    }
    
    static func futureTest() {
        
        // 异步 Publisher
        check("Future") {
            
            Future<String, Error> { fp in
                DispatchQueue.global().async {
                    let rs = Result<String, Error>.success("1234")
                    fp(rs)
                }
            }
        }
    }
}
