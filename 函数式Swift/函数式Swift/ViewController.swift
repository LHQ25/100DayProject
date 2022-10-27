//
//  ViewController.swift
//  函数式Swift
//
//  Created by 9527 on 2022/8/8.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView.image = test()
        
    }


}

