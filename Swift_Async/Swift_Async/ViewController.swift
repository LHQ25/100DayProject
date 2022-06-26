//
//  ViewController.swift
//  Swift_Async
//
//  Created by 9527 on 2022/5/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         在调用异步函数时，需要在它前面添加 await 关键字；
         而另一方面，只有在异步函数中，我们才能使用 await 关键字。那么问题在于，第一个异步函数执行的上下文，或者说任务树的根节点，是怎么来的？

         简单地使用 Task.init 就可以让我们获取一个任务执行的上下文环境，它接受一个 async 标记的闭包：。
         */
        Task {
            let strings = try await loadFromDatabase()
            if let signature = try await loadSignature() {
                debugPrint(signature)
                strings.forEach {
                    addAppending(signature, to: $0)
                }
            } else {
//                throw NoSignatureError()
            }
        }
    }
    
    func addAppending(_ signature: String?, to: Character?)  {
        
    }
}

/*
 异步函数的概念:
    在函数声明的返回箭头前面，加上 async 关键字，就可以把一个函数声明为异步函数
 
 异步函数的 async 关键字会帮助编译器确保两件事情：
    1.它允许我们在函数体内部使用 await 关键字；
    2. 它要求其他人在调用这个函数时，使用 await 关键字。
 */
func loadSignature() async throws -> String? {
//    fatalError("暂未实现")
    let (data, _) = try await URLSession.shared.data(from: URL(string: "http://127.0.0.1:8000/strTest")!)
    return String(data: data, encoding: .utf8)
}

func loadFromDatabase() async throws -> String {
    // 假装获取数据
    return "1234"
}

