package com.example.retrofitdemo.study

import android.util.Log
import com.example.retrofitdemo.Article
import com.example.retrofitdemo.TopArticle
import com.example.retrofitdemo.api.MyApi
import kotlinx.coroutines.*
import retrofit2.Call
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.Executors
import kotlin.coroutines.*

typealias Callback = (Article?) -> Unit

/// 协程调度篇
class SchedulerThree {

    private val tag = "tag"

    suspend inline fun Job.Key.currentJob() = coroutineContext[Job]

    suspend fun contextTest() {
        // 调度器本质上就是一个协程上下文的实现
        // 前面我们提到 launch 函数有三个参数，第一个参数叫 上下文，它的接口类型是 CoroutineContext，
        // 通常我们见到的上下文的类型是 CombinedContext 或者 EmptyCoroutineContext，一个表示上下文的组合，另一个表示什么都没有
        /*
            CoroutineContext	        List
            get(Key)	                get(Int)
            plus(CoroutineContext)	    plus(List)
            minusKey(Key)	            removeAt(Int)
         */
        // 简直就是一个以 Key 为索引的 List
        // 表中的 List.plus(List) 实际上指的是扩展方法 Collection<T>.plus(elements: Iterable<T>): List<T>

        // CoroutineContext 作为一个集合，它的元素就是源码中看到的 Element，每一个 Element 都有一个 key，
        // 因此它可以作为元素出现，同时它也是 CoroutineContext 的子接口，因此也可以作为集合出现。
        // CoroutineContext 原来是个数据结构啊。如果对于 List 的递归定义比较熟悉的话，那么对于 CombinedContext 和 EmptyCoroutineContext 也就很容易理解了

        GlobalScope.launch {
            Log.e(tag, "1- $coroutineContext[Job]")
        }
        Log.e(tag, "2- $coroutineContext[Job]")  // coroutineContext: 方法的协程体
        // 在协程体里面访问到的 coroutineContext 大多是这个 CombinedContext 类型，表示有很多具体的上下文实现的集合，
        // 我们如果想要找到某一个特别的上下文实现，就需要用对应的 Key 来查找

        // 仿照 Thread.currentThread() 来一个获取当前 Job 的方法
        GlobalScope.launch {
            Log.e(tag, "3- ${Job.currentJob()}")
        }
        Log.e(tag, "4- ${Job.currentJob()}")

        // 指定上下文为协程添加一些特性，一个很好的例子就是为协程添加名称，方便调试
        GlobalScope.launch(CoroutineName("banner")) {  }

        // 如果有多个上下文需要添加，直接用 + 就可以了
        // Dispatchers.Main 是调度器的一个实现
        GlobalScope.launch(Dispatchers.Main + CoroutineName("banner")) {  }
    }

    // 协程拦截器
    suspend fun interceptorTest(){

        // 拦截器也是一个上下文的实现方向，拦截器可以左右你的协程的执行，同时为了保证它的功能的正确性，协程上下文集合永远将它放在最后面，这真可谓是天选之子了
        // 它拦截协程的方法也很简单，因为协程的本质就是回调 + “黑魔法”，而这个回调就是被拦截的 Continuation 了。
        // 用过 OkHttp 的小伙伴一下就兴奋了，拦截器我常用的啊，OkHttp 用拦截器做缓存，打日志，还可以模拟请求，协程拦截器也是一样的道理。
        // 调度器就是基于拦截器实现的，换句话说调度器就是拦截器的一种

        // 可以自己定义一个拦截器放到我们的协程上下文中，看看会发生什么
        GlobalScope.launch(MyContinuationInterceptor()) {
            Log.e("<MyContinuation>", "1")
            // sync 启动了一个协程，async 与 launch 从功能上是同等类型的函数，它们都被称作协程的 Builder 函数，
            // 不同之处在于 async 启动的 Job 也就是实际上的 Deferred 可以有返回结果，可以通过 await 方法获取。
            val job = async {
                Log.e("<MyContinuation>", "2")
                delay(1000)
                Log.e("<MyContinuation>", "3")
                "hello"
            }
            Log.e("<MyContinuation>", "4")
            val result = job.await()
            Log.e("<MyContinuation>", "5 $result")
        }.join()
        Log.e("<MyContinuation>", "6")
    }

    // 调度器
    suspend fun schedulerTest() = suspendCoroutine<Article?> { continuation ->
        // 调度器本身是协程上下文的子类，同时实现了拦截器的接口， dispatch 方法会在拦截器的方法 interceptContinuation 中调用，进而实现协程的调度。
        // 所以如果我们想要实现自己的调度器，继承这个类就可以了，不过通常我们都用现成的，它们定义在 Dispatchers 当中
        /*
        	        Jvm	                    Js	        Native
        Default	    线程池	                主线程循环	主线程循环
        Main	    UI 线程	与 Default       相同	    与 Default 相同
        Unconfined	直接执行	                直接执行	    直接执行
        IO	        线程池	                --	        --
         */
        // IO 仅在 Jvm 上有定义，它基于 Default 调度器背后的线程池，并实现了独立的队列和限制，因此协程调度器从 Default 切换到 IO 并不会触发线程切换。
        // Main 主要用于 UI 相关程序，在 Jvm 上包括 Swing、JavaFx、Android，可将协程调度到各自的 UI 线程上。
        // Js 本身就是单线程的事件循环，与 Jvm 上的 UI 程序比较类似


        // sync 方法 转变成 协程方法
        // suspendCoroutine 这个方法并不是帮我们启动协程的，它运行在协程当中并且帮我们获取到当前协程的 Continuation 实例，
        // 也就是拿到回调，方便后面我们调用它的 resume 或者 resumeWithException 来返回结果或者抛出异常
        getArticle { article ->
            continuation.resume(article)
        }
    }

    private fun getArticle(callback: Callback) {
        serviceApi.getTopTree()
            .enqueue(object : retrofit2.Callback<TopArticle>{
                override fun onResponse(call: Call<TopArticle>, response: Response<TopArticle>) {
                    callback(response.body()?.data?.firstOrNull())
                }

                override fun onFailure(call: Call<TopArticle>, t: Throwable) {
                    Log.e(tag, "onFailure: ${t.message}")
                }
            })
    }

    // 绑定到任意线程的调度器
    suspend fun anyThreadBindTest() {
        // 调度器的目的就是切线程，你不要想着我在 dispatch 的时候根据自己的心情来随机调用，那你是在害你自己。
        // 那么问题就简单了，我们只要提供线程，调度器就应该很方便的创建出来
        val myDispatcher= Executors.newSingleThreadExecutor{ r -> Thread(r, "MyThread") }.asCoroutineDispatcher()
        GlobalScope.launch(myDispatcher) {
            Log.d(tag, "anyThreadBindTest: 1")
        }.join()

        Log.d(tag, "anyThreadBindTest: 2")

        // 由于这个线程池是我们自己创建的，因此我们需要在合适的时候关闭它
        myDispatcher.close()
    }

    suspend fun threadSafeQuestionTest() {
        // Js 和 Native 的并发模型与 Jvm 不同，Jvm 暴露了线程 API 给用户，这也使得协程的调度可以由用户更灵活的选择。
        // 越多的自由，意味着越多的代价，我们在 Jvm 上面编写协程代码时需要明白一点的是，线程安全问题在调度器不同的协程之间仍然存在。
        // 好的做法，尽量把自己的逻辑控制在一个线程之内，这样一方面节省了线程切换的开销，另一方面还可以避免线程安全问题，两全其美。
        // 如果大家在协程代码中使用锁之类的并发工具就反而增加了代码的复杂度，对此我的建议是大家在编写协程代码时尽量避免对外部作用域的可变变量进行引用，
        // 尽量使用参数传递而非对全局变量进行引用

        // 错误的例子
        var i = 0
        Executors.newFixedThreadPool(10).asCoroutineDispatcher()
            .use { dispatcher ->
                List(1000000) {
                    GlobalScope.launch(dispatcher) {
                        i++
                    }
                }.forEach {
                    it.join()
                }
            }
        Log.d(tag, "anyThreadBindTest: $i")
    }

    private val serviceApi: MyApi by lazy {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://www.wanandroid.com")
            .addConverterFactory(GsonConverterFactory.create())
            // 添加对 Deferred 的支持
            // .addCallAdapterFactory(CoroutineCallAdapterFactory())
            .build()
        retrofit.create(MyApi::class.java)
    }
}

/// 自定义 拦截器
class MyContinuationInterceptor : ContinuationInterceptor {

    override val key = ContinuationInterceptor

    override fun <T> interceptContinuation(continuation: Continuation<T>) = MyContinuation(continuation)
}

class MyContinuation<T>(val continuation: Continuation<T>): Continuation<T> {
    override val context: CoroutineContext = continuation.context

    override fun resumeWith(result: Result<T>) {
        Log.e("<MyContinuation>", "resumeWith: $result")
        continuation.resumeWith(result)
    }
}