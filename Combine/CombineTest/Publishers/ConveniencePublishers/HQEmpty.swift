//
//  HQEmpty.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class BaseTest {
    
    var cancelables = [AnyCancellable]()
    
}

class HQEmpty: BaseTest {
    
    // MARK: - Empty  Rx: Empty
    func emptyTest() {
        
        // completeImmediately: 是否立即完成, false 时，永远不会执行
        let empty = Empty<Int, Never>(completeImmediately: true)
        empty.sink { _ in
            debugPrint("Empty completion")
        } receiveValue: { value in
            debugPrint("receiveValue", value)
        }
        .store(in: &cancelables)
        
        // 显示声明类型。
        let empty2 = Empty(outputType: Int.self, failureType: Never.self)
        let cancel2 = empty2.sink { _ in
            debugPrint("Empty2 completion")
        } receiveValue: { value in
            debugPrint("receiveValue2", value)
        }
        
        print("是否立即完成： \(empty2.completeImmediately)")
        
        cancel2.store(in: &cancelables)
    }
}
