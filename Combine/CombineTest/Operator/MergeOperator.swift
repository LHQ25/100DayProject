//
//  MergeOperator.swift
//  CombineTest
//
//  Created by 娄汉清 on 2021/10/3.
//

import Foundation
import Combine

struct MergeOperator {
    
    static func loadOperator() {
        
        // 用法同 RxSwift中的 combineLatest
        // 两个publisher合并为一个publisher,每一个发生元素是都会被相应
        mergeTest()
    }
    
    static func mergeTest() {
        
        let publisher1 = PassthroughSubject<Int, Error>()
        let publisher2 = PassthroughSubject<Int, Error>()
        
        let cancelAble = publisher1.merge(with: publisher2)
            .print()
            .sink { v in
                
            } receiveValue: { v in
                
            }
        
        publisher1.send(1)
        publisher1.send(2)
        publisher2.send(4)
        publisher1.send(3)

        cancelAble.cancel()
    }
    
    static func merge2Test() {
        
        let publisher1 = PassthroughSubject<Int, Error>()
        let publisher2 = PassthroughSubject<Int, Error>()
//        publisher1.mer
        let cancelAble = publisher1.merge(with: publisher2)
            .print()
            .sink { v in
                
            } receiveValue: { v in
                
            }
        
        publisher1.send(1)
        publisher1.send(2)
        publisher2.send(4)
        publisher1.send(3)

        cancelAble.cancel()
    }
}
