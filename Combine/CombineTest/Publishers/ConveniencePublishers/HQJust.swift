//
//  HQJust.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQJust: BaseTest {
    
    // MARK: - Just
    func test() {
        
        // 只发出一个元素   Rx: Just
        let just = Just(7)
        just
            .print("Just -> ")
            .sink { _ in
            debugPrint("Just completion")
        } receiveValue: { value in
            debugPrint("receiveValue", value)
        }
        .store(in: &cancelables)
        
        print("output： \(just.output)")
    }
}
