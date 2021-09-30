//
//  ViewController.swift
//  CombineTest
//
//  Created by cbkj on 2021/9/30.
//

import UIKit
import Combine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: - Publisher
        // BasePublishersTest.loadTest()
        
        // MARK: - Operator
        MapOperator.loadMapOperator()
        
        FilterOperator.loadOperator()
        
        ReduceOperator.loadOperator()
    }

}

