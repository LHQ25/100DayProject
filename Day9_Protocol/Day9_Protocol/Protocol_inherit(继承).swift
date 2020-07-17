//
//  Protocol_inherit(继承).swift
//  Day9_Protocol
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation
//MARK: - 协议的继承

//协议可以继承一个或多个其他协议，并且可以在继承的要求（方法、属性）之上添加其他要求。协议继承的语法类似于类继承的语法，多个继承的协议之间逗号分隔。基本语法
protocol TextDescription {
    func TextDescription()->String
}

protocol AdditionTextDescription : TextDescription {
    var goodEvaluation : String {get}
}

struct Evaluation : AdditionTextDescription {
    var goodEvaluation: String {
         TextDescription() + "很好！"
    }
    func TextDescription() -> String {
        "这个结构体"
    }
}

//MARK: - 协议组合

//协议组合可以组合多个协议成为一个临时的本地协议，该协议具备了组合的所有协议要求，且不会任何新的协议类型。这对于要求某个类型同时遵守多个协议是很有用的。
//协议组合的形式SomeProtocol & AnotherProtocol。可以使用&作为分隔符列出需要的任意数量的协议。另外，协议组合也可以包含类类型，使用此类类型指定遵守协议类类型的父类，验证得知：本类也是可以的

protocol Color {
    var color : String {get}
}
protocol Feature {
    var feature : String {get}
}

class Dog {
   var name : String
    init(_ name : String = "阿里克") {
        self.name = name
    }
}

class Cat : Color,Feature{
    var name : String
    var color: String{
        "黑色"
    }
    var feature: String{
        "撒娇"
    }
    init(_ name : String = "小黄") {
        self.name = name
    }
}
class Husky: Dog, Color, Feature {
    var color: String
    var feature: String
    init(_ name : String,_ color : String,_ feature : String) {
        self.color = color
        self.feature = feature
    }
}

class Kid {
    
    static func hasCat(pet: Cat&Color&Feature ) -> String {
        "恭喜你获得了宠物猫:\(pet.name) 颜色：\(pet.color) 特点：\(pet.feature)"
    }
    static func hasDog(pet:Dog&Color&Feature)->String {
        "恭喜你获得了宠物狗:\(pet.name) 颜色：\(pet.color) 特点：\(pet.feature)"
    }
}


//MARK: - 检查类型实例是否遵守特定协议
/**
 使用<#is#> 和 <#as#> 检查类型实例是否遵守特定协议并且转换为特定协议。语法与类型转换一样。

 如果实例遵守协议，则<#is#>运算符返回 true，否则返回 false。
 <#as？#>向下转换为目标协议类型的可选值，如果实例不遵守该协议，则返回nil。
 <#as!#>强制向下转换为目标协议类型，转换失败则是触发运行时错误
 */
protocol HasArea {
    var area: Double { get }
}
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}


//MARK: - 可选协议要求
/**
 我们可以定义协议可选的要求，这些要求不是必须被遵守此协议的类型实现的。即：我们可以编写遵守某个协议的自定义类，而无需实现任何可选协议要求。
 协议的可选要求的定义：使用optional修饰符作为前缀，定义协议要求即可。
 在协议的可选要求中使用方法或属性时，其类型将自动变为可选。例如，类型(Int)->String的方法变为((Int)->String)?。注意：是整个函数类型都包装在可选内容中，而不是方法的返回值中。本质是：协议中定义的方法名称便是函数的实例，此函数类型变为了可选

 */

/**
 optional必须在@objc修饰的协议下使用，并且必须采用@objc optional的形式。
 协议的可选要求不能被结构体或枚举采用
 */
@objc protocol CounterDataSource {
     @objc optional func increment(forCount count: Int) -> Int
     @objc optional var fixedIncrement: Int { get }
}
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}
class ThreeSource: CounterDataSource {
    let fixedIncrement: Int = 3
}


//MARK: - 协议扩展
/**
 协议通过扩展可以为遵守协议的类型提供方法，初始化，下标和计算属性的实现。这一点允许我们为协议本身定义行为，而不是基于遵守协议的每个类型。
 协议扩展可以将实现添加到遵守协议的类型中，但不能使协议要求进行扩展或从另一个协议继承。协议继承始终在协议声明本身中指定
 */
protocol Color2 {
    var color : String {get}
}
protocol Feature2 {
    var feature : String {get}
}
//扩展协议Feature
extension Feature2 {
    var like_feature : String {
        return "喜欢" + feature
    }
}
class Kid2 {
    static func hasCat(pet:Cat&Color2&Feature2)->String {
        "恭喜你获得了宠物猫,特点：\(pet.like_feature)"
    }
    static func hasDog(pet:Dog&Color2&Feature2)->String {
        "恭喜你获得了宠物狗,特点：\(pet.like_feature)"
    }
}


//MARK: - 协议要求提供默认实现
/**
 我们可以使用协议扩展为当前协议要求定义的任何方法或计算属性提供默认的实现。如果一个遵守此协议的类型提供了属于它自己关于某个协议要求的实现，那么将会代替协议扩展中提供的那一个。
通过扩展提供协议的默认实现，也可以使得遵守该协议的类型不必提供它们自己的实现，这点和可选协议要求一样。但是采用这种方式为可选协议要求增加默认实现后，则无需使用可选链接
*/
protocol Color3 {
    var color : String {get}
}
protocol Feature3 {
    var feature : String {get}
}
//为这两个协议提供默认实现
extension Color3 {
    var color : String {
        "彩虹色"
    }
}
extension Feature3 {
    var feature : String {
        "动物能有啥子特点?"
    }
}
//扩展协议Feature
extension Feature3 {
    var like_feature : String {
        return "喜欢" + feature
    }
}
class Cat3 : Color3,Feature3{
    var name : String
    var color: String{
        "黑色"
    }
//    var feature: String{
//        "撒娇"
//    }
    init(_ name : String = "小黄") {
        self.name = name
    }
}
class Kid3 {
    static func hasCat(pet:Cat&Color3&Feature3)->String {
        "恭喜你获得了宠物猫:\(pet.name) 颜色：\(pet.color) 特点：\(pet.like_feature)"
    }
}


//MARK: - 添加约束到协议扩展

//定义协议扩展时，在协议扩展中定义的方法与属性可用之前，我们可以指定遵守此协议的类型必须满足的约束条件，否则将不可用。
//方式：在要扩展的协议名称使用泛型where子句添加约束

extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}
