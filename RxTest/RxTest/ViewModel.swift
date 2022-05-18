//
//  ViewModel.swift
//  RxTest
//
//  Created by 娄汉清 on 2022/5/15.
//

import Foundation

class ViewModel: NSObject {
    
    @PublishRelay
    var name: String = "old name"
    
    @BehaviorRelay
    var age = 10
    
    @ReplaySubject(wrappedValue: "足球", bufferSize: 2)
    var hobby: String
    
    deinit {
        
        print("ViewModel ---  deinit")
    }
    
}
