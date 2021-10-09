//
//  ProtocolBase.swift
//  Day9_Protocol
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation

//MARK: - 定义 和  生命协议
//为类，结构体，枚举定义协议的语法
protocol FirstProtocol {
   //定义协议
}
protocol AnotherProtocol {
   //定义协议
}

//复制代码自定义类型遵守协议的语法
//协议名称放在类型名称之后，并用冒号分隔，多个协议时，协议之间使用逗号。当类类型有父类时则父类类型名称放在协议之前并用逗号隔开。

//值类型
struct SomeStructure: FirstProtocol, AnotherProtocol {
    // 结构体定义
}

//类类型
class SomeClass: NSObject, FirstProtocol, AnotherProtocol {
    // class定义
}

//MARK: - 协议中的 属性
/**
 协议中定义属性的要求
 协议可以要求任何遵守此协议的类型提供一个具有特定类型和名称的实例属性或类属性。但是协议不能指定属性应该是一个存储属性还是一个计算属性。因此协议中定义的属性只能要求属性的名称与类型，并且指定属性是可get或支持get与set的。
 如果协议要求一个属性是可get与set的，那么协议对这个属性的要求是不能被常量存储属性或者只读的计算属性满足的。
 如果协议仅要求一个属性是可get的，那么这个要求可以被任何类型的属性满足，同时如果有必要，这个属性也是可set的
 */

//属性要求： 协议中定义属性必须始终声明为变量属性，并以var关键字为前缀。通过在类型声明后写{ get set }来表示属性可读写，通过写{get}来表示可读的属性
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
//协议中定义类属性时，必须始终在前面使用static关键字。即使该协议的类属性在被类实现时，以class或static为前缀都是符合协议的
protocol ClassProtocol {
    //定义协议
    static var something : String { get}
}
class ObjcClass: NSObject, ClassProtocol, SomeProtocol {
    class var something: String {//使用static也可
        get{
            return "协议中定义的类属性"
        }
    }
    
    private var _mustBeSettable: Int?
    var mustBeSettable: Int {
        get {
            return 111
        }
        set {
            _mustBeSettable = newValue
        }
    }
    
    var doesNotNeedToBeSettable: Int{
        get {
            return 234
        }
    }
}
// 注意： 协议中属性为{get set}使用计算属性时必须get{}和set{}不能为get{}；协议中属性为{get}时则可以使用get{}或者get{}和set{}
