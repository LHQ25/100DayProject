//
//  ViewController.swift
//  CustomNav
//
//  Created by 9527 on 2022/11/5.
//
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()

        debugPrint(UIDevice.current.model)
        debugPrint(UIDevice.current.localizedModel)
        debugPrint(Float(UIDevice.current.systemVersion) ?? 0)

    }

}
