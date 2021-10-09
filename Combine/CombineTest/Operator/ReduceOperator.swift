//
//  ReduceOperator.swift
//  CombineTest
//
//  Created by cbkj on 2021/9/30.
//

import Foundation
import Combine

struct ReduceOperator {
    
    
    static func loadOperator() {
        
        collectTest()
        ignoreOutputTest()
        reduceTest()
    }
    
    static func collectTest() {
    
        // 收集所有接收到的元素，并在发布者完成时发出该集合的单个数组。
        let a = [2,3,4,2,1,3,5].publisher
        
        check("collect") {
            
            a.collect()
        }
        
        // 收集到指定个数的元素时就发出该集合的单个数组。然后继续收集继续发出
        check("collect - count") {
            
            a.collect(3)
        }
        
        

        
        // 指定时间内收集元素，并在发布者指定时间后发出该集合的单个数组。
//        let scheduler = ImmediateScheduler.shared
//        let stride = ImmediateScheduler.SchedulerTimeType.Stride.seconds(1)
        
        let strategy = Publishers.TimeGroupingStrategy.byTime(RunLoop.main, .seconds(1))
        
        let sub = PassthroughSubject<Int, Error>()
        let s = sub.collect(strategy)
        
        let can = s.print()
            .sink { errorRes in
                switch errorRes {
                case let .failure(error):
                    print("sink", error);
                case .finished:
                    print("finished")
                }
            } receiveValue: { value in
                print(value)
            }
            
        sub.send(1)
        sub.send(2)
        sub.send(1)
        
        can.cancel()
        
        
        check("collect - stragety") {
            a.collect(strategy)
        }
        
        
        
    }
    
    static func ignoreOutputTest() {
        /// 忽略发送的元素
        let a = [2,3,4,2,1,3,5].publisher
        check("ignoreOutput") {
            
            a.ignoreOutput()
        }
    }
    
    static func reduceTest() {
    
        let a = [2,3,4,2,1,3,5].publisher
        check("reduce") {
            
            a.reduce(MyReduceManager()) { manager, vaule in
                manager.doSomething(values: vaule)
            }
        }
        
        //
        check("tryReduce") {
            
            a.tryReduce(MyReduceManager(), { manager, value in
                if value == 3 {
                    throw SampleError.sampleError
                }
                return manager.doSomething(values: value)
            })
        }
    }
}

class MyReduceManager: NSObject {
    
    private var step: Int = 1
    
    var count: Int = 0
    
    func doSomething(values: Int) -> Self{
        count = values + step
        return self
    }
}
