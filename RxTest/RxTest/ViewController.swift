//
//  ViewController.swift
//  RxTest
//
//  Created by 娄汉清 on 2022/5/15.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    
    var vm: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm = ViewModel()
        
        vm?.$name.subscribe(onNext: { name in
            print("name:", name)
        }).disposed(by: bag)

        vm?.$age.subscribe(onNext: { age in
            print("age:", age)
        }).disposed(by: bag)

        vm?.name = "new name"

        vm?.age = 13
        vm?.age = 90
        
        vm?.$hobby.subscribe(onNext: { hobby in
            
            print("hobby", hobby)
        }).disposed(by: bag)
        
        vm?.hobby = "篮球"
        vm?.hobby = "羽毛球"
        vm?.hobby = "排球"
        vm?.hobby = "乒乓球"
        
        vm?.$hobby.subscribe(onNext: { hobby in
            
            print("hobby2", hobby)
        }).disposed(by: bag)
        
        // 释放
        vm = nil
    }


}

