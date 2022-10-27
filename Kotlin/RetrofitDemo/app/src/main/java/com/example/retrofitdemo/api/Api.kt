package com.example.retrofitdemo.api

import com.example.retrofitdemo.TopArticle
import kotlinx.coroutines.Deferred
import retrofit2.Call
import retrofit2.http.GET

interface MyApi {

    /// 常规网络请求
    @GET("/tree/json")
    fun getTopTree(): Call<TopArticle>

    // CallAdapter 协程。 Deferred 是 Job 的子接口
   @GET("/tree/json")
    fun getTopTree2(): Deferred<TopArticle>

    //suspend 函数的方式
    // 这种情况 Retrofit 会根据接口方法的声明来构造 Continuation，并且在内部封装了 Call 的异步请求（使用 enqueue），进而得到 实例
    @GET("/tree/json")
    suspend fun getTopTree3(): TopArticle

}