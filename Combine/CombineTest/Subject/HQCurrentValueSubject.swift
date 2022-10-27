//
//  HQCurrentValueSubject.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQCurrentValueSubject: BaseTest {
    
    // MARK: - CurrentValueSubject  -> Rx : BehaviorRelay or BehaviorSubject
    func test() {
        
        //
        let currentValueSubject = CurrentValueSubject<Int, SampleError>(23)
        
        // 订阅
        currentValueSubject
            .sink { _ in
            debugPrint("CurrentValueSubject completion")
        } receiveValue: { value in
            debugPrint("CurrentValueSubject", value)
        }
        .store(in: &cancelables)
        
        debugPrint("CurrentValueSubject: value1 -> \(currentValueSubject.value)")
        
        // 空值 void ->  Available when Output is ().
        // currentValueSubject.send()
        
        currentValueSubject.send(1)
        currentValueSubject.send(2)
        currentValueSubject.send(3)
        currentValueSubject.send(4)
        
        debugPrint("CurrentValueSubject: value2 -> \(currentValueSubject.value)")
        
        // 完成
        currentValueSubject.send(completion: .finished)
        // or
        // currentValueSubject.send(completion: .failure(.sampleError))
        
        
        // currentValueSubject.send(subscription: <#T##Subscription#>)
    }
}
