//
//  Protocol_Method.swift
//  Day9_Protocol
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation

//MARK: - 方法
//协议中方法定义与普通实例和类方法定义方式一样，并且允许可变参数，遵守与常规方法相同的规则
//区别：没有花括号和方法主体；无法为方法参数指定默认值。会要求符合此协议的类型实现协议中规定的实例方法和类方法


//形式：Type...，作用可以接受零个或多个指定类型的值，在函数体内可用作指定类型的数组


//协议中定义类方法时，必须始终在前面使用static关键字。即使该协议的类方法在被类实现时，以class或static为前缀都是符合协议的
protocol MethodProtocol {
    func instanceMethod(para:String) -> String
    static func classMethod(para:String) -> String  //类方法
    func hasVariableParameter(somePara:String...) -> String
}

//实现
class MethodProtocolClass : MethodProtocol {
    
    func hasVariableParameter(somePara: String...) -> String {
        var result : String = ""
        for item in somePara {
            result += item
        }
        return result
    }
    
    func instanceMethod(para: String) -> String {
        para + "实例方法协议实现"
    }
    class func classMethod(para: String) -> String {//!< static也可以
        para + "类方法协议实现"
    }
}

//MARK: - 可变方法要求
//值类型实现协议方法，修改值类型实例本身，则此协议方法需要使用mutating关键字作为前缀。
//若定义协议实例方法，旨在对所有遵守该协议的实例进行修改，需要将此方法标记mutating，以涵盖值类型。注：mutating标记的协议方法，由 类(class) 类型实现时(理由很简单)，无需编写mutating关键字，
//mutating 关键字仅由结构和枚举使用
protocol Togglable {
    mutating func switchOperate()
}

extension Bool : Togglable {
    mutating func switchOperate() {
        self = !self
    }
}

//MARK: - 协议中定义初始化方法的要求
//协议中定义初始化方法也和普通情况下定义初始化方法一样，唯一区别便是没有函数体和花括号。会要求遵守该协议的类型实现此初始化方法
protocol InitProtocol {
    init(someParameter: Int)
}
//MARK: - 类，实现协议中初始化方法的要求
//类，实现协议中初始化方法可谓是签署了魔鬼契约，要求子子孙孙都要履行，可谓之曰霸气侧漏
//回顾：required关键字修饰初始化方法，标记此初始化方法其所有子类必须要实现，子类实现required标记的初始化方法无需写override,但必须写required，指示该初始化方法的延续性
class InitClass: InitProtocol {
   required init(someParameter: Int) {
   }
    //或者实现为便利初始化方法
//   required convenience init(someParameter: Int) {
//       self.init()
//    }
}
/**
 使用required关键字确保了遵守此协议的类类型的所有子类都能提供协议中初始化方法的实现，使其子类都遵守协议。
 注意：使用final标记类类型，实现协议初始化方法时，无需使用required关键字，因为final是阻止子类化的
 
 特殊：若子类重写了父类的指定初始化方法，并且协议中的初始化方法与子类重写的父类的初始化方法一致，则子类实现此协议时，需同时使用required和override修饰符进行标记
 */

class SomeSuperClass {
    init(someParameter: Int) {
    }
}
class InitSubClass: SomeSuperClass, InitProtocol {
    // "required"表示遵守协议; "override" 表示重写
    required override init(someParameter: Int) {
        //初始化方法零参数符合省略super.init()条件
        super.init(someParameter: someParameter)
    }
}


//MARK: - 协议中定义可失败的初始化方法
protocol CanFailProtocol {
    init?(name:String)
}
//协议中定义的可失败的初始化方法，可以被遵守该协议的类型实现为可失败的初始化方法或者不可失败的初始化方法
class FailClass : CanFailProtocol {
    
    //三选一 实现协议 初始化方法
//    required init(name:String) {
//
//    }
    required init?(name: String) {
        if name.isEmpty {return nil}
    }
//    required init!(name: String) {
//
//    }
}


//MARK: - 作为类型使用的协议
/**
 协议本身实际上并未实现任何功能。但是却可以将协议用作完整类型。
 使用协议作为类型有时也称为存在类型，存在类型来自短语“存在类型T，使得T遵守协议”。
 类似OC中的@property (nonatomic, weak) id<protocolName> delegate。
 */

/**
 可以在允许使用其他类型的许多地方使用协议：

 作为函数，方法，初始化方法的参数类型或返回值类型
 作为常量，变量，或属性的类型
 作为数组，字典或其他容器的元素类型
 */
protocol RandomNumberProtocol {
    func random() -> UInt
}
class RandomNumberSmallGenerator: RandomNumberProtocol {
    var name = "遵守协议的属性"
    func random() -> UInt {
        return UInt(arc4random() % 10)
    }
}
class RandomNumberBigGenerator: RandomNumberProtocol {
    func random() -> UInt {
        return UInt(arc4random() % 10) + 10
    }
}
class BoomTest {
    var generator : RandomNumberProtocol //!< 协议作为类型修饰属性
    var description : String
    
    //!< 协议作为类型修饰方法的参数，所有符合实现了 `RandomNumberProtocol`的类型都可以传入
    init(des:String,random:RandomNumberProtocol) {
        generator = random
        print("初始化时调用一下协议方法：\(generator.random())")
        description = des
    }
    //!<如何使用协议中的方法呢？需要单独定义方法
    func toRandom() -> String {
        description + "\(generator.random())"
    }
}

//MARK: - 协议类型的集合： 协议作为集合的元素类型举例：
/**
 let protocolArray : [RandomNumberProtocol] = [RandomNumberSmallGenerator(),RandomNumberBigGenerator()]
 for item in protocolArray {
     let num = item.random()
     print(num) //!< 1 17
 }
 */
//参数或属性为协议类型时，当传入遵守此协议的类型时，是否可以通过此属性或参数，来访问遵守此协议类型的方法或者属性？答案是不能直接访问，通过协议类型的属性或参数只能访问到协议中的方法或属性，如何做到？需要类型转换
/**
 for item in protocolArray {
     let num = item.random()
     if let smallGenerator = item as? RandomNumberSmallGenerator {
         print(smallGenerator.name) //log:遵守协议的属性
     }
     print(num) //!< 1 17
 }
 */
