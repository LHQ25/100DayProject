//
//  HQDeferred.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQDeferred: BaseTest {
    
    func test() {
        
        
        // 被订阅时 才 在闭包 创建   Rx: Create
        debugPrint("创建")
        let deferred = Deferred {
            debugPrint("创建ing")
            return Just(90)
        }
        debugPrint("创建完成")
        
        debugPrint("订阅")
        let cancelable = deferred
            .print("Deferred ->")
            .sink { v in
            debugPrint("Deferred completion: \(v)")
        } receiveValue: { v in
            debugPrint("Deferred receiveValue: \(v)")
        }
        
        debugPrint("完成")
        debugPrint("Deferred : \(String(describing: deferred.createPublisher))")
        
        cancelable.store(in: &cancelables)
        
        // 直接订阅 闭包 里的 publiser， 当然这样写就没有意义了
        deferred.createPublisher()
            .sink { v in
                debugPrint("Deferred2 receiveValue: \(v)")
            }
            .store(in: &cancelables)
    }
    
}
