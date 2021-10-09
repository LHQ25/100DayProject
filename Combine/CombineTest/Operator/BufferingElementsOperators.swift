//
//  BufferingElementsOperators.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct BufferingElementsOperators {
    
    static func loadOperatorsTest(){
        
        bufferTest()
        
        makeConnectableTest()
    }
    
    static func bufferTest() {
        
        // 从上游发布者接收的缓冲区元素
        check("buffer") {
            [1,2,3,4,5,6].publisher
                .map({ _ in Int.random(in: 20...120) })
                .buffer(size: 2, prefetch: .byRequest, whenFull: .dropOldest)
            //                              填充缓冲区的策略        一种处理缓冲区容量耗尽的策略
        }
        
    }
    
    static var cancellable: AnyCancellable?
    static var cancellable1: AnyCancellable?
    static var cancellable2: AnyCancellable?
    static var connectable: Cancellable?
    
    static func makeConnectableTest() {
        
        /*
         在以下示例中，makeConnectable() 使用 ConnectablePublisher 包装其上游发布者（Publishers.Share 的实例）。 如果没有这个，第一个接收器订阅者将从序列发布者那里接收所有元素，并在第二个订阅者附加之前使其完成。 通过使发布者可连接，发布者在调用 connect() 之前不会生成任何元素。
         */
        let subject = Just<String>("Sent")
         let pub = subject
             .share()
             .makeConnectable()
         cancellable1 = pub.sink { print ("Stream 1 received: \($0)")  }

         // For example purposes, use DispatchQueue to add a second subscriber
         // a second later, and then connect to the publisher a second after that.
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             self.cancellable2 = pub.sink { print ("Stream 2 received: \($0)") }
         }
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             self.connectable = pub.connect()
         }
    }
    
}
