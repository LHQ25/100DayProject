package com.example.retrofitdemo.study

import com.example.retrofitdemo.TopArticle
import com.example.retrofitdemo.api.MyApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.suspendCancellableCoroutine
import retrofit2.Call
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

// 协程取消篇
class CancelFive {

    fun test() {
        // runBlocking 启动协程，这个方法在 Native 上也存在，都是基于当前线程启动一个类似于 Android 的 Looper 的死循环，或者叫消息队列，
        // 可以不断的发送消息给它进行处理。runBlocking 会启动一个 Job，因此这里也存在默认的作用域
        runBlocking {

            val job1 = launch {
                log(1)
                try {
                    delay(1000)
                    log(2)
                } catch (e: Exception) {
                    log("Error $e")
                }

            }
            delay(100)
            log(3)
            job1.cancel()
            log(4)
        }
        /*
        ① 处启动了一个子协程，它内部先输出 1，接着开始 delay， delay 与线程的 sleep 不同，它不会阻塞线程，
        你可以认为它实际上就是触发了一个延时任务，告诉协程调度系统 1000ms 之后再来执行后面的这段代码（也就是 log(2)）；
        而在这期间，我们在 ③ 处对刚才启动的协程触发了取消，因此在 ② 处的 delay 还没有回调的时候协程就被取消了，
        因为 delay 可以响应取消，因此 delay 后面的代码就不会再次调度了，不调度的原因也很简单，② 处的 delay 会抛一个 CancellationException：
         */
    }

    // 改造获取数据的方法， 使用协程取消，省略 callback的回调
    private suspend fun getArticle() = suspendCancellableCoroutine<TopArticle> {  continuation ->

        continuation.invokeOnCancellation {
            log("invokeOnCancellation: cancel the request.")
            // 取消当前请求
        }

        serviceApi.getTopTree()
            .enqueue(object : retrofit2.Callback<TopArticle>{
                override fun onResponse(call: Call<TopArticle>, response: Response<TopArticle>) {
                    response.body()?.let {
                        continuation.resume(response.body()!!)
                    } ?: continuation.resumeWithException(NullPointerException())
                }

                override fun onFailure(call: Call<TopArticle>, t: Throwable) {
                    continuation.resumeWithException(t)
                }
            })
        /*
        suspendCancellableCoroutine，而不是之前的 suspendCoroutine，这就是为了让我们的挂起函数支持协程的取消。
        该方法将获取到的 Continuation 包装成了一个 CancellableContinuation，通过调用它的 invokeOnCancellation 方法可以设置一个取消事件的回调，
        一旦这个回调被调用，那么意味着 getUserCoroutine 调用所在的协程被取消了，这时候我们也要相应的做出取消的响应，也就是把 OkHttp 发出去的请求给取消掉。
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