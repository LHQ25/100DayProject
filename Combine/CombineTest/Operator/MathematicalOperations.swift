//
//  MathematicalOperations.swift
//  CombineTest
//
//  Created by 娄汉清 on 2021/10/3.
//

import Foundation

struct MathematicalOperations {
    
    static func loadOperators() {
        
        countTest()
        
        maxTest()
        
        minTest()
    }
    
    static func countTest() {
        
        
        // 元素个数
        let a = [2,3,4,2,11,3,5].publisher
        
        check("count") {
            
            a.count()
        }
        
    }
    
    static func maxTest() {
        
        let a = [2,3,4,2,2,11,3,5].publisher
        
        // 最大元素
        check("max") {
            
            a.max()
        }
        
        // 最大元素, 自己提供方法去判断
        check("max - custom") {
            
            a.max { v1, v2 in
                v1 < v2
            }
        }
        
        // 最大元素, 自己提供方法去判断
        check("tryMax") {
            
            a.tryMax { v1, v2 in
                
                if v1 == v2 {
                    throw SampleError.sampleError
                }
                return v1 < v2
            }
        }
        
    }
    
    static func minTest() {
        
        let a = [2,3,4,2,2,11,3,5].publisher
        
        // 最大元素
        check("min") {
            
            a.min()
        }
        
        // 最大元素, 自己提供方法去判断
        check("min - custom") {
            
            a.min { v1, v2 in
                v1 < v2
            }
        }
        
        // 最大元素, 自己提供方法去判断
        check("tryMin") {
            
            a.tryMin { v1, v2 in
                
                if v1 == v2 {
                    throw SampleError.sampleError
                }
                return v1 < v2
            }
        }
        
    }
    
}
