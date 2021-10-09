//
//  DebugTest.swift
//  CombineTest
//
//  Created by cbkj on 2021/10/8.
//

import Foundation
import Combine

struct DebugTest {
    
    static func loadTest() {
        
//        breakpointTest()
        
//        breakpointOnErrorTest()
        
        handleEventsTest()
    }
    
    static var cancellable: AnyCancellable?
    
    static func breakpointTest() {
        
        let publisher = PassthroughSubject<String?, Never>()
        cancellable = publisher
            .breakpoint(
                receiveOutput: { value in return value == "DEBUGGER" }
            )
            .sink { print("\(String(describing: $0))" , terminator: " ") }

        publisher.send("DEBUGGER")
    }
    
    static func breakpointOnErrorTest() {
        
        struct CustomError : Error {}
        
        
        let publisher = PassthroughSubject<String?, Error>()
        cancellable = publisher
            .tryMap { stringValue in
                throw CustomError()
            }
            .breakpointOnError()
            .sink(
                receiveCompletion: { completion in print("Completion: \(String(describing: completion))") },
                receiveValue: { aValue in print("Result: \(String(describing: aValue))") }
            )

        publisher.send("TEST DATA")
    }
    
    static func handleEventsTest() {
        
//        let integers = (0...2)
//        cancellable = integers.publisher
//            .handleEvents(receiveSubscription: { subs in
//                print("Subscription: \(subs.combineIdentifier)")
//            }, receiveOutput: { anInt in
//                print("in output handler, received \(anInt)")
//            }, receiveCompletion: { _ in
//                print("in completion handler")
//            }, receiveCancel: {
//                print("received cancel")
//            }, receiveRequest: { (demand) in
//                print("received demand: \(demand.description)")
//            })
//            .sink { _ in return }
        
        let integers = (0...2)
        cancellable = integers.publisher
            .handleEvents(receiveSubscription: { subs in
                print("Subscription: \(subs.combineIdentifier)")
            }, receiveOutput: { anInt in
                print("in output handler, received \(anInt)")
            }, receiveCompletion: { _ in
                print("in completion handler")
            }, receiveCancel: {
                print("received cancel")
            }, receiveRequest: { (demand) in
                print("received demand: \(demand.description)")
            })
            .sink { _ in return }
    }
}
