//
//  CombineLastOPerator.swift
//  CombineTest
//
//  Created by 娄汉清 on 2021/10/3.
//

import Foundation
import Combine

struct CombineLastOperator {
    
    
    static func loadOperators() {
        
        
        // 用法同 RxSwift中的 combineLatest
        combineLatestTest()
        
        // 用法同 RxSwift中的 combineLatest, transform中可以对值进行操作,返回一个新的值
        // 包含多个publisher是使用方法是相同的
        combineLatest2Test()
    }
    
    static func combineLatestTest(){
     
        print("----- \("combineLatest") -----")
        defer { print("") }
        
        let publisher1 = PassthroughSubject<Int, Error>()
        let publisher2 = PassthroughSubject<Int, Error>()
        
        let combineLatest = publisher1.combineLatest(publisher2)
            .print()
            .sink { res in
                
            } receiveValue: { v in
                
            }
        
        publisher1.send(1)
        publisher1.send(2)
        publisher2.send(4)
        publisher1.send(3)
        
        combineLatest.cancel()
        
    }
    
    static func combineLatest2Test(){
     
        print("----- \("combineLatest") -----")
        defer { print("") }
        
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<Int, Never>()
        
        let combineLatest = publisher1.combineLatest(publisher2) { v1, v2 in
            v1 * v2
        }.print()
        .sink { v in
            
        }
        
        publisher1.send(1)
        publisher1.send(2)
        publisher2.send(4)
        publisher1.send(3)
        
        combineLatest.cancel()
        
    }
    
}
