package com.example.retrofitdemo.study

import com.example.retrofitdemo.TopArticle
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.onReceiveOrNull
import kotlinx.coroutines.selects.select
import retrofit2.Response

class SelectTest {

    /*
    Select 并不是什么新鲜概念，我们在 IO 多路复用的时候就见过它，在 Java NIO 里面也见过它。接下来给各位介绍的是 Kotlin 协程的 Select。
     */

    //MARK: - 复用多个 await
    suspend fun test() {
        // 两个 API 分别从网络和本地缓存获取数据，期望哪个先返回就先用哪个做展示
        // 不管先调用哪个 API 返回的 Deferred 的 await，都会被挂起，如果想要实现这一需求就要启动两个协程来调用 await，这样反而将问题复杂化了。
        GlobalScope.launch {
            val localDeferred = getUserFromLocal("login")
            val remoteDeferred = getUserFromApi("login")

            val userResponse = select<Response<TopArticle>>{
                localDeferred.onAwait { it }
                remoteDeferred.onAwait { it }
            }

            // 如果先返回的是本地缓存，那么我们还需要获取网络结果来展示最新结果：
            userResponse.body()?.let { log(it) }
//            userResponse.isLocal.takeIf { it }?.let {
//                val userFromApi = remoteDeferred.await()
//                cacheUser(login, userFromApi)
//                log(userFromApi)
//            }
        }.join()

        // 没有直接调用 await，而是调用了 onAwait 在 select 当中注册了个回调，不管哪个先回调，select 立即返回对应回调中的结果。
        // 假设 localDeferred.onAwait 先返回，那么 userResponse 的值就是 Response(it, true)，当然由于我们的本地缓存可能不存在，
        // 因此 select 的结果类型是 Response<User?>
    }

    fun CoroutineScope.getUserFromApi(login: String) = async(Dispatchers.IO) {
            // gitHubServiceApi.getUserSuspend(login)
            // 网络请求
            Response.success(TopArticle(data = ArrayList(), errorCode = 200, errorMsg = ""))
        }

    fun CoroutineScope.getUserFromLocal(login:String) = async(Dispatchers.IO){
       // File(localDir, login).takeIf { it.exists() }?.readText()?.let { gson.fromJson(it, User::class.java) }
        // 写入文件
        Response.success(TopArticle(data = ArrayList(), errorCode = 200, errorMsg = ""))
    }

    //MARK: - 复用多个 Channel
    suspend fun test2() {
        // 对于多个 Channel 的情况，也比较类似
        val channels = List(10){ Channel<Int>() }

        select<Int?> {
            channels.forEach {
                it.onReceive{ it }
                // or
                // it.onReceiveOrNull( it )
            }
        }
        // 对于 onReceive，如果 Channel 被关闭，select 会直接抛出异常；而对于 onReceiveOrNull 如果遇到 Channel 被关闭的情况，it 的值就是 null
    }

    //MARK: - SelectClause
    suspend fun test3() {
        // 我们怎么知道哪些事件可以被 select 呢？其实所有能够被 select 的事件都是 SelectClauseN 类型

        // SelectClause0：对应事件没有返回值，例如 join 没有返回值，对应的 onJoin 就是这个类型，使用时 onJoin 的参数是一个无参函数
//        select<UInt> {
//            job.onJoind { log("join resumed") }
//        }

        // SelectClause1：对应事件有返回值，前面的 onAwait 和 onReceive 都是此类情况。
        //
        //SelectClause2：对应事件有返回值，此外还需要额外的一个参数，例如 Channel.onSend 有两个参数，第一个就是一个 Channel 数据类型的值，表示即将发送的值，第二个是发送成功时的回调：
        val channels = List(10){ Channel<Int>() }
        List(100) { element ->
            select<Unit> {
                channels.forEach { channel ->
                    channel.onSend(element) { sentChannel -> log("sent on $sentChannel") }
                }
            }
        }
        // 因此如果大家想要确认挂起函数是否支持 select，只需要查看其是否存在对应的 SelectClauseN 即可。
    }
}