//
//  HQAnySubscriber.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQAnySubscriber: BaseTest {
    
    func test() {
        
        let subject = PassthroughSubject<Int, Never>()
        
        let sink = Subscribers.Sink<Int, Never> { v in
            debugPrint("receiveValue receiveCompletion \(v)")
        } receiveValue: { v in
            debugPrint("receiveValue \(v)")
        }
        // 对于已经存在的 Subscriber
        let anySubscriber = AnySubscriber(sink)
        subject.subscribe(anySubscriber)
        
        
        // 自己实现，不用已存在的 Subscriber
        let anySubscriber2 =  AnySubscriber<Int, Never>(receiveSubscription: { v in
            debugPrint("receiveValue2 \(v)")
            // 别忘了请求数据
            v.request(.unlimited)
        }, receiveValue: { v in
            debugPrint("receiveValue2 \(v)")
            return .unlimited
        }, receiveCompletion: { v in
            debugPrint("receiveValue2 receiveCompletion \(v)")
        })
        subject.subscribe(anySubscriber2)
        
        
        subject.send(121)
        subject.send(131)
        subject.send(141)
        
        subject.send(completion: .finished)
        
    }
}
