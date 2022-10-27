//
//  HQRecord.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQRecord: BaseTest {
    
    // MARK: -  序列的元素 一个个的发出  Rx : From
    func test() {
        
        // output: 要 发出 的元素
        // completion:
        //      .failure(error): 完成时 发出错误
        //      .finished: 完成
        let record = Record<Int, SampleError>(output: [1, 2, 3], completion: .finished)
        
        let cancelable = record
            .print("Record ->")
            .sink { v in
                debugPrint("Record completion: \(v)")
            } receiveValue: { v in
                debugPrint("Record receiveValue: \(v)")
            }
        debugPrint("Record : \(record.recording)")
        
        cancelable.store(in: &cancelables)

        debugPrint("---------------------------------------------")
        // 自定义 发出元素 和 结束
        let record2 = Record<Int, SampleError> { record in
            
            // 添加一个输出
            record.receive(0)
            // 结束
            record.receive(completion: .finished)
        }
        
        record2
            .print("Record2 ->")
            .sink { v in
                debugPrint("Record2 completion: \(v)")
            } receiveValue: { v in
                debugPrint("Record2 receiveValue: \(v)")
            }
            .store(in: &cancelables)
        
        debugPrint("---------------------------------------------")
        
        // 从 已有 的 Record 创建一个新的
        let record3 = Record<Int, SampleError>(recording: record.recording)
        record3
            .print("Record3 ->")
            .sink { v in
                debugPrint("Record3 completion: \(v)")
            } receiveValue: { v in
                debugPrint("Record3 receiveValue: \(v)")
            }.store(in: &cancelables)
        
    }
    
}
