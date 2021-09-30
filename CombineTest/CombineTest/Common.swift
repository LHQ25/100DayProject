//
//  Common.swift
//  CombineTest
//
//  Created by cbkj on 2021/9/30.
//

import Foundation
import Combine

// MARK: - “辅助类的代码，用来帮助打印和确认事件流”

public enum SampleError: Error {
    case sampleError
    case stringError(msg: String)
    case customError(error: Error)
}


@discardableResult
public func check<P: Publisher>(_ title: String, publisher: () -> P) -> AnyCancellable
{
    print("----- \(title) -----")
    defer { print("") }
    return publisher()
        .print()
        .sink(receiveCompletion: { _ in}, receiveValue: { _ in } )
}

/*
 使用 check 来检查某个 Publisher，它将打印输入的 title 信息，
 然后通过 sink 来订阅这个 Publisher，这可以让输入的 publisher 开始发送和产生值。
 在订阅之前，为 publisher 添加了一个 .print()，
 这是一个 Combine 内建的 Operator，
 它会在该 publisher 发送事件时，将具体事件的内容打印到控制台，方便调试观察”
 */
