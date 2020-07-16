//
//  ViewController.swift
//  Day8_泛型
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //泛型函数
        var a = "Qishare"
        var b = "Come On"
        swapTwoValues(&a, &b)
        print("泛型函数：",a,b)
        
        //泛型类型
        var stack_int = Stack<Int>()
        stack_int.push(7)
        stack_int.push(3)
        stack_int.push(2)
        print(stack_int)
        
        stack_int.pop(3)
        print(stack_int)
        
        var stack_string = Stack<String>()
        stack_string.push("QISHARE")
        print(stack_string)
        
        //泛型类型的扩展
        var stack_string2 = Stack<String>()
        stack_string2.push("QISHARE")
        stack_string2.push("QISHARE22")
        if let topItem = stack_string2.topItem {
           print(topItem)//!< QISHARE
        }
        
        //关联类型
        var intStack = IntStack()
        intStack.push(23)
        intStack.push(11)
        print("关联类型：",intStack)
        print("关联类型2：",intStack.count)
        print("关联类型3：",intStack[0])
        intStack.pop(11)
        print("关联类型4：",intStack)
        
        //泛型协议
        var genericStack = ContainerStack<String>()
        genericStack.push("hellow")
        genericStack.push("world")
        genericStack.push("swift")
        print("泛型协议：",genericStack)
        print("泛型协议2：",genericStack.count)
        print("泛型协议3：",genericStack[0])
        genericStack.pop("world")
        print("泛型协议4：",genericStack)
        
        //扩展现有类型以指定关联类型
        let array2 = [13,425,678]
        array2.associateTypeTwo(23) // 自动推断出Container协议中的关联对象 Item 是 Int 类型
        
        
        //使用is或as判断某个类型是否遵守特定协议
        let array : [Any] = [1,"ddd",3]
//        if array is Container {
//         /*报错:Protocol 'Container' can only be used as a generic
//        constraint because it has Self or associated type requirements*/
//            print("遵守此协议")
//        } else {
//            print("不遵守此协议")
//        }
        if array is Int_Container {
            print("遵守此协议")
        } else {
            print("不遵守此协议")
        }
        /**
         带有关联类型的协议，不管是作为函数的参数类型或对象的属性类型，还是单独判断某个类型是否遵守此协议，
         都会报错：Protocol 'Container' can only be used as a generic constraint because it has Self or associated type requirements。编译器告诉我们Container协议有Self或关联类型的要求，因此它只能被用来作为泛型的约束。
         关于Self的提示：系统库为协议提供了Self关联类型，默认指向了实现此协议的类型。
         
         泛型：使用占位符类型完成泛型类型方法的实现，泛型的实际类型由使用此泛型类型者指定。即：使用时指定实际类型。
         关联类型：使用占位符类型完成协议方法的定义，关联类型的实际类型由实现此协议者指定，即：实现时指定实际类型
         */
        
        //关联类型的协议用作泛型的约束
        let t = TempStruct<IntStack>()
//        let t = TempStruct<ContainerStack<String>>()
        t.showYourMagic(intStack)
        showYourMagic("展示魔法")
        //带有关联类型的协议只能用作泛型的约束。
        
        
        
        //关联类型的约束中使用协议
        var stack_t = IntStack()
        stack_t.push(7)
        stack_t.push(3)
        stack_t.push(2)
        stack_t.append(4)
        let suffix_int = stack_t.suffix(3)
        print(stack_t,suffix_int)//3 2 4
        
        //关联类型使用泛型 where闭包
        var stack_int3 = Stack2<Int>()
        stack_int3.push(7)
        stack_int3.push(3)
        stack_int3.push(2)
        stack_int3.append(4)
        for item in stack_int3 {
            print(item)
        }
        //泛型下标
        let v = stack_int3[1]
        print("泛型下标：",v)
    }

    //MARK:-  泛型函数
    func swapTwoValues<T>(_ a: inout T, _  b: inout T) {
        let temp = a
        a = b
        b = temp
    }
    
    

}


