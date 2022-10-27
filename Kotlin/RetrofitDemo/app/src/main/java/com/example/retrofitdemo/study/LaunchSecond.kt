package com.example.retrofitdemo.study

import android.util.Log
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlin.concurrent.thread

//MARK: - 协程启动篇
class LaunchSecond {

    val tag = "LaunchSecond"

    fun thread_launch_java() {
        // Java
        val thread = object : Thread() {

            override fun run() {
                // doSomething
                Log.e(tag, "run: thread run")
            }
        }
        thread.start()
        // 忘了调用 start，还特别纳闷为啥我开的线程不启动呢。
        // 说实话，这个线程的 start 的设计其实是很奇怪的，不过我理解设计者们，毕竟当年还有 stop 可以用，结果他们很快发现设计 stop 就是一个错误，
        // 因为不安全而在 JDK 1.1 就废弃，称得上是最短命的 API 了吧。
    }

    fun thread_launch_kotlin() {

        // start: true 默认自动开启
        // isDaemon: 如果为true，线程将被创建为守护线程。当运行的所有线程都是守护线程时，Java虚拟机将退出。
        // contextClassLoader: 用于在此线程中装入类和资源的类装入器
        // name: 线程名称
        // priority: 优先级
        val thread = thread(start = true) {
            // doSomething
            Log.e(tag, "run: kotlin thread run")
        }

        // start: false 不自动开启。需要手动调用
        // thread.start()
    }

    fun coroutine_launch() {

        // 最简单的启动协程的方式
        // 启动协程需要三样东西，分别是 上下文、启动模式、协程体
        val job = GlobalScope.launch(start = CoroutineStart.DEFAULT) {
            //do what you want
        }

        // 启动模式
        // DEFAULT      : 立即执行协程体,
        // ATOMIC       : 立即执行协程体，但在开始运行之前无法取消
        // UNDISPATCHED : 立即在当前线程执行协程体，直到第一个 suspend 调用
        // LAZY         : 只有在需要的情况下运行
        /*
        四个启动模式当中我们最常用的其实是 DEFAULT 和 LAZY。
        DEFAULT 是饿汉式启动，launch 调用后，会立即进入待调度状态，一旦调度器 OK 就可以开始执行
        默认的启动模式，没有指定调度器，调度器也是默认的

        LAZY 是懒汉式启动，launch 后并不会有任何调度行为，协程体也自然不会进入执行状态，直到我们需要它执行的时候,launch 调用后会返回一个 Job 实例
            调用 Job.start，主动触发协程的调度执行
            调用 Job.join，隐式的触发协程的调度执行

        ATOMIC 只有涉及 cancel 的时候才有意义，cancel 本身也是一个值得详细讨论的话题，在这里我们就简单认为 cancel 后协程会被取消掉，也就是不再执行了。
        那么调用 cancel 的时机不同，结果也是有差异的，例如协程调度之前、开始调度但尚未执行、已经开始执行、执行完毕等等

        UNDISPATCHED 就很容易理解了。协程在这种模式下会直接开始在当前线程下执行，直到第一个挂起点，这听起来有点儿像前面的 ATOMIC，
        不同之处在于 UNDISPATCHED 不经过任何调度器即开始执行协程体。当然遇到挂起点之后的执行就取决于挂起点本身的逻辑以及上下文当中的调度器了。
         */

        // job.start()
    }

}