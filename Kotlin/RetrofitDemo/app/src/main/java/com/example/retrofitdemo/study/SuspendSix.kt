package com.example.retrofitdemo.study

import kotlinx.coroutines.disposeOnCancellation
import kotlinx.coroutines.suspendCancellableCoroutine

// 协程挂起篇
class SuspendSix {

    fun delayTest() {
        // 刚刚学线程的时候，最常见的模拟各种延时用的就是 Thread.sleep 了，而在协程里面，对应的就是 delay。
        // sleep 让线程进入休眠状态，直到指定时间之后某种信号或者条件到达，线程就尝试恢复执行，
        // 而 delay 会让协程挂起，这个过程并不会阻塞 CPU，甚至可以说从硬件使用效率上来讲是“什么都不耽误”，从这个意义上讲 delay 也可以是让协程休眠的一种很好的手段

        /*
        delay 的源码其实很简单：
        public suspend fun delay(timeMillis: Long) {
            if (timeMillis <= 0) return // don't delay
                return suspendCancellableCoroutine sc@ { cont: CancellableContinuation<Unit> ->
                cont.context.delay.scheduleResumeAfterDelay(timeMillis, cont)
            }
    }
         */
        // cont.context.delay.scheduleResumeAfterDelay 这个操作，你可以类比 JavaScript 的 setTimeout，Android 的 handler.postDelay，
        // 本质上就是设置了一个延时回调，时间一到就调用 cont 的 resume 系列方法让协程继续执行。

        //剩下的最关键的就是 suspendCancellableCoroutine 了，这可是我们的老朋友了，前面我们用它实现了回调到协程的各种转换 —— 原来 delay 也是基于它实现的，
        // 如果我们再多看一些源码，你就会发现类似的还有 join、await 等等
    }

    //MARK: - 再来说说 suspendCancellableCoroutine
    private suspend fun joinSuspend() = suspendCancellableCoroutine<UInt> { continuation ->

        // Job.join() 这个方法会首先检查调用者 Job 的状态是否已经完成，
        // 如果是，就直接返回并继续执行后面的代码而不再挂起，否则就会走到这个 joinSuspend 的分支当中。
        // 我们看到这里只是注册了一个完成时的回调，
        // 那么传说中的 suspendCancellableCoroutine 内部究竟做了什么呢？

        // suspendCoroutineUninterceptedOrReturn 这个方法调用的源码是看不到的，
        // 因为它根本没有源码：P 它的逻辑就是帮大家拿到 Continuation 实例，真的就只有这样。
        // 不过这样说起来还是很抽象，因为有一处非常的可疑：suspendCoroutineUninterceptedOrReturn 的返回值类型是 T，而传入的 lambda 的返回值类型是 Any?，
        // 也就是我们看到的 cancellable.getResult() 的类型是 Any?

        // 对于 suspend 函数，不是一定要挂起的，可以在需要的时候挂起，也就是要等待的协程还没有执行完的时候，等待协程执行完再继续执行；
        // 而如果在开始 join 或者 await 或者其他 suspend 函数，如果目标协程已经完成，那么就没必要等了，直接拿着结果走人即可。
        // 那么这个神奇的逻辑就在于 cancellable.getResult()
    }

    //MARK: - 深入挂起操作
//    suspend fun hello() = suspendCoroutineUninterceptedOrReturn<Int>{
//
//    }
}