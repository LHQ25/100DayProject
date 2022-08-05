//
//  ViewController.swift
//  Codable_project
//
//  Created by 9527 on 2022/8/3.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 简单对象
//        let model = Plane.Decodertest()
//        Plane.encodeTest(with: model!)
        // 简单数组类型对象
//        let plans = Plans.Decodertest()
//        Plans.encodeTest(with: plans)
        // 对象包裹数组及错误处理
//        let fleet = Plans_Object.Decodertest()
//        Plans_Object.encodeTest(with: fleet!)
        
        // 日期格式及其它类型解析
        // _ = DateFormatter.Decodertest()
        
        // 动态类型
//        _ = Custom.Decodertest()
        
        UserDefaultsTest.loadData()
        Order.loadOrder()
    }


}

