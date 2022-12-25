//
//  02异步函数.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation

func loadSignature_async() async throws -> String? {
    /*
     异步函数的 async 关键字会帮助编译器确保两件事情：
        它允许我们在函数体内部使用 await 关键字；
        它要求其他人在调用这个函数时，使用 await 关键字
     */
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.baidu.com")!)
    // await 代表了函数在此处可能会放弃当前线程，它是程序的潜在暂停点
    return String(data: data, encoding: .utf8)
}
