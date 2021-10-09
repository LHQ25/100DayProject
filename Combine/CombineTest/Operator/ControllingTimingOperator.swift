//
//  ControllingTimingOperator.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct ControllingTimingOperator {
    
    static func loadOperatorTest() {
        
        
        measureIntervalTest()
        debounceTest()
        
        delayTest()
        throttleTest()
        timeoutTest()
    }
    static var cancellable: AnyCancellable?
    static var cancellable1: AnyCancellable?
    static var cancellable2: AnyCancellable?
    static var cancellable3: AnyCancellable?
    static var cancellable4: AnyCancellable?
    
    static func measureIntervalTest() {
        
        // 测量并发出从上游Publisher接收到的事件之间的时间间隔。
        
        let pub = CurrentValueSubject<Int, Never>(2)
        
        pub.send(21)
        pub.send(22)
        pub.send(23)
        
        cancellable = pub.measureInterval(using: RunLoop.main)
            .print().sink {
                print($0)
            }
    }
    
    static func debounceTest() {
        
        print("----- \("debounce") -----")
        defer { print("") }
        
        // 仅在事件之间经过指定的时间间隔后发布元素。
        let bounces:[(Int,TimeInterval)] = [
            (0, 0),
            (1, 0.25),  // 0.25s interval since last index
            (2, 1),     // 0.75s interval since last index
            (3, 1.25),  // 0.25s interval since last index
            (4, 1.5),   // 0.25s interval since last index
            (5, 2)      // 0.5s interval since last index
        ]

        let subject = PassthroughSubject<Int, Never>()
        cancellable1 = subject
            .debounce(for: RunLoop.SchedulerTimeType.Stride.seconds(0.5), scheduler: RunLoop.main)
            .sink { index in
                print ("Received index \(index)")
            }
        
        for bounce in bounces {
            DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
                subject.send(bounce.0)
            }
        }
    }
    
    static func delayTest() {
        
        print("----- \("delayTest") -----")
        defer { print("") }
        
        // 所有输出延迟发送
        let bounces:[(Int,TimeInterval)] = [
            (01, 0),
            (11, 0.25),  // 0.25s interval since last index
            (21, 1),     // 0.75s interval since last index
            (31, 1.25),  // 0.25s interval since last index
            (41, 1.5),   // 0.25s interval since last index
            (51, 2)      // 0.5s interval since last index
        ]

        let subject = PassthroughSubject<Int, Never>()
        cancellable2 = subject
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { index in
                print ("Received index \(index)")
            }
        
        for bounce in bounces {
            DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
                subject.send(bounce.0)
            }
        }
    }
    
    static func throttleTest() {
        
        print("----- \("throttle") -----")
        defer { print("") }
        
        // 指定间隔时间内不会重复发送数据
        let bounces:[(Int,TimeInterval)] = [
            (02, 0),
            (12, 0.25),  // 0.25s interval since last index
            (22, 1),     // 0.75s interval since last index
            (32, 1.25),  // 0.25s interval since last index
            (42, 1.5),   // 0.25s interval since last index
            (52, 2)      // 0.5s interval since last index
        ]

        let subject = PassthroughSubject<Int, Never>()
        cancellable3 = subject
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .sink { index in
                print ("Received index \(index)")
            }
        
        for bounce in bounces {
            DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
                subject.send(bounce.0)
            }
        }
    }
    
    static func timeoutTest() {
        
        print("----- \("timeout") -----")
        defer { print("") }
        
        // 如果上游Publisher超过指定的时间间隔而不生成元素，则终止发布。
        let bounces:[(Int,TimeInterval)] = [
            (03, 0),
            (13, 0.25),  // 0.25s interval since last index
            (23, 1),     // 0.75s interval since last index
            (33, 1.25),  // 0.25s interval since last index
            (43, 1.5),   // 0.25s interval since last index
            (53, 2)      // 0.5s interval since last index
        ]

        let subject = PassthroughSubject<Int, Never>()
        cancellable4 = subject
            .timeout(.seconds(0.5), scheduler: RunLoop.main, options: nil, customError: nil)
            .sink { index in
                print ("Received index \(index)")
            }
        
        for bounce in bounces {
            DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
                subject.send(bounce.0)
            }
        }
    }
}
