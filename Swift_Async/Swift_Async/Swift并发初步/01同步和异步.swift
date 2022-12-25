//
//  01同步和异步.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation

// 同步函数
var results: [String] = []

func addAppending(_ value: String, to string: String){
    
    results.append(value.appending(string))
}

func loadSignature() throws -> String? {
    // 会卡主主线程
    let data = try Data(contentsOf: URL(string: "www.baidu.com")!)
    return String(data: data, encoding: .utf8)
}

// 修改为异步
func loadSignature(_ completion: @escaping (String?, Error?) -> Void) {
    
    DispatchQueue.global().async {
        do {
            let data = try Data(contentsOf: URL(string: "www.baidu.com")!)
            DispatchQueue.main.async {
                completion(String(data: data, encoding: .utf8), nil)
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
}
