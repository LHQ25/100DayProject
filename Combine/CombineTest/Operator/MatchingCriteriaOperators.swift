//
//  MatchingCriteriaOperators.swift
//  CombineTest
//
//  Created by 娄汉清 on 2021/10/3.
//

import Foundation


struct MatchingCriteriaOperators {
    
    static func loadOperators() {
        
        containsTest()
        
        allSatisfyTest()
    }
    
    static func containsTest() {
        
        
        // 元素个数
        let a = [2,3,4,2,11,3,5].publisher
        
        check("contains") {
            a.contains(4)
        }
        
        check("contains - custom") {
            a.contains { v in
                v > 15
            }
        }
        
        check("tryContains") {
            a.tryContains { v in
                if v < 3 {
                    throw SampleError.sampleError
                }
                return v > 5
            }
        }
    }
    
    static func allSatisfyTest() {
        
        
        // 元素个数
        let a = [2,3,4,2,11,3,5].publisher
        
        // 是否所有元素都能通过给定的条件
        check("allSatisfy") {
            a.allSatisfy { v in
                
                return v >= 2
            }
        }
        
        check("tryAllSatisfy") {
            a.tryAllSatisfy { v in
                if v <= 2 {
                    throw SampleError.sampleError
                }
                return v > 2
            }
        }
        
    }
}
