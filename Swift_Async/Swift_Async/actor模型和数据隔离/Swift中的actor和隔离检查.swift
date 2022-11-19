//
//  Swift中的actor和隔离检查.swift
//  Swift_Async
//
//  Created by 9527 on 2022/11/17.
//

import Foundation


// #1 ----------------------- Swift 中的actor和隔离检查 -----------------------
actor Room {
    
    let roomNumber = "101"
    var vistorCount: Int = 0
    private let person: Person
    
    init() {
        person = Person(name: "123", age: 123)
    }
    
    func visit() -> Int {
        // actor 可以自由使用内部定义的变量或者方法
        vistorCount += 1
        return vistorCount
    }
    
    func forwardVisit(_ anotherRoom: Room) async -> Int {
        // actor 隔离域是按照 actor 实例进行隔离的：也就是说，不同的 Room 实例拥有不同的隔离域。如果要进行消息的“转发”，我们必须明确使用 await
        await anotherRoom.visit()
    }
}

func actor_test1() async {
    
    let room = Room()
    // 可以直接访问不可变量
    print(room.roomNumber)
    // 对于可变变量或者方法就不能直接访问
    print(await room.vistorCount)
    print(await room.visit())
}

// #2 ----------------------- Swift 中的actor和隔离检查 -----------------------
protocol Popular {
    var popular: Bool { get }
}

// 妥协，让 Popular 也能在某个隔离域中
protocol Popular2: Actor {
    var popular2: Bool { get }
}

// 妥协，让 Popular3 将涉及到的成员设计为异步方法或属性；也就是说，让它在语法上明确满足“可暂停”的特点
protocol PopularAsync {
    var popularAsync: Bool { get async }
}

extension Room: Popular, Popular2, PopularAsync {
    
//    Actor-isolated property 'popular' cannot be used to satisfy nonisolated protocol requirement
//    var popular: Bool {
//        vistorCount > 10
//    }
    nonisolated var popular: Bool {
        false
    }
    
    var popular2: Bool {
        vistorCount > 10
    }
    
    var popularAsync: Bool {
        get async {
            vistorCount > 10
        }
//        get async {
//            internalPopular
//        }
    }
    
    // 当某个域内方法本身是同步方法时，是不允许调用这个异步 getter 的
    // 'async' property access in a function that does not support concurrency
//    func reportPopular() {
//        if popularAsync {
//            print("0000000000")
//        }
//    }
        func reportPopular() {
            if internalPopular {
                print("0000000000")
            }
        }
    
    // 内部使用的同步getter
    private var internalPopular: Bool {
        vistorCount > 10
    }
    
}

// 既能被 class 或 struct 这样的“传统”类型满足，又能以安全的方式工作在 actor 里，可以考虑将协议的成员声明为上面这样的异步成员。因为同步函数其实是异步函数的子集和“特例”，所以普通类型是可以用同步函数来实现这个协议的异步定义
class RoomClass: PopularAsync {
    
    var popularAsync: Bool { return true }
    
}

// 使用 PopularAsync 作为类型约束 的话, 类型信息不足以判断 popularAsync 的具体实现是否是同步，必须加上 await 才能进行调用
func actor_bar<T: PopularAsync>(value: T) async {
    
    print(await value.popularAsync)
}

//MARK: -  nonisolated
// PopularActor 和 PopularAsync 的例子中，我们都更改了协议本身的定义。但是当这个协议是外部定义的或者早已存在于现有同步系统中的话，改变协议本身是很困难、甚至不可能的事情
extension Room: CustomStringConvertible {
    
    // 使用 nonisolated 标记可以让编译器做到这一点, 明确将 Room.description 声明放到隔离域外
    // nonisolated 标记的成员，无法访问那些隔离域内的成员，否则将违反基本的并发安全假设，让 actor 类型变得不安全
    nonisolated var description: String {
        // "vistorCount: \(vistorCount)" // Actor-isolated property 'vistorCount' can not be referenced from a non-isolated context
        "roomNumber: \(roomNumber)"
    }
}

// actor 中的存储属性的成员安全保证，只针对具体的值和引用。而对于那些被引用的实际对象，如果它们的类型不是 actor，而是普通的 class 的话，在域外对这些对象上成员的访问依然是不安全的”
class Person: CustomStringConvertible {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    var description: String {
        "Name: \(name), age: \(age)"
    }
}
extension Room {
    // 隔离域内修改
    func safeChangePersonName(){
        person.name = "456"
    }
    // 隔离域外修改，它可能在多个线程中以并行的方式被调用，此时对 name 的修改将造成内存的数据竞争。因此这段代码是不安全的
    // 并没有违反 actor 关于“保护成员”的目标：因为 person 这个引用确实是完全受到保护的，问题在于 Person 类型没有能够保护它的 name 成员，这是由于 Person 是 class 这一特质所造成的，和 Room 是 actor 这一事实并无关系。想要增加安全性，我们可以选择把 Person 也声明为 actor，或者让它满足一个稍微弱化的假设，让 Person 满足 Sendable。在未来，编译器会添加这类问题的静态检查，并彻底防止此类数据竞争的问题
    nonisolated func unsafeChangePersonName(){
        person.name = "345"
    }
}

//MARK: -  isolated
// 使用 isolated 关键字来修饰函数的某个 actor 类型的参数，这会明确表示函数体应该运行在该 actor 的隔离域中。通常在一些需要隔离的全局的函数中
func reportRoom(room: isolated Room) {
    print(room.vistorCount)
}
// 根据调用者和参数的不同，在调用这个全局函数时，编译器会要求我们添加 await。
// 规则和一般对 actor 的成员调用完全一致：当从隔离域内部使用时，可以以同步方式直接访问；但当从隔离域外使用时，则需要 await”


func actor_test2() async {
    
    let room = Room()
    // popularActor 现在是 actor 的一部分了，从隔离域外对它的访问，都需要经过 await 进行。这一点和 actor 上的其他成员的默认行为是一致的。PopularActor 现在是 Actor 的细分协议，因此也只有 actor 类型能满足这个协议了
    print(await room.popular2)
    print(await room.popularAsync)
    
    let roomClass = RoomClass()
    print(roomClass.popularAsync)
    
    // 如果我们要使用 PopularAsync 作为实例类型 (或者类型约束) 的话，由于类型信息不足以判断 popularAsync 的具体实现是否是同步，我们必须加上 await 才能进行调用
    let roomClass2: PopularAsync = RoomClass()
    print(await roomClass2.popularAsync)
    
    await actor_bar(value: roomClass2)
    
    // isolated
    await reportRoom(room: room)
}
