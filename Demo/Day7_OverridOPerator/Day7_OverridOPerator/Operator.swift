//
//  Operator.swift
//  Day7_OverrideOperation
//
//  Created by 亿存 on 2020/7/15.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation


struct Vector2D {
    var x = 0.0
    var y = 0.0
    
    ///同样的  +  -  *  /  都是类似的写法   系统已经写好了  直接重载就OK了
    static func +(lhs: Vector2D, rhs: Vector2D) -> Self {
        
        return Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    
    
    //前操作符 可以不用写操作符声明
    static prefix func ++(lsh: inout Vector2D) {
        lsh.x += 1
        lsh.y += 1
    }
    
    //后操作符   可以不用写操作符声明
    static postfix func ++(lhs: inout Vector2D) {
        lhs.x += 1
        lhs.y += 1
    }
    
    ///自定义操作符
    static func +*(lhs: Vector2D, rhs: Vector2D) -> Double {
        return lhs.x * rhs.x + lhs.y * rhs.y
    }
}

//自定义描述对象的方式  必须实现协议
extension Vector2D: CustomStringConvertible {
    
    var description: String{
        return "：x:\(x), y\(y)"
    }
}
//Debug打印方式  自定义描述对象的方式  必须实现协议
extension Vector2D: CustomDebugStringConvertible {
    var debugDescription: String{
        return "Debug输出：x:\(x), y\(y)"
    }
}
/**
 Associativity：left、right、none  有三个值。 操作符的结合律   即如果多个同类的操作符顺序出现的计算顺序(运算规则)。比如常见的加法和减法都是 left（运算规则 为从左至右一个个计算 ）
 就是说多个加法同时出现时按照从左往右的顺序计算 (因为加法满足交换律，所以这个顺序无所谓，但是减法的话计算顺序就很重要了)。
 点乘的结果是一个 Double，不再会和其他点乘结合使用，所以这里是 none;

 higherThan： 该操作符比某(系统或者自定义的)操作符的优先级高:  运算的优先级，点积运算是优先于乘法运算的。除了 higherThan，也支持使用 lowerThan 来指定优先级低于某个其他组。
 
 lowerThan： 该操作符比某个(系统或者自定义的)操作符的优先级低
 
 assignment： 该操作符是否为赋值操作符  false  或者 true
 */
precedencegroup DotProductPrecedence {
    associativity: none
//    higherThan: MultiplicationPrecedence   //可以一起出现  但是规则之间 需要适当
    lowerThan: MultiplicationPrecedence
    assignment: false
}

/**
 infix 中位操作符 例如: ==、>=、<等操作符
 prefix 前置操作符 例如++i、!等操作符
 postfix 后置操作符 例如i++、i--
 */
infix operator +*: DotProductPrecedence  //声明操作符 +*


/**
 Swift 的操作符是不能定义在局部域中的，因为至少会希望在能在全局范围使用你的操作符，否则操作符也就失去意义了。另外，来自不同 module 的操作符是有可能冲突的，这对于库开发者来说是需要特别注意的地方。如果库中的操作符冲突的话，使用者是无法像解决类型名冲突那样通过指定库名字来进行调用的。因此在重载或者自定义操作符时，应当尽量将其作为其他某个方法的 "简便写法"，而避免在其中实现大量逻辑或者提供独一无二的功能。这样即使出现了冲突，使用者也还可以通过方法名调用的方式使用你的库。运算符的命名也应当尽量明了，避免歧义和可能的误解。因为一个不被公认的操作符是存在冲突风险和理解难度的，所以我们不应该滥用这个特性。在使用重载或者自定义操作符时，请先再三权衡斟酌，你或者你的用户是否真的需要这个操作符。

 */

/**
 
    Operator                        Description                             Associativity                               Precedence group
 
      <<        Bitwise left shift          None            BitwiseShiftPrecedence
      >>                        Bitwise right shift                             None                                   BitwiseShiftPrecedence
      *                              Multiply                               Left associative                         MultiplicationPrecedence
       /                                 Divide                                Left associative                        MultiplicationPrecedence
      %                             Remainder                            Left associative                        MultiplicationPrecedence
      &*                  Multiply, ignoring overflow               Left associative                        MultiplicationPrecedence
      &                             Bitwise AND                           Left associative                        MultiplicationPrecedence
      +                                  Add                                  Left associative                            AdditionPrecedence
      -                              Subtract                               Left associative                            AdditionPrecedence
      &+                       Add with overflow                      Left associative                            AdditionPrecedence
      &-                     Subtract with overflow                 Left associative                             AdditionPrecedence
       |                             Bitwise OR                           Left associative                             AdditionPrecedence
      ^                             Bitwise XOR                          Left associative                             AdditionPrecedence
      ..<          Half-open range           None              RangeFormationPrecedence
     ...           Closed range             None              RangeFormationPrecedence
      is            Type check          Left associative         CastingPrecedence
 as, as?, and as!   Type cast           Left associative         CastingPrecedence
      ??           Nil coalescing      Right associative       NilCoalescingPrecedence
      <             Less than               None                 ComparisonPrecedence
      <=         Less than or equal         None                 ComparisonPrecedence
      >                            Greater than                                  None                                      ComparisonPrecedence
      >=                       Greater than or equal                       None                                      ComparisonPrecedence
      ==                                Equal                                       None                                      ComparisonPrecedence
      !=                             Not equal                                     None                                      ComparisonPrecedence
      ===                           Identical                                      None                                      ComparisonPrecedence
      !==                        Not identical                                   None                                       ComparisonPrecedence
      ~=                        Pattern match                                  None                                      ComparisonPrecedence
      .==                      Pointwise equal                                None                                      ComparisonPrecedence
      .!=                     Pointwise not equal                            None                                       ComparisonPrecedence
      .<          Pointwise less than       None                  ComparisonPrecedence
      .<=     Pointwise less than or equa   None                 ComparisonPrecedence
      .>                    Pointwise greater than                        None                                       ComparisonPrecedence
      .>=               Pointwise greater than or equal              None                                       ComparisonPrecedence
      &&                          Logical AND                         Left associative                             LogicalConjunctionPrecedence
       ||                           Logical OR                           Left associative                             LogicalDisjunctionPrecedence
       ?:                    Ternary conditional                   Right associative                                   TernaryPrecedence
       =                             Assign                              Right associative                                  AssignmentPrecedence
       *=                    Multiply and assign                  Right associative                                  AssignmentPrecedence
       /=                      Divide and assign                  Right associative                                   AssignmentPrecedence
      %=                  Remainder and assign               Right associative                                  AssignmentPrecedence
      +=                         Add and assign                    Right associative                                  AssignmentPrecedence
      -=                      Subtract and assign                 Right associative                                  AssignmentPrecedence
      <<=    Left bit shift and assign Right associative          AssignmentPrecedence
      >>=               Right bit shift and assign              Right associative                                  AssignmentPrecedence
      &=                  Bitwise AND and assign              Right associative                                 AssignmentPrecedence
      |=                    Bitwise OR and assign                Right associative                                 AssignmentPrecedence
      ^=                 Bitwise XOR and assign                Right associative                                 AssignmentPrecedence
 */
