//
//  HQAnyCancellable.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/22.
//

import Foundation
import Combine

class HQAnyCancellable: BaseTest {
    
    func test() {
        print(12333)
        
        var anyCancellable = AnyCancellable {
            
        }
        
        let pass = PassthroughSubject<Int, Never>()
        
        pass.send(13)
        
        pass.sink { v in
            debugPrint("AnyPublisher completion: \(v)")
        } receiveValue: { v in
            debugPrint("AnyPublisher receiveValue: \(v)")
        }
        .store(in: &cancelables)  // 存储到指定的集合中
        //.cancel()  // 直接结束. 接受不到数据
        
        //
        pass.send(23)
        pass.send(completion: .finished)
        
    }
}
