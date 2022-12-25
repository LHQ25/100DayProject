//
//  ViewController.swift
//  Swift_Async
//
//  Created by 9527 on 2022/5/20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        Task {
            await test9()
        }
    }
    
    func testt() async -> Int {
        
        let r = await withUnsafeContinuation { continuation in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                
                continuation.resume(returning: 9)
            }
        }
        
        print("xiu")
        return r
    }
    
    func testt2() async throws -> Int {

        let r = try await withUnsafeThrowingContinuation { continuation in

            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {

                continuation.resume(returning: 33)
            }
        }

        print("xiu")
        return r
    }
    
    
}



///// actor 在形式上与 class 很像，不仅如此，actor 也能像它们一样定义扩展，声明泛型，实现协议等等
//actor BankAccount {
//
//    let accountNumber: Int
//    var balance: Double
//
//    init(accountNumber: Int, initialDeposit: Double) {
//        self.accountNumber = accountNumber
//        self.balance = initialDeposit
//    }
//
//}
//
//extension BankAccount {
//
//    // actor 的状态只能在自己的函数内部修改，是因为 actor 的函数的调用是在对应的 executor 上安全地执行的
//    func deposit(amount: Double) async {
//        assert(amount >= 0)
//        balance += amount
//    }
//}
///// 顶级函数  -> 参数 account 的类型被关键字 isolated 修饰，表明函数 deposit 的调用需要保证 account 的状态修改安全。不难想到，对于这个函数的调用，我们需要使用 await
/////  isolated 参数不能有多个（至少现在是这样）
//func deposit(amount: Double, to account: isolated BankAccount) {
//    assert(amount >= 0)
//    account.balance += amount
//}
//
//// 属性隔离
//extension BankAccount {
//
//    enum BankError: Error {
//        case insufficientFunds
//    }
//
//    func transfer(amount: Double, to other: BankAccount) async throws {
//        assert(amount > 0)
//
//        if amount > balance {
//            throw BankError.insufficientFunds
//        }
//
//        balance -= amount
//        // actor 的状态只能在自己的函数内部修改，是因为 actor 的函数的调用是在对应的 executor 上安全地执行的
//        await other.deposit(amount: amount)
//    }
//}
//
///// nonisolated 声明不需要隔离的属性或函数  -> 这个特性在 Actor 实现 Protocol 的时候也显得非常有用
//extension BankAccount: CustomStringConvertible, Hashable {
//
//    ///  description 只能被声明为 nonisolated，这样对于它的访问就不会受到 balance 那么多的限制
//    nonisolated var description: String {
//        "Bank account #\(accountNumber)"
//    }
//
//    /// nonisolated 同样可以用来修饰函数，但这样的函数就不能直接访问被隔离的属性或者方法，只能像外部函数一样使用 await 来异步访问
//    nonisolated func test_nonisolated() {
//        // balance -= 10        // 报错 -> Actor-isolated property 'balance' can not be mutated from a non-isolated context
//        // deposit(amount: 100) // 报错  -> 'async' call in a function that does not support concurrency
//        print("像正常函数一样访问方法：test_nonisolated()")
//    }
//
//    /// 如果不加 nonisolated 则无法访问 accountNumber
//    static func ==(lhs: BankAccount, rhs: BankAccount) -> Bool {
//        lhs.accountNumber == rhs.accountNumber
//    }
//
//    /// 如果不加 nonisolated 则无法访问 accountNumber
//    nonisolated func hash(into hasher: inout Hasher) {
//        hasher.combine(accountNumber)
//    }
//
//    /// 如果不加 nonisolated 则无法访问 accountNumber
//    nonisolated var hashValue: Int {
//        get{
//            accountNumber.hashValue
//        }
//    }
//}
//
//func test() {
//
//    Task {
//        let account = BankAccount(accountNumber: 1234, initialDeposit: 1000)
//        let account2 = BankAccount(accountNumber: 9527, initialDeposit: 1000)
//        print("------------------------- 普通展示 --------------------------------")
//        print(account.accountNumber)            // OK，不可变可以直接访问，不可变就意味着不存在线程安全问题
//        print(await account.balance)            // 可变状态的访问需要使用 await
//
//        print("------------------------- 属性隔离 --------------------------------")
//        try? await account.transfer(amount: 90, to: account2)
//        print(account.accountNumber)
//        print(await account.balance)
//        print(account2.accountNumber)
//        print(await account2.balance)
//
//        print("------------------------- 外部函数修改 actor 的状态 --------------------------------")
//        await deposit(amount: 100, to: account)
//        print(account.accountNumber)
//        print(await account.balance)
//
//        print("------------------------- 声明不需要隔离的属性或函数 --------------------------------")
//        print(account.description)
//        account.test_nonisolated()
//
//        print("------------------------- Actor 与 @Sendable --------------------------------")
//
//    }
//}
