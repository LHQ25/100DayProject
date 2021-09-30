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
        let scheduler = ImmediateScheduler.shared
        let stride = ImmediateScheduler.SchedulerTimeType.Stride.seconds(1)
        let strategy = Publishers.TimeGroupingStrategy.byTime(scheduler, stride)
        check("collect - stragety") {
//            a.collect(strategy, options: nil)
            a.collect(strategy)
        }
    }
}
