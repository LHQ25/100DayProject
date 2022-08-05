//
//  SubscriberTest.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct SubscriberTest {
    
    static func loadTest() {
        
        assignTest()
    }
    
    static var cancellable: AnyCancellable?
    static func assignTest() {
        
        
        // 类似于RxSwift中的bind
        var temp = SubscriberTest.AssignData()
        let pub2 = PassthroughSubject<Int, Never>()
        cancellable = pub2
            .print()
            .assign(to: \.age, on: temp)
        
        pub2.send(90)
    }
    
    class AssignData: NSObject {
        
        var name: String = ""
        var age: Int = 0
    }
}
