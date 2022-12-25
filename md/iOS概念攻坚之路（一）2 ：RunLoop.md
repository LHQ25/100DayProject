## 前言

没有困难的工作，只有勇敢的打工人。

### 概念

如果你经历过这么一种上班状态，有需求需要开发的时候，开发需求，没有需求开发（小概率事件），下班也没有真正意义上的下班，因为群里随时有线上问题需要响应，所以得24小时待命，那当你知道 RunLoop 的机制之后，你可能会觉得很亲切。

RunLoop 是 iOS 中的一种机制，来保证你的 app 一直处于可以响应事件的状态，在有事情做的时候随时响应，然后没事做的时候休息，不占用 CPU。

你可以想象你的 app，启动之后就一直运行在一个类似 `while(1) { ... }` 的循环之中，这样看上去程序好像一直在空转，但是 RunLoop 可以让程序在没有事情执行的时候，进入系统级别的休眠，然后等待事件去触发它，然后再次运行。

这是一个 Event Loop 的概念，基本所有的需要用户交互的系统，比如 Window、Android 等等，都有类似的概念。

![event-loop.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/989173a9fae946c19d5cfbfb9c46ae0b~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

### 与线程的关系

RunLoop 是和线程一一对应的，app 启动之后，程序进入了主线程，苹果帮我们在主线程启动了一个 RunLoop。如果是我们开辟的线程，就需要自己手动开启 RunLoop，而且，如果你不主动去获取 RunLoop，那么子线程的 RunLoop 是不会开启的，它是懒加载的形式。

另外苹果不允许直接创建 RunLoop，只能通过 `CFRunLoopGetMain()` 和 `CFRunLoopGetCurrent()` 去获取，其内部会创建一个 RunLoop 并返回给你（子线程），而它的销毁是在线程结束时。

![thread.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dbddc03bd5a24317912984b76b5e499f~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

### 结构

在 RunLoop 中有几个概念比较重要，Mode、Observer、Source、Timer，它们的关系如下图：

![RunLoop_0.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/62ceccbd934f4c73a249465724aaad43~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

#### Mode

Mode，也就是模式，一个 RunLoop 当前只能处于某一种 Mode 中，就比如当前只能是白天或者夜晚一样。图上可以看到，Mode 之间是互不干扰的，平行世界，A Mode 中发生的事情与 B Mode 无关。这也是苹果丝滑的一个关键，因为苹果的滚动和默认状态分别对应两种不同的 Mode，由于 Mode 互不干扰，所以苹果可以在滚动时专心处理滚动时的事情。

![focus.jpeg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/08de5fa6cc0f471cbaec1b8bcee723cb~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

可以自定义 Mode，但是基本不会这样，苹果也为我们提供了几种 Mode：

- `kCFRunLoopDefaultMode`：app 默认 Mode，通常主线程是在这个 Mode 下运行
- `UITrackingRunLoopMode`：界面追踪 Mode，比如 ScrollView 滚动时就处于这个 Mode
- `UIInitializationRunLoopMode`：刚启动 app 时进入的第一个 Mode，启动完后不再使用
- `GSEventReceiveRunLoopMode`：接受系统事件的内部 Mode，通常用不到
- `kCFRunLoopCommonModes`：不是一个真正意义上的 Mode，但是如果你把事件丢到这里来，那么不管你当前处于什么 Mode，都会触发你想要执行的事件。

基本我们程序跑起来，你别去动它，画面静止，它就处于一个 `kCFRunLoopDefaultMode` 状态，当你滚动它了，它会处于一个 `UITrackingRunLoopMode` 状态，如果你想要在这两个状态都能响应同一个事情，那你要么同时添加到这两种 Mode，要么把这件事情放到 `kCFRunLoopCommonModes` 中去执行。

绝大多数情况下，我们只会接触到这三种 Mode。

#### Observer

Observer，观察者，观察啥呢，也很简单，假如 RunLoop 是一名打工人，那肯定是观察它啥时候干活，啥时候摸鱼，啥时候下班。苹果用一个枚举来表示 RunLoop 的打工状态：

```c
/* Run Loop Observer Activities */
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry = (1UL << 0),           // 即将进入 Loop
    kCFRunLoopBeforeTimers = (1UL << 1),    // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2),   // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5),   // 即将进入休眠
    kCFRunLoopAfterWaiting = (1UL << 6),    // 刚从休眠中唤醒
    kCFRunLoopExit = (1UL << 7),            // 即将退出 Loop
    kCFRunLoopAllActivities = 0x0FFFFFFFU   // 所有的状态
};
复制代码
```

开始上班，有活来了干活，干完了休息，又来活了继续干，下班。

![work.jpeg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/95ad8abf2f7347f78d22592ccd0a1417~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

Timer 和 Source 就是 RunLoop 要干的活。

#### Timer

从结构的那张图可以看到，Mode 中有一个 Timer 的数组，一个 Mode 中可以有多个 Timer。Timer 其实就是定时器，它的工作原理是，你生成一个 Timer，确定要执行的任务，和多久执行一次，将其注册到 RunLoop 中，RunLoop 就会根据你设定的时间点，当时间点到时，去执行这个任务，如果它正在休眠，那么就会先唤醒 RunLoop，再去执行。

当然这个时间点并不是那么准确，因为 RunLoop 的执行是有一个顺序的，要处理的事情也都有一个先后顺序，如果时间点到了，RunLoop 会将 Timer 要执行的事情添加到待执行清单，但是也得等待执行清单前面的事情执行完了才会执行到 Timer 的事情，所以它并不保证一定是准的。

#### Source

Source 是另外一种 RunLoop 要干的活，看源码的话，Source 其实是 RunLoop 的数据源抽象类，是一个 Protocol，也就是说，只要你继承这个 Protocol，你也可以自己实现自己的 Source（基本不会使用）。

RunLoop 中定义了两种 Version 的 Source。一个叫 Source 苹果，一个叫 Source 香蕉。。。

开玩笑的，一个叫 Source0、一个叫 Source1（是不是觉得和苹果香蕉差不多）。

- Source0：处理 App 内部事件，App 自己负责管理（触发），如 `UIEvent`、`CFSocket`。
- Source1：由 RunLoop 内核管理，Mach port 驱动，如 `CFMackPort`、`CFMessagePort`。

个人理解是 Source1 可以认为用来当做进程间或者线程间通信的一种方式，比如我这个 RunLoop 在线程 A，线程 B 想给我发点东西 C，通过 port 进行传输，然后系统将传输的东西包装成 Source1，在线程 A 中监听 port 是否有东西传输过来，接收到后，唤醒 RunLoop 进行处理。

手势的监听，发送网络数据的回调监听，都会被包装成 Source，然后再由 RunLoop 进行处理。

### RunLoop 执行流程

![Work.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e599d59873e44fe793813a36cf0851d1~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?) (转自 [Runloop-实际开发你想用的应用场景](https://juejin.cn/post/6889769418541252615#heading-13))

1. 通知 Observer 已经进入 RunLoop
2. 通知 Observer 即将处理 Timer
3. 通知 Observer 即将处理 Source0
4. 处理 Source0
5. 如果有 Source1，跳到第 9 步（处理 Source1）
6. 通知 Observer 即将休眠
7. 将线程置于休眠状态，直到发生以下事件之一
   - 有 Source0
   - Timer 到时间执行
   - 外部手动唤醒
   - 为 RunLoop 设定的时间超时
8. 通知 Observer 线程刚被唤醒
9. 处理待处理事件
   - 如果是 Timer 事件，处理 Timer 并重新启动循环，跳到 2
   - 如果 Source1 触发，处理 Source1
   - 如果 RunLoop 被手动唤醒但尚未超时，重新启动循环，跳到 2
10. 通知 Observer 即将退出 Loop

实际上 RunLoop 内部就是一个 `do-while` 循环。当你调用 `CFRunLoopRun()` 时，线程就会一直停留在这个循环里，直到超时或手动停止，该函数才会返回。

默认的超时时间是一个巨大的数，可以理解为无穷大，也就是不会超时。

也可以看到，RunLoop 内部的事情也是有一个先后顺序的，当任务很繁重的时候，就可能会出现定时器不准的情况。

之前一直说 `do-while`，可能会有人担心如果一直是 `do-while`，那其实线程并没有停止下来，一直在等待。但其实 RunLoop 进入休眠所调用的函数是 `mach_msg()`，其内部会进行一个系统调用，然后内核会将线程置于等待状态，所以这是一个系统级别的休眠，不用担心 RunLoop 在休眠时会占用 CPU。

## RunLoop 的应用

### AutoreleasePool

有一个比较经典的题目是：自动释放池是什么时候开始释放的？

它的释放时机是和 RunLoop 有关的，前面提到过，RunLoop 有几种打工状态，苹果在主线程的 RunLoop 中注册了两个 Observer。

第一个 Observer，监听一个事件，就是 `Entry`，即将进入 Loop 的时候，创建一个自动释放池，并且给了一个最高的优先级，保证自动释放池的创建发生在其他回调之前，这是为了保证能管理所有的引用计数。

第二个 Observer，监听两个事件，一个 `BeforeWaiting`，一个 `Exit`，`BeforeWaiting` 的时候，干两件事，一个释放旧的池，然后创建一个新的池，所以这个时候，自动释放池就会有一次释放的操作，是在 RunLoop 即将进入休眠的时候。`Exit` 的时候，也释放自动释放池，这里也有一次释放的操作。

也就是：

1. 进入 RunLoop，先创建个自动释放池
2. RunLoop 要休息了，释放当前的自动释放池，搞个新的
3. RunLoop 要退出了，释放当前的自动释放池

### 触控事件的响应

苹果提前在 App 内注册了一个 Source1 来监听系统事件。

比如，当一个 触摸/锁屏/摇晃 之类的系统事情产生，系统会先包装，包装好了，通过 mach port 传输给需要的 App 进程，传输后，提前注册的 Source1 就会触发回调，然后由 App 内部再进行分发。

1. 注册一个 Source1 用于接收系统事件
2. 硬件事件发生
3. IOKit.framework 生成 IOHIDEvent 事件并由 SpringBoard 接收
4. SpringBoard 用 mach port 转发给需要的 App
5. 注册的 Source1 触发回调
6. 回调中奖 IOHIDEvent 包装成 UIEvent 进行处理或分发

![click.jpeg](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f4f2988d06884259be04b5d53917a05b~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

### 刷新界面

我们都知道改变 UI 的参数后，它并不会立马刷新。而它的刷新，也是通过 RunLoop 来实现。

当 UI 需要更新，先标记一个 dirty，然后提交到一个全局容器中去。然后，在 `BeforeWaiting` 和 `Exit` 时，会遍历这个容器，执行实际的绘制和调整，并更新 UI 界面。

### PerformSelector

当调用 `performSelector:afterDelay:` 时，其实内部会创建一个定时器，注册到当前线程的 RunLoop 中（如果当前线程没有 RunLoop，这个方法就会失效）。

有时候会看到 `afterDelay:0`，这样的作用是避免在当前的这个循环中执行，等下一次循环再执行。比方有时候会判断当前的 Mode 是否是 `Tracking` 或者 `Default`，为了避免判断错误，会使用 `afterDelay:0` 的方式将判断延迟到下一次 RunLoop 再执行。

### 其他

还有其他的应用可以看看 [深入理解RunLoop](https://link.juejin.cn?target=https%3A%2F%2Fblog.ibireme.com%2F2015%2F05%2F18%2Frunloop%2F)，或者直接上网搜一下，这里就不列举了。

## 实战

理解了原理之后，来解决一点实际的问题，UI 线程中，如果出现繁重的任务，就会导致界面卡顿，这类任务通常分为 3 类，排版、绘制、UI 对象操作。

排版通常是计算视图大小、计算文本高度、计算子视图的排版等，就是各种 layout 的计算。 绘制一般有文本绘制，图片绘制、元素绘制等。 UI 对象操作就是 UI 对象（如 UIView/CALayer）的创建、设置属性和销毁。

前两种操作我们可以通过各种方法放到异步线程执行，后面的那种只能在 UI 线程也就是主线程执行，但是我们可以尽量推迟执行的时间（如在 `BeforeWaiting` 或 `Exit` 时）。

一个比较能想到的方式就是，在 `BeforeWaiting` 和 `Exit` 时，这时候可以肯定用户没有在操作界面，RunLoop 是空闲的，在这个时间点去处理任务，用户是无法感知到的，所以我们可以自己实现一个监听，就监听这两个时间点，然后抛出一个回调，去处理我们的任务。

大家可以参考 YYKit 中的 [YYTranscation](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fibireme%2FYYKit%2Fblob%2F4e1bd1cfcdb3331244b219cbd37cc9b1ccb62b7a%2FYYKit%2FUtility%2FYYTransaction.m)，或者这个 [RunLoopWorkDistribution](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fdiwu%2FRunLoopWorkDistribution) 库。

核心思想就是监听主线程的 RunLoop，在 `DefaultMode` 的 `BeforeWaiting` 和 `Exit` 时，回调一个方法，然后我们可以将一些任务放到这个时候去执行。

### 参考

[深入理解RunLoop](https://link.juejin.cn?target=https%3A%2F%2Fblog.ibireme.com%2F2015%2F05%2F18%2Frunloop%2F)

[线下分享视频](https://link.juejin.cn?target=https%3A%2F%2Fv.youku.com%2Fv_show%2Fid_XODgxODkzODI0.html%3Fspm%3Da2h0c.8166622.PhoneSokuUgc_1.dtitle)



作者：_Terry
链接：https://juejin.cn/post/7166856920425299976
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。