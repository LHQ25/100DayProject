//
//  com.swift
//  RxTest
//
//  Created by 娄汉清 on 2022/5/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import Metal

//MARK: - Relay
@propertyWrapper
struct BehaviorRelay<Element> {
    
    private var relay: RxRelay.BehaviorRelay<Element>?
    private var value: Element!
    
    var wrappedValue: Element {
        get {
            return value
        }
        set {
            value = newValue
            if relay == nil {
                relay = RxRelay.BehaviorRelay(value: newValue)
            }
            relay!.accept(newValue)
        }
    }
    
    var projectedValue: Observable<Element> {
        return relay!.asObservable()
    }
    
    init(wrappedValue: Element) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
struct PublishRelay<Element> {
    
    private let relay = RxRelay.PublishRelay<Element>()
    private var value: Element!
    
    var wrappedValue: Element {
        get {
            return value
        }
        set {
            value = newValue
            relay.accept(newValue)
        }
    }
    
    var projectedValue: Observable<Element> {
        return relay.asObservable()
    }
    
    init(wrappedValue: Element) {
        self.wrappedValue = wrappedValue
    }
}

//MARK: - Subject
@propertyWrapper
struct ReplaySubject<Element> {
    
    private var subject: RxSwift.ReplaySubject<Element>!
    
    private var bufferSize: Int = 1
    private var value: Element!
    
    var wrappedValue: Element {
        get {
            return value
        }
        set {
            value = newValue
            subject.onNext(newValue)
        }
    }
    
    var projectedValue: Observable<Element> {
        return subject.asObservable()
    }
    
    init(wrappedValue: Element, bufferSize: Int = 1) {
        subject = RxSwift.ReplaySubject.create(bufferSize: bufferSize)
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
struct BehaviorSubject<Element> {
    
    private var subject: RxSwift.BehaviorSubject<Element>?
    private var value: Element!
    
    var wrappedValue: Element {
        get {
            return value
        }
        set {
            value = newValue
            if subject == nil {
                subject = RxSwift.BehaviorSubject(value: wrappedValue)
            }
            subject!.onNext(newValue)
        }
    }
    
    var projectedValue: Observable<Element> {
        return subject!.asObservable()
    }
    
    init(wrappedValue: Element) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
struct PublishSubject<Element> {
    
    private var subject = RxSwift.PublishSubject<Element>()
    private var value: Element!
    
    var wrappedValue: Element {
        get {
            return value
        }
        set {
            value = newValue
            subject.onNext(newValue)
        }
    }
    
    var projectedValue: Observable<Element> {
        return subject.asObservable()
    }
    
    init(wrappedValue: Element) {
        self.wrappedValue = wrappedValue
    }
}


//@propertyWrapper
//struct ControlProperty<Element> {
//
//    private var subject = RxCocoa.ControlProperty(values: <#T##ObservableType#>, valueSink: <#T##ObserverType#>)
//    private var value: Element!
//
//    var wrappedValue: Element {
//        get {
//            return value
//        }
//        set {
//            value = newValue
//            subject.onNext(newValue)
//        }
//    }
//
//    var projectedValue: Observable<Element> {
//        return subject.asObservable()
//    }
//
//    init(wrappedValue: Element) {
//        self.wrappedValue = wrappedValue
//    }
//}

extension Reactive where Base: UIView {
    
    
    var aa: ControlProperty<Bool> {
        
        let source: Observable<Bool> = Observable.deferred { [weak view = self.base] in
            let isHidden = view?.isHidden
            
            let observer = Observable<Bool>.create { observer in
                
                observer.onNext(isHidden ?? false)
                return Disposables.create()
            }.observe(on:MainScheduler.asyncInstance)
            return observer
        }

        let bindingObserver = Binder(self.base) { (view, isHidden: Bool) in
            
            if view.isHidden != isHidden {
                view.isHidden = isHidden
            }
        }
        
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
