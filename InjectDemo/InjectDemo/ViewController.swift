//
//  ViewController.swift
//  InjectDemo
//
//  Created by 9527 on 2022/7/6.
//

import UIKit
import Inject
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // CORRECT
        let viewController = Inject.ViewControllerHost(MyController())
        present(viewController, animated: true)
    }
}

