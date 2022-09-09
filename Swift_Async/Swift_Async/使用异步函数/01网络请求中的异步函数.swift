//
//  01网络请求中的异步函数.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/7.
//

import Foundation
import UIKit

// MARK: - 异步 URLSession 方法

func test_urlsesstion() {
    
    Task {
        let (data, response) = try await URLSession.shared.data(from: URL(string: "http://localhost:8000/colors")!)
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print(try? JSONSerialization.jsonObject(with: data))
        }
    }
}
/*
 相比起传统方法，这个新函数优点十分明显。除了具有一般的异步函数的优点外，它还额外提供了一些特性：
    网络请求任务将立即开始，不再依赖于调用 resume。原先使用 dataTask 方法生成的 URLSessionDataTask 实例，在创建时将占用一系列 session 资源。如果由于某种原因，没有调用 resume 的话，直到 session 整个结束，这些资源都不会被清理，很容易造成事实上的内存泄漏，而且这很难被察觉到。
    和之前针对整个 session 的 delegate 不同，这里的 delegate 是针对单个任务的。这让我们在收到的代理方法调用时，不再需要缓存和区分这个调用到底来自哪个任务，这让控制任务可以在更细粒度上更清晰地实现。
 */

// MARK: - 基于 Bytes 的异步序列
/*
 在某些情况下，可能我们只对响应中的部分数据有兴趣。
 比如下载图片时通过 body 的前几个字节判断图片类型和尺寸，或者对一个特别大的字符串 body 按行读取并寻找关键内容。
 在以前，除了等待请求完成，完整的 Data 被收集以外，我们只能通过检查并收集 delegate 的 urlSession(_:dataTask:didReceive:) 中给出的 data 参数来完成这项任务。
 不过，现在我们有更好的方式来按字节读取响应中的数据了：
 extension URLSession {
    func bytes(from url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (URLSession.AsyncBytes, URLResponse)
 }

 和 data(from:) 方法等待响应完成并获取所有数据不同，新加入的 bytes(from:) 返回的不是完整的 Data，而是一个代表响应中 body 字节数据的 AsyncBytes 类型。AsyncBytes 是一个异步的数据序列，它的值代表了数据的每个字节
 */

func test_bytes() {
    
    let url = URL(string: "http://localhost:8000/colors")!
    let session = URLSession.shared
    Task {
        let (bytes, reseponse) = try await session.bytes(from: url)
        //
        var pngHeader: [UInt8] = [137, 80, 78, 71, 13, 10, 26, 10]
        
        for try await byte in bytes.prefix(8) {
            if byte != pngHeader.removeFirst() {
                debugPrint("byte: \(byte)")       // “最多获取响应中的八个字节，就能检查 body 是不是满足 PNG 图片文件的规范了。
                return
            }
        }
    }
}

/*
 更近一步，基于 AsyncBytes，或者更精确来说，针对 Element 为 UInt8 的异步序列，Apple 还提供了一系列扩展方法，让我们把字节转换为更容易看懂的形式，比如按照每行转为 UTF8 的 String、Character 或者是 UnicodeScalars：
 extension AsyncSequence where Self.Element == UInt8 {
    var lines: AsyncLineSequence<Self> { get }
    var characters: AsyncCharacterSequence<Self> { get }
    var unicodeScalars: AsyncUnicodeScalarSequence<Self> { get }
 }
 */
func test_async_bytes() {
    
    let url = URL(string: "http://localhost:8000/colors")!
    let session = URLSession.shared
    Task {
        let (bytes, _) = try await session.bytes(from: url)
        
        for try await line in bytes.lines {
            debugPrint(line)  // 按行输出
        }
    }
}
/*
 除了 URLSession，URL 现在也接受类似的方法：url.resourceBytes 返回一个异步的字节序列，url.lines 按行返回字符串序列。
 如果你只是想要简单地向某个 URL 发送一个 GET 请求，这应该是最容易的获取结果的方法了：
 */
func test_url() {
    let url = URL(string: "http://localhost:8000/colors")!
    Task {
        for try await line in url.lines {
            print(line)
        }
    }
}
/*
 当然，上面的 URL 对于本地文件也有效。
 实际上，除了基于 URLSession 的网络请求外，和文件读取操作相关的 FileHandle API 中也提供了 bytes 方法，来把加载的数据表征为异步序列。
 同为 I/O 操作，这些新加入的抽象把具体的加载过程省略，而从本质上强调了“异步加载数据”这一核心操作。
 这样我们就可以使用相似的方式来处理不同数据源的输入了。
 */

// MARK: - 协议代理方法
/*
 除了直接的方法调用中添加了异步函数外，对于部分协议中的代理方法，现在也可以用异步函数的方式来实现了。
 Swift 引入异步函数后，只要满足我们之前提到的自动转换原则，这类基于回调的代理方法也将被转换为 async 函数。比如在 URLSessionDataDelegate 中，除了上面的回调版本，还有一个异步函数的版本。通过使用这个异步版本，我们可以把上面的方法简单改写成返回 .cancel 或 .allow 的形式：
 
 func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
    guard let scheme = response.url?.scheme, scheme.starts(with: "https") else {
        return .cancel
    }
    return .allow
 }

 */
