//
//  ViewController.swift
//  Swift_Async
//
//  Created by 9527 on 2022/5/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("kai")
        let firstNumber = await baseAsyncFunc()
        
    }


}


func asyncFuncTest(sel: Selector)  {
    
}
