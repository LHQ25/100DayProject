//
//  Base.swift
//  Swift_Async
//
//  Created by 9527 on 2022/5/20.
//

import Foundation


fileprivate func asyncFunction(handle: @escaping (String)->Void) throws {
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        handle("asyncFunction - 异步回调 - 完成")
    }
}

func baseAsyncFunc() async throws -> Int  {
    
    try asyncFunction { msg in
        
    }
    return Int.random(in: 0...10000)
}
