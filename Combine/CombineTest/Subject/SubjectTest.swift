//
//  SubjectTest.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct SubjectTest {
    
    static func loadTest() {
        
        
        // RxSwift -> BehavSubject, RelaySubject
        let subject = CurrentValueSubject<Int, SampleError>(2)
        
        // RxSwift -> PublicSubject, publicRelay
        let subject2 = PassthroughSubject<Int, SampleError>()
        
    }
    
    
    
}
