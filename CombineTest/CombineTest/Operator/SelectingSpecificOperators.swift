//
//  SelectingSpecificOperators.swift
//  CombineTest
//
//  Created by 娄汉清 on 2021/10/3.
//

import Foundation
import Combine

struct SelectingSpecificOperators {
    
    static func loadOperators() {
        
        firstTest()
        
        lastTest()
        
        outputTest()
    }
    
    static func firstTest(){
        
        let a = [2,3,4,2,11,3,5].publisher
        
        //第一个元素
        check("first") {
            a.first()
        }
        
        //第一个通过条件的元素
        check("first - while") {
            a.first { v in
                v >= 4
            }
        }
        
        //第一个通过条件的元素
        check("tryFirst") {
            a.tryFirst { v in
                if v >= 3 {
                    throw SampleError.sampleError
                }
                return v >= 4
            }
        }
    }
    
    static func lastTest(){
        
        let a = [2,3,4,2,11,3,5].publisher
        
        //最后一个元素
        check("last") {
            a.last()
        }
        
        //最后开始 第一个通过条件的元素
        check("last - while") {
            a.last { v in
                v >= 4
            }
        }
        
        //第一个通过条件的元素
        check("tryLast") {
            a.tryLast { v in
                if v >= 3 {
                    throw SampleError.sampleError
                }
                return v >= 4
            }
        }
    }
    
    static func outputTest(){
        
        let a = [2,3,4,2,11,3,5].publisher
        
        // 指定位置的元素
        check("output") {
            a.output(at: 2)
        }
        
        // 指定位置的元素
        check("output") {
            a.output(in: 2...5)
        }
        
    }
    
}
