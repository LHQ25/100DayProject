//
//  ViewController.swift
//  Day9_Protocol
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //协议的定义
        //参考 ProtocolBase.swift
        
        
        //调用  作为类型使用的协议
        let randomNum = BoomTest.init(des: "💥", random: RandomNumberSmallGenerator())
        for _ in 0...2 {
            let result = randomNum.toRandom()
            print(result)
        }
        
        //MARK: - 协议类型的集合： 协议作为集合的元素类型举例：
        let protocolArray : [RandomNumberProtocol] = [RandomNumberSmallGenerator(),RandomNumberBigGenerator()]
//        for item in protocolArray {
//            let num = item.random()
//            print(num) //!< 1 17
//        }
        for item in protocolArray {
            let num = item.random()
            if let smallGenerator = item as? RandomNumberSmallGenerator {
                print(smallGenerator.name) //log:遵守协议的属性
            }
            print(num) //!< 1 17
        }
        
        //调用 有条件地遵守协议
        let num1 = RandomNumberSmallGenerator()
        let num2 = RandomNumberSmallGenerator()
        let protocolArray2 = [num1,num2]
        print("\(protocolArray2.random())")//!< 732
        
        //调用  协议组合
        let cat = Kid.hasCat(pet: Cat.init())//!< 恭喜你获得了宠物猫:小黄 颜色：黑色 特点：撒娇
        print(cat)
        let dog = Kid.hasDog(pet: Husky.init("哈怂奇", "火红", "家中地雷"))//!< 恭喜你获得了宠物狗:阿里克 颜色：火红 特点：家中地雷
        print(dog)
        
        // 检查类型实例是否遵守特定协议
        let objects: [AnyObject] = [
            Circle(radius: 2.0),
            Country(area: 243_610),
            Husky.init("哈士奇", "火红", "家中地雷")
        ]
        for object in objects {
            if let objectWithArea = object as? HasArea {
                print("Area is \(objectWithArea.area)")
            } else {
                print("Something that doesn't have an area")
            }
        }
        
        //可选协议要求
        let counter = Counter()
        counter.dataSource = ThreeSource()
        for _ in 1...4 {
            counter.increment()
            print(counter.count) // 3 6 9 12
        }
    }


}

