//
//  ZipOperator.swift
//  CombineTest
//
//  Created by 娄汉清 on 2021/10/3.
//

import Foundation
import Combine

struct ZipOperator {
    
    static func loadOperator() {
        
        // 用法同 RxSwift中的 Zip
        // 多个publisher合并为一个publisher,且每一个Publisher必须都要发生元素才会被相应
        zipTest()
        
        zip2Test()
    }
    
    static func zipTest() {
        
        let publisher1 = PassthroughSubject<Int, Error>()
        let publisher2 = PassthroughSubject<Int, Error>()
        
        let cancelAble = publisher1.zip(publisher2)
            .print()
            .sink { v in
                
            } receiveValue: { v in
                
            }
        
        publisher1.send(1)
        publisher1.send(2)
        publisher2.send(4)
        publisher1.send(3)
        publisher2.send(9)

        cancelAble.cancel()
    }
    
    static func zip2Test() {
        
        let publisher1 = PassthroughSubject<Int, Error>()
        let publisher2 = PassthroughSubject<Int, Error>()
//        publisher1.mer
        let cancelAble = publisher1.zip(publisher2, { v, v2 in
            v * v2
        })
            .print()
            .sink { v in
                
            } receiveValue: { v in
                
            }
        
        publisher1.send(1)
        publisher1.send(2)
        publisher2.send(4)
        publisher1.send(3)
        publisher2.send(9)

        cancelAble.cancel()
    }
}
