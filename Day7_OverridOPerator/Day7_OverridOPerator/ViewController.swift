//
//  ViewController.swift
//  Day7_OverrideOperation
//
//  Created by 亿存 on 2020/7/15.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //简单的需求  两个Vector2D对象相加
        var v1 = Vector2D(x: 23.0, y: 11.0)
        let v2 = Vector2D(x: 11.0, y: 34)
        let v3 = Vector2D(x: v1.x + v2.x, y: v1.y + v2.y)
        print("第一次相加  ", v3)
        
        //多个重复操作就显得很麻烦了
        let v4 = v1 + v2
        print("第二次相加  ", v4)
        
        //自增操作符
        print("原数据  ", v1)
        ++v1
        print("++自增 操作  ", v1)
        v1++
        print("自增++ 操作  ", v1)
        
        //自定义操作符
        
        let v5 = v1 +* v2
        print("自定义操作符+*：", v5)
    }
    
    
}

