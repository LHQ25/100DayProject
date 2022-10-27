//
//  HQSubscribers.swift
//  CombineTest
//
//  Created by 9527 on 2022/9/21.
//

import Foundation
import Combine

class HQSubscribersTest: BaseTest {
    
    func test() {
        let subject = PassthroughSubject<Int, Never>()
        
        subject.subscribe(Subscribers.MYSubscriber())
        
        subject.sink { v in
            debugPrint("HQSubscriberTest -> \(v)")
        } receiveValue: { v in
            debugPrint("HQSubscriberTest -> \(v)")
        }
        .store(in: &cancelables)
        
        subject.send(12)
        subject.send(13)
        subject.send(14)
        
        subject.send(completion: .finished)
    }
}

extension Subscribers {
    
    
    class MYSubscriber<I, O: Error>: Subscriber, Cancellable {
        
        func cancel() {
            debugPrint("MYSubscriber -> cancel")
        }
        
        
        typealias Input = I
        typealias Failure = O
        
        private var subscription: Subscription?
        
        // Receiving Elements
        func receive(_ input: I) -> Subscribers.Demand {
            debugPrint("receive -> input \(input)")
            return .none
        }
        
        // when Input is ().
        // func receive() -> Subscribers.Demand {}
        
        // Receiving Life Cycle Events
        func receive(subscription: Subscription) {
            
            debugPrint("receive -> subscription")
            
            self.subscription = subscription
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                self.subscription?.request(.max(2))
            }
        }
        
        func receive(completion: Subscribers.Completion<O>) {
            
            debugPrint("receive -> completion")
            
            switch completion {
            case .finished:
                debugPrint("receive -> completion: finished")
            case .failure(let failure):
                debugPrint("receive -> completion: failure \(failure)")
            }
        }
        
        var combineIdentifier: CombineIdentifier {
            CombineIdentifier()
        }
    }
}
