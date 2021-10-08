//
//  WorkingwithMultipleSubscribersOperators.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct WorkingwithMultipleSubscribersOperators {
    
    static func loadOperatorsTest() {
        
        multicastTest()
        
        shareTest()
    }
    
    static var cancellable1: AnyCancellable?
    static var cancellable2: AnyCancellable?
    
    static func multicastTest() {
        
        /*
         当有多个下游Subscribers时使用多播发布者，上游Publisher者每个事件只处理一个 receive(_:) 调用。 当上游Publisher无需执行额外工作，例如执行网络请求。
         与multicast(subject:) 不同，这个方法产生一个发布者，为每个订阅者创建一个单独的Subject。
         以下示例使用序列发布者作为计数器来发布由 map(_:) 运算符生成的三个随机数。 它使用一个多播(_:) 操作符，
         它的闭包创建一个 PassthroughSubject 来向两个订阅者中的每一个共享相同的随机数。
         因为多播发布者是一个 ConnectablePublisher，所以发布只在调用 connect() 之后开始。
         */
        let pub = ["First", "Second", "Third"].publisher
            .map( { return ($0, Int.random(in: 0...100)) } )
            .print("Random")
//            .multicast { PassthroughSubject<(String, Int), Never>() }   // 同下
            .multicast(subject: PassthroughSubject<(String, Int), Never>())

        cancellable1 = pub
           .sink { print ("订阅 1 received: \($0)")}
        cancellable2 = pub
           .sink { print ("订阅 2 received: \($0)")}
        
        pub.connect()
    }
    
    static var cancellable3: AnyCancellable?
    static var cancellable4: AnyCancellable?
    static func shareTest() {
        
        /*
         与多个订阅者共享上游Publisher的输出。同R小Swift的share
         */
        let pub = (1...3).publisher
            .delay(for: 1, scheduler: DispatchQueue.main)
            .map( { _ in return Int.random(in: 0...100) } )
            .print("Random")
            .share()

        cancellable3 = pub
            .sink { print ("Stream 1 received: \($0)")}
        cancellable4 = pub
            .sink { print ("Stream 2 received: \($0)")}
    }
}
