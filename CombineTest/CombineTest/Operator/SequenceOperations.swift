//
//  SequenceOperations.swift
//  CombineTest
//
//  Created by 娄汉清 on 2021/10/3.
//

import Foundation
import Combine

struct SequenceOperations {
    
    
    static func loadOperators() {
        
        dropTest()
        
        appendTest()
        
        prependTest()
        
        prefixTest()
    }
    
    static func dropTest() {
        
        // 元素个数
        let a = [2,3,4,2,11,3,5].publisher
        
        let b = Just(3)
        // 当开始发送元素时才接收a发送的元素
        check("contains") {
            a.drop(untilOutputFrom: b)
        }
        
        // 过滤掉第一个元素
        check("dropFirst") {
            a.dropFirst()
        }
        
        //过滤掉指定条件的元素
        check("drop - while") {
            a.drop { v in
                v <= 3
            }
        }
        
        check("tryDrop") {
            a.tryDrop { v in
                if v < 3 {
                    throw SampleError.sampleError
                }
                return v <= 3
            }
        }
    }
    
    static func appendTest() {
        
        // 元素个数
        let a = [2,3,4,2,11,3,5].publisher
        // 添加一个元素到末尾
        check("append") {
            a.append(90)
        }
        
        // 添加一个序列到末尾
        check("append - sequence") {
            a.append([9,2,3])
        }
        
        // 添加一个发布者
        check("append - publisher") {
            a.append(Just(20))
        }
    }
    
    static func prependTest() {
        
        // 元素个数
        let a = [2,3,4,2,11,3,5].publisher
        // 添加一个元素到头部
        check("prepend") {
            a.prepend(0)
        }
        
        // 添加一个序列到头部
        check("prepend - sqeuence") {
            a.prepend([0,0,0])
        }
        
        // 添加一个发布者到头部
        check("prepend - publisher") {
            a.prepend(Just(999))
        }
    }
    
    static func prefixTest() {
        
        // 元素个数
        let a = [2,3,4,2,11,3,5].publisher
        // 最多发出n个元素
        check("prefix - maxlenth") {
            a.prefix(3)
        }
        
        // 发出 第二 到 第四 个元素
        check("prefix - while") {
            a.prefix { v in
                v > 1 && v < 4
            }
        }
        
        // 带异常报错的
        check("tryPrefix") {
            a.tryPrefix { v in
                if v > 5 {
                    throw SampleError.sampleError
                }
                return  v > 1 && v < 4
            }
        }
        
        
        // 重新发布元素，直到另一个发布者发出元素。
        check("prefix - publisher") {
            a.prefix(untilOutputFrom: Just(222))
        }
    }
    
}
