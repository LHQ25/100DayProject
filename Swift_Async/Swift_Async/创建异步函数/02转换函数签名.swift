//
//  02转换函数签名.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/5.
//

import Foundation
import SwiftUI
import UIKit

//MARK: - 2. 转换函数签名
/*
 异步函数的目标是使用类似同步的方式来书写异步操作的代码，来修正闭包回调方式的问题，并最终取而代之。
 随着 Swift 并发在将来的普及，相信今后我们一定会遇到需要将回调方式的异步操作迁移到异步函数的情况，这中间很大部分的工作量会落在如何将闭包回调的代码改写为异步函数这件事上
 */

//MARK: - 2.1 修改函数签名
/*
 对于基于回调的异步操作，一般性的转换原则就是将回调去掉，为函数加上 async 修饰。
 如果回调接受 Error? 表示错误的话，新的异步函数应当可以 throws，最后把回调参数当作异步函数的返回值即可
 */
func calculate(input: Int, completion: @escaping (Int) -> Void) { }

func load(completion: @escaping ([String]?, Error?) -> Void) { }

 // 转换为

func calculate(input: Int) async -> Int { return 0 }
func load() async throws -> [String] { return [] }

/*
 当遇到可抛出的异步函数时，编译器要求我们将 async 放在 throws 前；
 在这类函数的调用侧，编译器同样做出了强制规定，要求将 try 放在 await 之前
 */

//MARK: - 2.2 带有返回的情况
/*
 有些情况下，带有闭包的异步操作函数本身也具有返回值
 func data(from url: URL, delegate: URLSessionTaskDelegate? = nil ) async throws -> (Data, URLResponse)
 
 在 URLSessionDataTask 这个特例下，这没有造成太大问题。URLSessionDataTask 需要承担的最大的任务，就是取消网络请求。异步函数都是运行在某个任务环境中的，因此可以通过取消任务来间接取消运行中的网络请求。虽然这需要一些额外的努力，但是是可以优雅地做到的
 
 */

//MARK: - 2.3 @completionHandlerAsync

/*
 异步函数具有极强的“传染性”：
    一旦你把某个函数转变为异步函数后，对它进行调用的函数往往都需要转变为异步函数。
 为了保证迁移的顺利，Apple 建议进行从下向上的迁移：先对底层负责具体任务的最小单元开始，将它改变为异步函数，然后逐渐向上去修改它的调用者。

 为了保证迁移的顺利，一种值得鼓励的做法是，在为一个原本基于回调的函数添加异步函数版本的同时，暂时保留这个已有的回调版本。
 
 可以为原本的回调版本添加 @completionHandlerAsync 注解，告诉编译器存当前函数存在一个异步版本。
 当使用者在其他异步函数中调用了这个回调版本时，编译器将提醒使用者可以迁移到更合适的异步版本”
 
 @completionHandlerAsync 和 @available 标记很类似。
 它接收一个字符串，并在检测到被标记的函数在异步环境下被调用时，为编译器提供信息，帮助使用者用 “fix-it” 按钮迁移到异步版本。
 和一般的 @available 的不同之处在于，在同步环境下 @completionHandlerAsync 并不会对 calculate(input:completion:) 的调用发出警告，它只在异步函数中进行迁移提示，因此提供了更为准确的信息
*/
//@completionHandlerAsync("calculate2(input:)")
//func calculate2(input: Int, completion: @escaping (Int) -> Void) {
//    completion(input + 100)
//}
//
//func calculate2(input: Int) async throws -> Int {
//    return input + 100
//}
