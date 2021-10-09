//
//  Delegation(代理).swift
//  Day9_Protocol
//
//  Created by 亿存 on 2020/7/16.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation

//MARK: - 代理  也叫 委托
/**
 委托是一种设计模式，使类或结构体可以将其某些职责委托给其他类型的实例。
 通过定义封装委托职责的协议来实现此设计模式，从而保证遵守协议的类型（或称委托）提供协议需要的的功能。
 委托可用于响应特定操作，或从外部源检索数据，而无需了解该源的底层类型
 */
protocol PersonActivity {
    
    func sleep()
    func eat()
    func play()
}
//通过将AnyObject协议添加到协议的继承列表中，可以将遵守此协议的类型限制为类类型（而不是结构或枚举）。
protocol PersonDelegate : AnyObject {
    
    func personNowDoSomething(name: String,SomeThing:String) -> Void
}

class Person: PersonActivity {

    var name : String
    var age : UInt
    //!< 使用了weak 因此遵守此协议的类型必须是类类型，故`PersonDelegate`继承`anyobjct`
    weak var delegate : PersonDelegate?
    
    init(name:String = "QiShare",age:UInt = 1) {
        self.name = name
        self.age = age
    }
    
    func activity() -> Void {
        let num = arc4random()%3
        switch num {
        case 0:
            sleep()
        case 1:
            eat()
        default:
            play()
        }
    }
    
    func sleep() {
        delegate?.personNowDoSomething(name:name,SomeThing: "睡觉")
    }
    
    func eat() {
        delegate?.personNowDoSomething(name:name,SomeThing: "吃饭")
    }
    
    func play() {
        delegate?.personNowDoSomething(name:name,SomeThing: "玩耍")
    }
}

class DelegationClass:PersonDelegate{
    func personNowDoSomething(name:String,SomeThing: String) {
        print(name + "正在" + SomeThing) //会输出
    }
}


//MARK: - 仅 类 类型遵守的协议Class-Only Protocols

/**
 通过将AnyObject协议添加到协议的继承中，
 可以将遵守此协议的类型限制为类类型（而不是结构或枚举，否则会触发编译时错误）。
 使用weak 修饰的协议类型的属性，则传入的遵守此协议的实例只能为类类型实例
 */

//MARK: - 使用扩展使某个类型遵守协议
/**
 使用扩展使得现有类型遵守新的协议。扩展能够为现有类型添加计算属性，下标，方法，因此能够添加协议要求的方法，属性。
 注：当协议被遵守和实现在实例的类型扩展中，现有类型的实例会自动采用和遵守
 */
protocol ExtensionTogglable {
    mutating func extensionSwitchOperate()
}

extension Bool : ExtensionTogglable {
    mutating func extensionSwitchOperate() {
        self = !self
    }
}

//MARK: - 有条件地遵守协议
/**
 泛型仅在特定的条件下能够满足协议的要求。
 通过协议名称后使用泛型的where子句来使泛型类型有条件的遵守协议
 */
// Array就是泛型`Array<Element>`
extension Array : RandomNumberProtocol where Element : RandomNumberProtocol {
    func random() -> UInt {
        732
    }
}
/**
    extension Array : RandomNumberProtocol where Element : RandomNumberProtocol表示Array中的元素都遵守某个协议时，Array的实例才能使用此协议方法。
    若let num2 = RandomNumberBigGenerator() 则会报错Protocol type 'Any' cannot conform to 'RandomNumberProtocol' because only concrete types can conform to protocols。故Array必须是固定类型，不能是Any或AnyObject，才能遵守此协议。
    若let protocolArray : [RandomNumberProtocol] = [num1,num2]则会报错：Protocol type 'RandomNumberProtocol' cannot conform to 'RandomNumberProtocol' because only concrete types can conform to protocols
 
 */


//MARK: - 通过扩展声明遵守协议
/**
 如果类型已经遵守协议的所有要求，但尚未声明该类型遵守协议，则可以通过一个空扩展 来声明
 */

class RandomNumberSmallGenerator2 {
    var name = "遵守协议的属性"
    func random() -> UInt {
        return UInt(arc4random() % 10)
    }
}

extension RandomNumberSmallGenerator2 : RandomNumberProtocol {}

