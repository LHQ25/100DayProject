//
//  ViewController.swift
//  CombineTest
//
//  Created by cbkj on 2021/9/30.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var p: HQPublisher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: - Publisher
//        HQEmpty().emptyTest()
//        HQJust().test()
//        HQDeferred().test()
//        HQFail().test()
//        HQRecord().test()
//        HQFuture().test()

//        HQPublisher().sequenceTest()
//        HQPublisher().catchTest()
//        HQPublisher().receiveOnTest()
//        HQPublisher().subscribeOnTest()
        
//        HQAnyPublisher().test()
        HQAnyCancellable().test()
        
        
        // MARK: - Operator
//        MapOperator.loadMapOperator()
//        
//        FilterOperator.loadOperator()
//        
//        ReduceOperator.loadOperator()
//        
//        MathematicalOperations.loadOperators()
//        
//        MatchingCriteriaOperators.loadOperators()
        
//        SequenceOperations.loadOperators()
        
//        SelectingSpecificOperators.loadOperators()
        
//        CombineLastOperator.loadOperators()
        
//        MergeOperator.loadOperator()
        
//        ZipOperator.loadOperator()
        
//        HandlingErrorsOperator.loadOperatorsTest()
        
//        ControllingTimingOperator.loadOperatorTest()
        
//        EncodingandDecodingOperator.loadTestOperators()
        
//        WorkingwithMultipleSubscribersOperators.loadOperatorsTest()
        
//        BufferingElementsOperators.loadOperatorsTest()
        
        // MARK: -
//        HQSubscriberTest().test()
//        HQSubscribersTest().test()
//        HQAnySubscriber().test()
        
        //MARK: - Subscriber
//        HQPassthroughSubject().test()
//        HQCurrentValueSubject().test()
//        DebugTest.loadTest()
    }

}

