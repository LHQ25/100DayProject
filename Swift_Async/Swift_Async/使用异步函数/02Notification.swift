//
//  02Notification.swift
//  Swift_Async
//
//  Created by 9527 on 2022/9/7.
//

import Foundation
import UIKit

/*
 对于所有的在“未来发生的事件”，都可以用异步函数和异步队列进行抽象。
 除了协议和代理范式外，Notification 也是 Apple 平台开发中用来处理未来事件的常用工具。
 在 Foundation 中，现在 Notification 也可以用异步序列来表征了
 
 相比于传统的基于 selector 的 Notification，使用异步序列能让相关代码更加紧凑：
 我们不再需要添加新的方法并用 @objc 将它暴露给通知中心和 Objective-C 的运行时；
 在对多个事件进行过滤和变形时，也不再需要新加属性，而是可以使用各种异步序列的扩展方法 (比如 filter，map 等) 来更有效地表达意图。
 */

func test_notification() {
    Task {
        
        let backgroundNotifications = await NotificationCenter.default.notifications(named: UIApplication.didEnterBackgroundNotification, object: nil)
        
        for await notification in backgroundNotifications {
            debugPrint(notification)
        }
    }
}
/*
 不过要注意，使用异步序列处理 Notification 时，Task 和 for await 所导致的程序暂停，将会把还没执行的部分作为续体，并持有调用它们的上下文。
 也就是说，虽然在 Task 闭包中我们并没有明确写出 self，但在序列没有完成时，self 还是会一直被持有，无法得到释放。
 如果我们是在 UIViewController 这样的环境中监听某个没有明确完结的通知的话，这个泄漏所造成的问题将无法忽视。
 
 在获取到想要的通知后，立即跳出异步序列或是取消 Task，对避免意外的长时间持有会有帮助。
 比如上例中，如果我们只关心第一次事件，那么完全可以在获取到序列中首个事件后，立即 break 跳出 for await 循环，这会让相关任务结束：
 */
func test_notification2() {
    let task = Task {
        
        let backgroundNotifications = await NotificationCenter.default.notifications(named: UIApplication.didEnterBackgroundNotification, object: nil)
        
        for await notification in backgroundNotifications {
            debugPrint(notification)
            break
        }
        // 或者
        if let notification = await backgroundNotifications.first(where: { _ in true }) {
            debugPrint(notification)
        }
    }
    /*
     不过需要注意的是，这两种方式都假设了序列至少会产生一个值。
     在产生首个值之前，调用者依然会被持有。
     在某些情况下，这可能是我们所希望的行为。
     但在另外的情况下，如果我们并不希望这个持有行为，则可以利用 Task 的 cancel 来让序列提前终结，来避免泄漏
     */
    task.cancel()
}
