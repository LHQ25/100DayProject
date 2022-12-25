## 前言

Y神写的是真的好。这篇文章的大部分内容来自 Y神的[深入理解 RunLoop](https://link.juejin.cn?target=https%3A%2F%2Fblog.ibireme.com%2F2015%2F05%2F18%2Frunloop%2F)，再结合[官方文档](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FMultithreading%2FRunLoopManagement%2FRunLoopManagement.html) 和其他一些网上的资料再加上自己的一些理解做了一些补充和归纳，官方文档也非常值得一看。 

## RunLoop 简单介绍

RunLoop 直接翻译过来就是 **运行循环**。运行是什么？运行指你的程序运行，循环？额，就是循环。所以运行循环就是指能让你的程序循环不断的运行的一个东西。

RunLoop 是一个让线程能随时处理事件但并不退出的机制。这种模型通常被称为 Event Loop，实现这种模型的关键点在于：如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。

所以，RunLoop 实际上就是一个对象，这个对象管理了其需要处理的事件和消息，并提供了一个入口函数来执行上面 Event Loop 的逻辑。线程执行了这个函数后，就会一直处于函数内部 “接受消息->等待->处理” 的循环中，直到这个循环结束（比如传入 `quit` 的消息），函数返回。

至于为什么要有这个 RunLoop，说一个最直接的，iOS 程序启动后运行在主线程上，而线程一般执行完一段任务就会结束，被 CPU 挂起，如果我们没有保住主线程的命，那么我们的 App 一打开就会关闭。所以苹果帮我们在主线程中默认开启 RunLoop，让 App 能够持续运行。



## RunLoop 与线程

直接列一下两者的关系：

1. RunLoop 与线程是一一对应的。
2. RunLoop 不允许手动创建，只能通过方法去获取，`CFRunLoopGetMain()` 和 `CFRunLoopGetCurrent()`。
3. RunLoop 是懒加载的，如果你不去使用它，那么它就不会被创建，主线程中的 RunLoop 是苹果帮我们默认开启的。
4. RunLoop 的销毁发生在线程结束的时候。
5. RunLoop 与线程的对应关系保存在一个全局的 Dictionary 中

## RunLoop 的结构

在 Core Foundation 里面关于 RunLoop 有 5 个类：

- CFRunLoopRef
- CFRunLoopModeRef
- CFRunLoopSourceRef
- CFRunLoopTimeRef
- CFRunLoopObserverRef



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/14/16ab20ab103dedde~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



每个 RunLoop 中包含若干个 Mode，每个 Mode 中包含若干个 Source/Observer/Timer。

每次调用 RunLoop 的主函数，都只能指定一种 Mode，指定的 Mode 称为 `CurrentMode`，如果需要切换 Mode，就只能退出当前 Loop，然后重新更新指定一种 Mode 进入。这样是为了分割不同组的 Source/Observer/Timer，使其互不影响。

**CFRunLoopSourceRef** 是事件产生的地方。Source 有两个版本：Source0 和 Source1。

- Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 `CFRunLoopSourceSignal(source)`，将这个 Source 标记为待处理，然后手动调用 `CFRunLoopWakeUp(runloop)` 来唤醒 RunLoop，让其处理事件。
- Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 线程。

**CFRunLoopTimeRef** 是基于时间的触发器，它和 NSTimer 和 toll-free bridged 的，可以混用。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop 会注册对应的时间点，当时间点到时，RunLoop 会被唤醒以执行那个回调。

**CFRunLoopObserverRef** 是观察者，每个 Observer 都包含了一个回调（函数指针），当 RunLoop 的状态发生变化时，观察者都能通过回调接受到这个变化。可以观测的时间点有以下几个：

```scss
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
};
复制代码
```

上面的 Source/Timer/Observer 被统称为 **mode item**，一个 item 可以被同时加入多个 mode。但一个 item 被重复加入同一个 mode 时是不会有效果的。如果一个 mode 中一个 item 都没有，则 RunLoop 会直接退出，不进入循环。

### RunLoop Modes

关于具体的结构，大家可以查看 [官方文档](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FMultithreading%2FRunLoopManagement%2FRunLoopManagement.html)，里面有一个关于 RunLoop Modes 的列表。

RunLoop 的大致结构：

```objectivec
struct __CFRunLoop {
    CFMutableSetRef _commonModes;     // Set
    CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
    CFRunLoopModeRef _currentMode;    // Current Runloop Mode
    CFMutableSetRef _modes;           // Set
    ...
};
复制代码
```

RunLoop Mode 的大致结构：

```objectivec
struct __CFRunLoopMode {
    CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
    CFMutableSetRef _sources0;    // Set
    CFMutableSetRef _sources1;    // Set
    CFMutableArrayRef _observers; // Array
    CFMutableArrayRef _timers;    // Array
    ...
};
复制代码
```

大家可以下载 Core Foundation 的[源码](https://link.juejin.cn?target=https%3A%2F%2Fopensource.apple.com%2Ftarballs%2FCF%2F)来查看详细结构。

系统默认注册了 5 个 Mode：

1. `kCFRunLoopDefaultMode` : App 的默认 Mode，通常主线程是在这个 Mode 下面运行的
2. `UITrackingRunLoopMode` : 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动
3. `UIInitializationRunLoopMode`  : 在刚启动 App 时进入的第一个 Mode，启动完后就不再使用
4. `GSEventReceiveRunLoopMode` : 接受系统事件的内部 Mode，通常用不到
5. `kCFRunLoopCommonModes` : 这是一个占位的 Mode，没有实际作用

可以点击[这里](https://link.juejin.cn?target=http%3A%2F%2Fiphonedevwiki.net%2Findex.php%2FCFRunLoop)查看更多的苹果内部的 Mode，但那些 Mode 在开发中基本不会遇到。

不同 Mode 之间互不干扰。

我们常用的有两种，`kCFRunLoopDefaultMode` 和 `UITrackingRunLoopMode`，还有一个 `kCFRunLoopCommonModes`，不过 `kCFRunLoopCommonModes` 只是一种伪模式。

关于 Common modes：一个 Mode 可以将自己标记为 “Common” 属性（通过将其 ModeName 添加到 RunLoop 的 “commonModes” 中）。每当 RunLoop 的内容发生变化时，RunLoop 都会自动将 `_commonModeItems` 里的 Source/Observer/Timer 同步到具有 “Common” 标记的所有 Mode 里。

> 视图滑动时定时器失效的解决方法： 
>
>  主线程的 RunLoop 里有两个预置的 Mode：`kCFRunLoopDefaultMode` 和 `UITrackingRunLoopMode`。这两个 Mode 都已经被标记为 "Commoc" 属性。`Default Mode` 是 App 平时所处的状态，`UITrackingRunLoopMode` 是追踪 `ScrollView` 滑动时的状态（`UITextView` 的滑动也算）。 
>
>  当你创建一个 Timer 并加到 `DefaultMode` 时，Timer 会得到重复回调，但此时滑动一个 `ScrollView` 时，RunLoop 会将 mode 切换为 `UITrackingRunLoopMode`，这时 Timer 就不会被回调，并且也不会影响的到滑动操作，因为不同 Mode 之间是互不干扰的。 
>
>  有时你需要一个 Timer，在两个 Mode 中都能得到回调，一种方法就是将这个 Timer 分别加入这两个 Mode。还有一种方式，就是将 Timer 加入到顶层的 RunLoop 的 `commonModeItems` 中，`commonModeItems` 被 RunLoop 自动更新到所有具有 "Common" 属性的 Mode 里去。



CFRunLoop 对外暴露的管理 Mode 的接口只有下面 2 个：

```objectivec
CFRunLoopAddCommonMode(CFRunLoopRef runloop, CFStringRef modeName);
CFRunLoopRunInMode(CFStringRef modeName, ...);
复制代码
```

Mode 暴露的管理 mode item 的接口有下面几个：

```objectivec
CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef modeName);
CFRunLoopAddTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
CFRunLoopRemoveObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer,CFStringRef modeName);
CFRunLoopRemoveTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
复制代码
```

你只能通过 mode name 来操作内部的 mode，当你传入一个新的 mode name 但 RunLoop 内部没有对应 mode 时，RunLoop 会自动帮你创建对应的 `CFRunLoopModeRef`。对于一个 RunLoop 来说，其内部的 mode 只能增加不能删除。

苹果公开提供的 Mode 有两个：`kCFRunLoopDefaultMode(NSDefalutRunLoopMode)` 和 `UITrackingRunLoopMode`，你可以用这两个 Mode Name 来操作其对应的 Mode。

同时苹果还提供了一个操作 Common 标记的字符串：`kCFRunLoopCommonModes(NSRunLoopCommonModes)`，你可以用这个字符串来操作 Common Items，或标记一个 Mode 为 “Common”。使用时注意区分这个字符串和其他 mode name。

所以 RunLoop Mode 是可以自定义创建的。

### Input Sources

输入源以异步的方式向线程传递事件。事件的来源取决于输入源的类型，通常是两个类别之一：

- Port-based input sources （基于端口的输入源）
- Custom input sources （自定义输入源）

基于端口的输入源监听应用程序的 Mach 端口，自定义输入源监听自定义事件源。就 RunLoop 而言，输入源是基于端口的还是自定义的是无关紧要的，两个来源之间的唯一区别就是它们如何发出信号。基于端口的源由内核自动发出信号，但是自定义的源必须从另一个线程手动发送信号。

当创建输入源(input sources)时，会将其分配给 RunLoop 的一个或多个 Mode。不同的 Mode 会影响对这些输入源的监听。大部分情况下你在默认模式(`kCFRunLoopDefaultMode`)下运行 RunLoop，但你也可以指定自定义的 Mode。如果输入源未处于当前监听的 Mode，则在它生成的任何事件，都将被保留，直到 RunLoop 被指定到正确的 Mode 运行。

#### Port-Based Sources (基于端口的输入源)

Cocoa 和 Core Foundation 提供内置支持，使用与端口相关的对象和函数创建基于端口的输入源。例如，在 Cocoa 中，你根本不必直接创建输入源。你只需要创建一个端口对象并使用 `NSPort` 提供的方法将该端口添加到 RunLoop 中，port 对象会自动为你创建和配置所需的输入源。

在 Core Foundation 中，你必须手动创建端口和输入源。也就是使用 `CFMachPortRef`、`CFMessagePortRef`、`CFSocketRef` 去创建合适的对象。

#### Custom Input Sources

自定义输入源的创建和使用的例子大家可以去查一下官方文档。

#### Cocoa Perform Selector Sources

除了基于端口的源之外，Cocoa 还定义了一个自定义 input source，允许你在任何线程上执行选择器。与基于端口的 source 类似，`perform selector` 请求在目标线程上被序列化，从而减少在一个线程上运行多个方法时可能发生的许多同步问题。与基于端口的 source 不同，`perform selector` 源在执行其 `selector` 后将其自身从 RunLoop 中移除。

在另一个线程执行选择器时，目标线程必须开启了 RunLoop。对于你自己创建的线程，意味着要显式启动 RunLoop。由于主线程中默认启动了 RunLoop，所以只要应用程序调用 `applicationDidFinishLaunching:` ，就可以开始在主线程上发出调用。RunLoop 每次通过循环处理所有排队的 `perform selector` 调用，而不是在每次循环迭代期间处理一个。

关于在其他线程上执行选择器的方法，可以查看[官方文档](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FMultithreading%2FRunLoopManagement%2FNaN)的表3.2。

### Timer Sources （定时器源）

其实就是 NSTimer，计时器，一个 NSTimer 注册到 RunLoop 之后，RunLoop 会为其重复的时间点注册好事件。不过 RunLoop 为了节省资源，并不会在非常准确的时间点回调这个 Timer，因为 RunLoop 内部是有一个处理逻辑的，这个我们放到下面再讲。

定时器是线程通知自己做事情的一种方式。例如，有一个搜索的功能，我们可以使用计时器，设置一个时间，让用户在开始输入之后经过这个时间后开始搜索，这样我们就可以使用户在开始搜索之前输入尽可能的搜索字符串。

虽然我们设置的时间到了计时器就会发出通知让 RunLoop 去做事情，但它并不会真正的实时去处理。与输入源类似，计时器与 RunLoop 的 Mode 相关联。比如你添加定时器到 `kCFRunLoopDefaultMode` 中，如果此时你的 Mode 是 `UITrackingRunLoopMode`，那么这个计时器是不会被触发的。除非你切换 Mode 为 `kCFRunLoopDefaultMode`。如果 Timer 设置的时间到了，该执行 Timer 对应的事件了，但是此时 RunLoop 还在忙着处理其他的事情，那么 Timer 会等到 RunLoop 执行完其他事情再执行。如果线程中的 RunLoop 根本没有被启动，那么 Timer 永远不会被触发。

你可以设置计时器只触发一次或者重复触发，当你设置为重复触发的时候，计时器会按照你原来设置的间隔去不断的触发事件，而不是按照实际触发事件的间隔。比如说你在 `11:00` 的时候，设置了每隔 10 分钟，触发一次计时器事件，也就是 `11:10`、`11:20`、`11:30`...如果由于某些原因，本来应该在 `11:10` 分触发的事件，被推迟到了 `11:15` 才触发，这时虽然你设置的时间间隔是 10 分钟，好像是应该 `11:25` 才触发下一次事件，但是其实不是的，还是会在 `11:20` 分触发下一次时间，然后在 `11:30` 分触发下下次事件。所以计时器是按照你最开始计划的时间来发出通知的。

### Observers（观察者）

RunLoop 在内部会处理 Source 事件、Timer 触发的事件、会休眠、会退出等，在这些特定的时期，系统会通过 Observer 来通知开发者，Observer 关联了 RunLoop 的下列时刻：

- 即将进入 RunLoop
- 即将触发 Timer 回调
- 即将触发 Source（非基于 port 的 Source，Source0）回调
- RunLoop 即将进入休眠
- RunLoop 被唤醒，但在它处理唤醒它的事件之前
- RunLoop 退出

与 Timer 类似，Observer 可以一次或重复使用。一次性 Observer 在触发后将其自身从 RunLoop 中移除，你可以在创建 Observer 时指定是运行一次还是重复运行。

## RunLoop 内部逻辑



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/15/16ab92e256172535~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



下面是官方文档提到的内部逻辑：

1. 通知 Observer 已经进入了 RunLoop
2. 通知 Observer 即将处理 Timer
3. 通知 Observer 即将处理非基于端口的输入源（即将处理 Source0）
4. 处理那些准备好的非基于端口的输入源（处理 Source0）
5. 如果基于端口的输入源准备就绪并等待处理，请立刻处理该事件。转到第 9 步（处理 Source1）
6. 通知 Observer 线程即将休眠
7. 将线程置于休眠状态，直到发生以下事件之一
   - 事件到达基于端口的输入源（port-based input sources）(也就是 Source0)
   - Timer 到时间执行
   - 外部手动唤醒
   - 为 RunLoop 设定的时间超时
8. 通知 Observer 线程刚被唤醒（还没处理事件）
9. 处理待处理事件
   - 如果是 Timer 事件，处理 Timer 并重新启动循环，跳到第 2 步
   - 如果输入源被触发，处理该事件（文档上是 deliver the event）
   - 如果 RunLoop 被手动唤醒但尚未超时，重新启动循环，跳到第 2 步

因为 Timer 和 Source 的 Observer 通知是在这些事件实际发生之前传递的，因此通知事件与实际事件的时间可能存在差距。如果这些事件之间的时间关系很重要，你可以使用休眠和唤醒休眠通知来帮助你关联实际事件之间的时间。

实际上 RunLoop 其内部就是一个 do-while 循环。当你调用 `CFRunLoopRun()` 时，线程就会一直停留在这个循环里，直到超时或被手动停止，该函数才会返回。

## RunLoop 的底层实现

RunLoop 的核心是基于 mach port 的，其进入休眠时调用的函数是 `mach_msg()`。

Mach 本身提供的 API 非常有限，而且苹果也不鼓励使用 Mach 的 API，但是这些 API 非常基础，如果没有这些 API 的话，其他任何工作都无法实施。在 Mach 中，所有的东西都是通过自己的对象实现的，进程、线程和虚拟内存都被称为 “对象”。和其他架构不同，Mach 的对象间不能直接调用，只能通过消息传递的方式实现对象间的通信。“消息” 是 Mach 中最基础的概念，消息在两个端口（port）之间传递，这就是 Mach 的 IPC（进程间通信）的核心。

为了实现消息的发送和接受，`mach_msg()` 函数实际上是调用了一个 Mach 陷阱（trap），即函数 `mach_msg_trap()`，陷阱这个概念在 Mach 中等同于系统调用。当你在用户态调用 `mach_msg_trap()` 时会触发陷阱机制，切换到内核态。内核态中内核实现的 `mach_msg()` 函数会完成实际的工作。

也就是你在用户态调用了 `mach_msg()` 函数，会触发 mach trap，进入由系统调用的 `mach_msg()` 函数中去执行实际的内容。关于用户态和内核态的概念，不知道的朋友可以百度一下。

RunLoop 的核心就是一个 `mach_msg()`，RunLoop 调用这个函数去接收消息，如果没有别人发送 port 消息过来，内核会将线程置于等待状态。例如你在模拟器跑起一个 iOS 的 App，然后在 App 静止时点击暂停，你会看到主线程调用栈停留在 `mach_msg_trap()` 这个地方。

## 什么时候使用 RunLoop

按照官方文档的说法，你唯一需要使用到 RunLoop 的时候是为你的应用程序创建辅助线程(create secondary threads)。

App 的主线程的 RunLoop 是一个至关重要的基础架构，因此，App 框架默认在运行时启动主线程并开启主线程中的 RunLoop。如果是用 Xcode 的模板项目来创建应用程序，那么这些系统都已经帮你做好了，不需要显式调用。

对于辅助线程(secondary threads)，要确定实际情况看是否需要开启 RunLoop，如果需要的话，就自行配置并启动它。在任何情况下，都不应该为一个线程开启 RunLoop。例如，如果使用线程执行某些长时间运行且自定义的任务，则可以避免启动 RunLoop。（我觉得这个说的我有点云里雾里，我贴一下原文）

> You do not need to start a thread’s run loop in all cases. For example, if you use a thread to perform some long-running and predetermined task, you can probably avoid starting the run loop. Run loops are intended for situations where you want more interactivity with the thread.

在以下的几种情况，需要启动 RunLoop：

- 使用端口或自定义输入源与其他线程通信
- 在线程上使用计时器
- 使用 `performSelector` 调用其他线程方法的时候
- 保持线程以执行定期任务

## 苹果用 RunLoop 实现的功能

在开发中我还没直接用到 RunLoop 去做过什么东西，可以做一个常驻线程，但是常驻线程这种东西是有问题的，虽然 AFN2.0 曾经用过，但是那是因为当时苹果的网路请求框架有缺陷。另外一个用到 runloop 的地方可能就是做自动轮播那里，用到了 common mode，其他的方面就很少使用了。所以还是具体来看下苹果对 RunLoop 的应用。

- AutoreleasePool
- 事件响应
- 手势识别
- 界面更新
- 定时器
- PerformSelector
- 关于GCD
- 关于网络请求

### AutoreleasePool

App 启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 `_wrapRunLoopWithAutoreleasePoolHandler()`。

第一个 Observer 监视的事件是 Entry（即将进入 Loop），其回调内会调用 `_objc_autoreleasePoolPush()` 创建自动释放池。其 order 是 `-2147483647`，优先级最高，保证创建释放池发生在其他所有回调之前。

第二个 Observer 监视了两个事件：`BeforeWaiting(准备进入休眠)` 时调用 `_objc_autoreleasePoolPop()` 和 `_objc_autoreleasePoolPush()` 释放旧的池并创建新池。`Exit(即将退出 Loop)` 时调用 `_objc_autoreleasePoolPop()` 来释放自动释放池。这个 Observer 的 order 是 `2147483647`，优先级最低，保证其释放池释放发生在其他所有回调之后。

在主线程执行的代码，通常是写在诸如事件回调、Timer 回调内的。这些回调会被 RunLoop 创建好的 AutoreleasePool 环绕着，所以不会出现内存泄漏，开发者也不必显式创建 Pool 了。 
 简单列举一下步骤：

1. 即将进入 Loop：创建自动释放池
2. 线程即将休眠：释放自动释放池，创建新的自动释放池
3. 即将退出 Loop：释放自动释放池

### 事件响应

苹果注册了一个 Source1（基于 mach port）用来接收系统事件，其回调函数为 `__IOHIDEventSystemClientQueueCallback()`。

当一个硬件事件（触摸/锁屏/摇晃等）发生后，首先由 `IOKit.framework` 生成一个 `IOHIDEvent` 事件并由 [SpringBoard](https://link.juejin.cn?target=https%3A%2F%2Fbaike.baidu.com%2Fitem%2FSpringboard) 接收。这个过程的详细情况可以参考[这里](https://link.juejin.cn?target=http%3A%2F%2Fiphonedevwiki.net%2Findex.php%2FIOHIDFamily)。SpringBoard 只接收按键（锁屏/静音等）、触摸、加速，接近传感器等几种 Event，随后用 mach port 转发给需要的 App 进程。随后苹果注册的那个 Source1 就会触发回调，并调用 `_UIApplicationHandleEventQueue()` 进行应用内部的分发。

`_UIApplicationHandleEventQueue()` 会把 `IOHIDEvent` 处理并包装成 `UIEvent` 进行处理或分发，其中包括 UIGesture/处理屏幕旋转/发送给UIWindow 等。通常事件比如 UIButton 的点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。 
 步骤：

1. 注册一个 Source1 用于接收系统事件
2. 硬件事件发生
3. IOKit.framework 生成 IOHIDEvent 事件并由 SpringBoard 接收
4. SpringBoard 用 mach port 转发给需要的 App
5. 注册的 Source1 触发回调
6. 回调中把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发

### 手势识别

当上面的 `_UIApplicationHandleEventQueue()` 识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。随后系统将对应的 `UIGestureRecognizer` 标记为待处理。

苹果注册了一个 Observer 监测 `BeforeWaiting(Loop即将进入休眠)` 事件，这个 Observer 的回调函数是 `_UIGestureRecognizerUpdateObserver()`，其内部会获取所有刚被标记为待处理的 `GestureRecognizer`，并执行 `GestureRecognizer` 的回调。

当有 `UIGestureRecognizer` 的变化（创建/销毁/状态改变）时，这个回调都会进行相应处理。 
 步骤：

1. 识别到手势
2. 调用 Cancel 将当前 touchesBegin/Move/End 系列回调打断
3. 将对应的 `UIGestureRecognizer` 标记为待处理
4. `BeforeWaiting` 时，在其函数回调内部会获取所有刚被标记为待处理的 `GestureRecognizer`，并执行 `GestureRecognizer` 的回调

### 界面更新

当在操作 UI 时，比如改变了 frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 `setNeedsLayout/setNeedsDisplay` 方法后，这个 UIView/CALayer 就被标记为待处理，并被提交到一个全局的容器去。

苹果注册了一个 Observer 监听 `BeforeWaiting(即将进入休眠)` 和 `Exit(即将退出Loop)` 事件，回调去执行一个很长的函数：`_ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()`。这个函数里会遍历所有待处理的 `UIView/CALayer` 以执行实际的绘制和调整，并更新 UI 界面。 
 步骤：

1. UI 需要更新
2. 将要更新的 UI 标记为待处理，并提交到一个全局的容器去
3. `BeforeWaiting` 和 `Exit` 时遍历所有待处理的 UI 以执行实际的绘制和调整，并更新 UI 界面

### 定时器

`NSTimer` 其实就是 `CFRunLoopTimeRef`，他们之间是 `toll-free bridged` 的。一个 `NSTimer` 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00，10:10，10:20 这几个时间点。RunLoop 为了节省资源，并不会非常准确的时间点回调这个 Timer。Timer 有个属性叫做 Tolerance(宽容度)，标示了当时间点到后，容许有多少最大误差。

如果某个时间点被错过了，例如执行了一个很长的任务，则那个时间点的回调也会跳过去，不会延后执行。就比如等公交，如果 10:10 时我忙着玩手机错过了那个点的公交，那我只能等 10:20 这一趟了。

`CADisplayLink` 是一个和屏幕刷新率一致的定时器（但实际实现原理更复杂，和 `NSTimer` 并不一样，其内部实际是操作了一个 Source）。如果在两次屏幕刷新之间执行了一个长任务，那其中就会有一帧被跳过去（和 `NSTimer` 类似），造成界面卡顿的感觉。在快速滑动 `TableView` 时，即使一帧的卡顿也会让用户有所察觉。Facebook 开源的 [AsyncDisplayKit](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Ffacebookarchive%2FAsyncDisplayKit) 就是为了解决界面卡顿的问题，其内部也用到了 RunLoop（模仿了 iOS 界面更新的过程）。

### PerformSelector

当调用 NSObject 的 `performSelector:afterDelay:` 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。

### 关于 GCD

当调用 `dispatch_async(dispatch_get_main_queue(), block)` 时，`libDispatch` 会向主线程的 RunLoop 发送消息，RunLoop 会被唤醒，并从消息中取得这个 block，并在回调 `__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__()` 里执行这个 block。但这个逻辑仅限于 dispatch 到主线程，dispatch 到其他线程仍然是由 `libDispatch` 处理的。

### 关于网络请求

iOS 关于网络请求的接口自下至上的层次：

```objectivec
CFSocket
CFNetwork       ->ASIHttpRequest
NSURLConnection ->AFNetworking
NSURLSession    ->AFNetworking2, Alamofire
复制代码
```

- `CFSocket` 是最底层的接口，只负责 socket 通信
- `CFNetwork` 是基于 `CFSocket` 等接口的上层封装
- `NSURLConnection` 是基于 `CFNetwork` 的更高层的封装，提供面向对象的接口
- `NSURLSession` 是 iOS7 中新增的接口，表面上和 `NSURLConnection` 并列的，但底层仍然用到了 `NSURLConnection` 的部分功能（比如 `com.apple.NSURLConnectionLoader` 线程）



下面主要介绍下 `NSURLConnection` 的工作过程。

通常使用 `NSURLConnection` 时，你会传入一个 `Delegate`，当调用了 `[connection start]` 后，这个 `Delegate` 就会不停收到事件回调。实际上，`strat` 这个函数的内部会获取 CurrentRunLoop，然后在其中的 `DefaultMode` 添加 4 个 `Source0`（即需要手动触发的 Source）。`CFMultiplexerSource` 是负责各种 `Delegate` 回调的，`CFHTTPCookieStorage` 是处理各种 Cookie 的。

当开始网络传输时，我们可以看到 `NSURLConnection` 创建了两个新线程：`com.apple.NSURLConnectionLoader` 和 `com.apple.CFSocket.private`。其中 `CFSocket` 线程是处理底层 socket 连接的。`NSURLConnectionLoader` 这个线程内部会使用 RunLoop 来接受底层 socket 事件，并通过之前添加的 Source0 通知到上层的 delegate。



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/15/16ab9fcedd10aba9~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



`NSURLConnectionLoader` 中的 RunLoop 通过一些基于 mach port 的 Source 接收来自底层 `CFSocket` 的通知。当收到通知后，其会在合适的时机向 `CFMultiplexerSource` 等 Source0 发送通知，同时唤醒 `Delegate` 线程的 RunLoop 对 `Delegate` 执行实际的回调。



步骤：

1. 网络开始传输
2. `NSURLConnection` 创建两个新线程，`com.apple.CFSocket.private` 处理 socket 连接，`com.aoole.NSURLConnectionLoader` 内部使用 RunLoop 来接受底层 socket 事件
3. socket 有事件发出，`NSURLConnectionLoader` 通过 Source1 接收到这个通知
4. `NSURLConnectionLoader` 在合适的时机向 `CFMultiplexerSource`、`CFHTTPCookieStorage` 等 Source0 发送通知，同时唤醒 `Delegate` 线程的 RunLoop 让其来处理这些通知
5. `CFMultiplexerSource` 会在 `Delegate` 线程的 RunLoop 对 `Delegate` 执行实际的回调



## 总结

RunLoop 是一个让线程能随时处理事件但并不退出的机制。这种模型通常被称为 Event Loop，实现这种模型的关键点在于：如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。

所以，RunLoop 实际上就是一个对象，这个对象管理了其需要处理的事件和消息，并提供了一个入口函数来执行上面 Event Loop 的逻辑。线程执行了这个函数后，就会一直处于函数内部 “接受消息->等待->处理” 的循环中，直到这个循环结束（比如传入 `quit` 的消息），函数返回。



说 RunLoop 就绕不开线程，RunLoop 与线程的关系：

1. RunLoop 与线程一一对应，它们的关系呗保存在一个全局的 `Dictionary` 中
2. RunLoop 是懒加载的，你不主动获取，那它一直都不会有
3. RunLoop 的销毁发生在线程结束时
4. 主线程的 RunLoop 是默认开启的



一个 RunLoop 包含若干个 Mode，每个 Mode 包含若干个 Source/Timer/Observer，Source/Timer/Observer 被统称为 Mode Item。不同 Mode 之间互不干扰。

在 Core Foundation 里面关于 RunLoop 的 5 个类：

- CFRunLoopRef
- CFRunLoopModeRef
- CFRunLoopSourceRef
- CFRunLoopTimerRef
- CFRunLoopObserver

**Mode**

系统默认注册了 5 个 Mode：

1. `kCFRunLoopDefaultMode`：App 的默认 Mode
2. `UITrackingRunLoopMode`：界面跟踪 Mode，用于 `ScrollView` 追踪触摸滑动
3. `UIInitializationRunLoopMode`：在刚启动 App 时进入的第一个 Mode
4. `GSEventReceiveRunLoopMode`：接受系统事件的内部 Mode，通常用不到
5. `kCFRunLoopCommonModes`：这是一个占位的 Mode，没有实际作用

**Source**

主要分两种类型：

- Source0：不能主动触发事件
- Source1：能主动唤醒 RunLoop 的线程

具体的类型：

- Port-Based Sources：基于端口的源
- Custom Input Sources：自定义输入源
- Cocoa Perform Selector Sources：Cocoa 定义的一个自定义输入源

**Timer**

基于时间的触发器，提前在 RunLoop 中注册好事件，时间点到达时，RunLoop 将被唤醒以执行事件。受限于 RunLoop 的内部逻辑，计时器并不十分准确。

**Observer**

观察者，每个 Observer 都包含了一个回调（函数指针）。

可观测的时间点：

1. kCFRunLoopEntry : 即将进入 Loop
2. kCFRunLoopBeforeTimers : 即将处理 Timer
3. kCFRunLoopBeforeSources : 即将处理 Source
4. kCFRunLoopBeforeWaiting : 即将进入休眠
5. kCFRunLoopAfterWaiting : 刚从休眠中唤醒
6. kCFRunLoopExit : 即将退出 Loop



作者：_Terry
链接：https://juejin.cn/post/6844903844221206536
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。