//
//  ReplaceNilOPerator.swift
//  CombineTest
//
//  Created by cbkj on 2021/9/30.
//

import Foundation
import Combine

struct FilterOperator {
    
    
    static func loadOperator() {
        
        filterTest()
        
        compactMapTest()
        
        removeDuplicatesTest()
        
        replaceEmptyTest()
        
        replaceErrorTest()
    }
    
    static func filterTest() {
        
        // 过滤
        check("filter") {
            
            [1, 2, 3, 4].publisher
                .filter { v in
                    v % 2 == 0
                }
        }
        
        // 尝试过滤， 出现错误是会抛出错误
        check("tryFilter") {
            
            [1, 2, 3, 4].publisher
                .tryFilter { v in
                    if v == 3 {
                        throw SampleError.stringError(msg: "错误")
                    }
                    return v % 2 == 0
                }
        }
    }
    
    static func compactMapTest() {
        
        // 过滤nil, 也可以值nil 进行操作
        check("compactMap") {
            
            [1, 2, nil, 4].publisher
                .compactMap { v in
                    return v  //过滤nil
//                    return v == nil ? 999 : v   // 或者把 nil 转为其它值
                }
        }
        
//        // 过滤nil, 也可以值nil 进行操作, 错误是抛出异常
        check("tryCompactMap") {
            
            ["1", "2", nil, "4"].publisher
                .tryCompactMap({ value -> String in
                    if value == nil {
                        throw SampleError.sampleError
                    }
                    return value!
                })
        }
    }
    
    static func removeDuplicatesTest() {
        
        // 去重,  不与前一个元素相同，后续可以有相同的元素
        check("removeDuplicates") {
            
            [1,1,2,2,1,1,2,2,3,4,5,6,6,7].publisher
                .removeDuplicates()
        }
        
        // 去重,  不与前一个元素相同，后续可以有相同的元素, 添加自己的判断条件
        check("removeDuplicates with where") {
            
            [1,1,2,2,1,1,2,2,3,4,5,6,6,7].publisher
                .removeDuplicates { v1, v2 in
                    return v2 != v1 // 不与前一个元素相同，
                }
        }
        
        // 去重,  不与前一个元素相同，后续可以有相同的元素, 错误时抛出异常，后续元素不在发出
        check("tryRemoveDuplicates with where") {
            
            [1,1,2,2,1,1,2,2,3,4,5,6,6,7].publisher
                .tryRemoveDuplicates { v1, v2 in
                    if v1 == v2 {
                        throw SampleError.sampleError
                    }
                    return v2 != v1  // 不与前一个元素相同，
                }
        }
    }
    
    static func replaceEmptyTest() {
        
        // 替换 Empty 元素
        check("replaceEmpty") {
            
            Empty<Int, Error>()
                .replaceEmpty(with: 9)
        }
        
    }
    
    static func replaceErrorTest() {
        
        // 替换 Error 元素
        check("replaceError") {
            
            Fail(error: SampleError.stringError(msg: "custom"))
                .replaceError(with: SampleError.stringError(msg: "replaceError"))
        }
        
    }
    
}
