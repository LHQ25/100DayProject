//
//  HQPassthroughSubject.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQPassthroughSubject: BaseTest {
    
    // MARK: - PassthroughSubject  -> Rx: PublishRelay or PublishSubject
    func test() {
        
        //
        let subject = PassthroughSubject<Int, SampleError>()
        
        // 订阅
        subject
            .sink { _ in
            debugPrint("PassthroughSubject completion")
        } receiveValue: { value in
            debugPrint("PassthroughSubject", value)
        }
        .store(in: &cancelables)
    
        
        // 空值 void ->  Available when Output is ().
        // subject.send()
        
        subject.send(1)
        subject.send(2)
        subject.send(3)
        subject.send(4)
        
        
        // 完成
        subject.send(completion: .finished)
        // or
        // subject.send(completion: .failure(.sampleError))
        
        
        // subject.send(subscription: <#T##Subscription#>)
    }
}
