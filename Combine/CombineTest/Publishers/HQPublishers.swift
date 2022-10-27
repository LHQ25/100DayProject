//
//  HQPublishers.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/22.
//

import Foundation
import Combine
import SwiftUI

class HQPublisher: BaseTest {

    //MARK: - Convenience Publishers
    /// 指定的序列 Rx: from
    func sequenceTest() {

        let sequence = Publishers.Sequence<[Int], SampleError>(sequence: [1, 2, 3])

        sequence.print("Publishers.Sequence -> ").sink(receiveCompletion: { (completion) in
            debugPrint("Publishers.Sequence completion: \(completion)")
        }, receiveValue: { (v) in
            debugPrint("Publishers.Sequence receiveValue \(v)")
        }).store(in: &cancelables)

        debugPrint("sequence.sequence ->", sequence.sequence)

        // or
        // 系统 添加的扩展
        let sequence2 = [4, 5, 6].publisher
        sequence2.print("Publishers.Sequence2 -> ").sink(receiveCompletion: { (completion) in
                    debugPrint("Publishers.Sequence2 completion: \(completion)")
                }, receiveValue: { (v) in
                    debugPrint("Publishers.Sequence2 receiveValue \(v)")
                }).store(in: &cancelables)
    }

    // 捕获错误然后 替换构造成 新的 publisher
    func catchTest() {

        let failed = Fail<Int, SampleError>(error: .sampleError)

        let `catch` = Publishers.Catch(upstream: failed) { (v) in
            Just(10)
        }

        failed
            .print("failed.Catch -> ")
            .sink { v in
                debugPrint("failed.Catch completion: \(v)")
            } receiveValue: { v in
                debugPrint("failed.Catch receiveValue: \(v)")
            }
            .store(in: &cancelables)
        
        debugPrint("----------------------------")
        
        `catch`.print("Publishers.Catch -> ")
            .sink { v in
                debugPrint("Publishers.Catch completion: \(v)")
            } receiveValue: { v in
                debugPrint("Publishers.Catch receiveValue: \(v)")
            }
            .store(in: &cancelables)

    }
    
    // MARK: - Working with Subscribers
    func receiveOnTest() {
        
        let pass = PassthroughSubject<Int, SampleError>()
        
        let scheduler = ImmediateScheduler.shared
//        scheduler.schedule(after: .Stride(2), interval: .seconds(2), tolerance: .seconds(2), options: nil) {
//            debugPrint("schedule after")
//        }
        let type = scheduler.now.advanced(by: .seconds(3))
        
        scheduler.schedule(after: type, tolerance: .seconds(3)) {
            debugPrint("schedule after")
        }
        let receive = Publishers.ReceiveOn(upstream: pass, scheduler: scheduler, options: nil)
        
        receive.sink { v in
            debugPrint("Publishers.ReceiveOn completion: \(v)")
        } receiveValue: { v in
            debugPrint("Publishers.ReceiveOn receiveValue: \(v)")
        }
        .store(in: &cancelables)
        
        pass.sink { v in
            debugPrint("PassthroughSubject completion: \(v)")
        } receiveValue: { v in
            debugPrint("PassthroughSubject receiveValue: \(v)")
        }.store(in: &cancelables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            pass.send(23)
            pass.send(completion: .finished)
        }

    }
    
    func subscribeOnTest() {
        
        let pass = PassthroughSubject<Int, SampleError>()
        
        let scheduler = ImmediateScheduler.shared
//        scheduler.schedule(after: .Stride(2), interval: .seconds(2), tolerance: .seconds(2), options: nil) {
//            debugPrint("schedule after")
//        }
        let type = scheduler.now.advanced(by: .seconds(3))
        
        scheduler.schedule(after: type, tolerance: .seconds(3)) {
            debugPrint("schedule after")
        }
        let receive = Publishers.SubscribeOn(upstream: pass, scheduler: scheduler, options: nil)
        
        receive.sink { v in
            debugPrint("Publishers.ReceiveOn completion: \(v)")
        } receiveValue: { v in
            debugPrint("Publishers.ReceiveOn receiveValue: \(v)")
        }
        .store(in: &cancelables)
        
        pass.sink { v in
            debugPrint("PassthroughSubject completion: \(v)")
        } receiveValue: { v in
            debugPrint("PassthroughSubject receiveValue: \(v)")
        }.store(in: &cancelables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            pass.send(23)
            pass.send(completion: .finished)
        }

    }
    


}

