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
import kotlin.coroutines.CoroutineContext
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

interface ApiCallback<T>{
    fun onSuccess(value: T)
    fun onError(t: Throwable)
}

/*
    协程内部异常处理流程：launch 会在内部出现未捕获的异常时尝试触发对父协程的取消，能否取消要看作用域的定义，
        如果取消成功，那么异常传递给父协程，否则传递给启动时上下文中配置的 CoroutineExceptionHandler 中，
        如果没有配置，会查找全局（JVM上）的 CoroutineExceptionHandler 进行处理，如果仍然没有，那么就将异常交给当前线程的 UncaughtExceptionHandler 处理；
        而 async 则在未捕获的异常出现时同样会尝试取消父协程，但不管是否能够取消成功都不会后其他后续的异常处理，直到用户主动调用 await 时将异常抛出。
    异常在作用域内的传播：当协程出现异常时，会根据当前作用域触发异常传递，GlobalScope 会创建一个独立的作用域，所谓“自成一派”，
        而 在 coroutineScope 当中协程异常会触发父协程的取消，进而将整个协程作用域取消掉，如果对 coroutineScope 整体进行捕获，也可以捕获到该异常，所谓“一损俱损”；
        如果是 supervisorScope，那么子协程的异常不会向上传递，所谓“自作自受”。
    join 和 await 的不同：join 只关心协程是否执行完，await 则关心运行的结果，因此 join 在协程出现异常时也不会抛出该异常，而 await 则会；考虑到作用域的问题，
        如果协程抛异常，可能会导致父协程的取消，因此调用 join 时尽管不会对协程本身的异常进行抛出，但如果 join 调用所在的协程被取消，那么它会抛出取消异常。
 */

class ExceptionHandlerFour {

    // 异常处理逻辑
    suspend fun exceotionTest() = suspendCoroutine<TopArticle?> { continuation ->
        getArticle(object : ApiCallback<TopArticle?>{
            override fun onSuccess(value: TopArticle?) {
                // 返回正确的值
                continuation.resume(value)
            }
            override fun onError(t: Throwable) {
                // 抛出异常
                continuation.resumeWithException(t)
            }
        })
    }

    // 获取数据
    private fun getArticle(callback: ApiCallback<TopArticle?>) {
        serviceApi.getTopTree()
            .enqueue(object : retrofit2.Callback<TopArticle>{
                override fun onResponse(call: Call<TopArticle>, response: Response<TopArticle>) {
                    if (response.body()?.data?.firstOrNull() != null) {
                        callback.onSuccess(response.body())
                    }else{
                        callback.onError(Exception())
                    }
                }

                override fun onFailure(call: Call<TopArticle>, t: Throwable) {
                    callback.onError(t)
                }
            })
    }

    //MARK: - 全局异常处理
    suspend fun globalExceptionHandler() {

        // 线程也好、RxJava 也好，都有全局处理异常的方式
//        Thread.setDefaultUncaughtExceptionHandler { t, e ->
//            //handle exception here
//            println("Thread '${t.name}' throws an exception with message '${e.message}'")
//        }
//
//        throw  java.lang.ArithmeticException("Error Hey!!")

        // 类似于通过 Thread.setUncaughtExceptionHandler 为线程设置一个异常捕获器，
        // 我们也可以为每一个协程单独设置 CoroutineExceptionHandler，这样协程内部未捕获的异常就可以通过它来捕获
        val exceptionHandler = CoroutineExceptionHandler { coroutineContext, throwable ->
            Log.e("Error","Throws an exception with message: ${throwable.message}")
        }
        Log.e("error","1")
        GlobalScope.launch(exceptionHandler) {
            throw ArithmeticException("Hey!")
        }.join()
        Log.e("error","2")

        // 并不算是一个全局的异常捕获，因为它只能捕获对应协程内未捕获的异常，
        // 如果你想做到真正的全局捕获，在 Jvm 上我们可以自己定义一个捕获类实现
    }

    //MARK: - 异常传播
    suspend fun exceptionScopeTest(){
        // 异常传播还涉及到协程作用域的概念，
        // 例如我们启动协程的时候一直都是用的 GlobalScope，意味着这是一个独立的顶级协程作用域，
        // 此外还有 coroutineScope { ... } 以及 supervisorScope { ... }。

        // 通过 GlobeScope 启动的协程单独启动一个协程作用域，内部的子协程遵从默认的作用域规则。
        //      通过 GlobeScope 启动的协程“自成一派”。
        // coroutineScope 是继承外部 Job 的上下文创建作用域，在其内部的取消操作是双向传播的，子协程未捕获的异常也会向上传递给父协程。
        //      它更适合一系列对等的协程并发的完成一项工作，任何一个子协程异常退出，那么整体都将退出，简单来说就是”一损俱损“。这也是协程内部再启动子协程的默认作用域。
        // supervisorScope 同样继承外部作用域的上下文，但其内部的取消操作是单向传播的，父协程向子协程传播，反过来则不然，这意味着子协程出了异常并不会影响父协程以及其他兄弟协程。
        //      它更适合一些独立不相干的任务，任何一个任务出问题，并不会影响其他任务的工作，简单来说就是”自作自受“，例如 UI，我点击一个按钮出了异常，其实并不会影响手机状态栏的刷新。需要注意的是，supervisorScope 内部启动的子协程内部再启动子协程，如无明确指出，则遵守默认作用域规则，也即 supervisorScope 只作用域其直接子协程。

        log(1)
        try {
            coroutineScope {
                log(2)
                launch {
                    log(3)
                    launch {
                        log(4)
                        delay(1000)
                        throw  ArithmeticException("Hey!!") // 抛出异常 转到12 同时取消 当前的整个协程导致 10 被触发
                    }
                    log(5)
                }
                log(6)
                val job = launch {
                    log(7)
                    delay(1000)
                }
                try {
                    log(8)
                    job.join()
                    log(9)
                }catch (e: java.lang.Exception) {
                    log("10 ${e.message}")
                }
            }
            log(11)
        } catch (e: Exception) {
            log("12 $e")
        }
//        1 2 6 3 4 8 7 5 12 9
        log(13)

        /*
        究竟使用什么 Scope，大家自己根据实际情况来确定，我给出一些建议：

        对于没有协程作用域，但需要启动协程的时候，适合用 GlobalScope
        对于已经有协程作用域的情况（例如通过 GlobalScope 启动的协程体内），直接用协程启动器启动
        对于明确要求子协程之间相互独立不干扰时，使用 supervisorScope
        对于通过标准库 API 创建的协程，这样的协程比较底层，没有 Job、作用域等概念的支撑，
                例如我们前面提到过 suspend main 就是这种情况，对于这种情况优先考虑通过 coroutineScope 创建作用域；
                更进一步，大家尽量不要直接使用标准库 API，除非你对 Kotlin 的协程机制非常熟悉。
         */
    }

    //MARK: - join 和 await
    suspend fun joinTest() {
        // 启动协程其实常用的还有 async、actor 和 produce，
        // 其中 actor 和 launch 的行为类似，在未捕获的异常出现以后，会被当做为处理的异常抛出，就像前面的例子那样。
        // 而 async 和 produce 则主要是用来输出结果的，他们内部的异常只在外部消费他们的结果时抛出。
        // 这两组协程的启动器，你也可以认为分别是“消费者”和“生产者”，消费者异常立即抛出，生产者只有结果消费时抛出异常
        val deferred = GlobalScope.async<Int> {
            throw ArithmeticException()
        }

        // 那么消费结果指的是什么呢？对于 async 来讲，就是 await

        try {
            val value = deferred.await()
            log("1 $value")
        }catch (e: Exception) {
            log("2 $e")  // 异常
        }
        // 调用 await 时，期望 deferred 能够给我们提供一个合适的结果，但它因为出异常，没有办法做到这一点，因此只好给我们丢出一个异常

        // 相比之下，join 就有趣的多了，它只关注是否执行完，至于是因为什么完成，它不关心，因此如果我们在这里替换成 join
        try {
            val value = deferred.join()
            log("3 $value") // 执行 结果，异常被抹除了
        }catch (e: Exception) {
            log("4 $e")
        }

        /*
            当用 launch 替换 async，join 处仍然不会有任何异常抛出，
            还是那句话，它只关心有没有完成，至于怎么完成的它不关心。
            不同之处在于， launch 中未捕获的异常与 async 的处理方式不同，launch 会直接抛出给父协程，
            如果没有父协程（顶级作用域中）或者处于 supervisorScope 中父协程不响应，那么就交给上下文中指定的 CoroutineExceptionHandler处理，
            如果没有指定，那传给全局的 CoroutineExceptionHandler 等等，而 async 则要等 await 来消费。
         */
    }

    private val serviceApi: MyApi by lazy {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://www.wanandroid1.com")
            .addConverterFactory(GsonConverterFactory.create())
            // 添加对 Deferred 的支持
            // .addCallAdapterFactory(CoroutineCallAdapterFactory())
            .build()
        retrofit.create(MyApi::class.java)
    }

}

fun log(value: Any) = Log.e("Info", "$value")