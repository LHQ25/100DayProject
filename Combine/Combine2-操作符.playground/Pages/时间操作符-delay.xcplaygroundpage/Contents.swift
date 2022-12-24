//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    
    print("\n——— Example of:", description, "———")
    action()
}

var subscriptions = Set<AnyCancellable>()

example(of: "delay -> 延迟来自发布者的值，以便你看到它们比它们实际出现的时间晚") {
    
    let pass = PassthroughSubject<Int, Never>()

    pass
        .delay(for: .seconds(2), scheduler: DispatchQueue.main)
        .sink { value in
            print("complete",value)
        } receiveValue: { value in
            print(value)
        }
        .store(in: &subscriptions)

    pass.send(3)
    
    pass.send(completion: .finished)

}
