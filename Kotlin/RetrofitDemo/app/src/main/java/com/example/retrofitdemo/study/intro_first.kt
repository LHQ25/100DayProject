package com.example.retrofitdemo.study

import android.util.Log
import com.example.retrofitdemo.TopArticle
import com.example.retrofitdemo.api.MyApi
import com.jakewharton.retrofit2.adapter.kotlin.coroutines.CoroutineCallAdapterFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class IntroFirst {

    fun normal() {
        // 常规写法
        serviceApi.getTopTree()
            .enqueue(object : Callback<TopArticle> {
                override fun onResponse(call: Call<TopArticle>, response: Response<TopArticle>) {
                    Log.e("f", "onResponse: ${response.body()}")
                }

                override fun onFailure(call: Call<TopArticle>, t: Throwable) {
                    Log.e("f", "onFailure: ${t.message}")
                }
            })
    }
    fun callAdapter_test() {
        // 通过 launch 启动了一个协程，这类似于我们启动一个线程，launch 的参数有三个，依次为协程上下文、协程启动模式、协程体
//            // 上下文可以有很多作用，包括携带参数，拦截协程执行等等，多数情况下我们不需要自己去实现上下文，只需要使用现成的就好。上下文有一个重要的作用就是线程切换，Dispatchers.Main 就是一个官方提供的上下文，它可以确保 launch 启动的协程体运行在 UI 线程当中（除非你自己在 launch 的协程体内部进行线程切换、或者启动运行在其他有线程切换能力的上下文的协程）。
            GlobalScope.launch(Dispatchers.Main) {
                try {
                    val data = serviceApi.getTopTree2().await()
                    Log.e("f", "onFailure: $data" )
                } catch (e: java.lang.Exception) {
                    Log.e("f", "onFailure: ${e.message}" )
                }
            }
    }

    fun suspend_test(){
        GlobalScope.launch {
            try {
                val data = serviceApi.getTopTree3()
                Log.e("ff", "onFailure: $data" )
            } catch (e: java.lang.Exception) {
                Log.e("ff", "onFailure2: ${e.message}" )
            }
        }
    }

    private val serviceApi: MyApi by lazy {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://www.wanandroid.com")
            .addConverterFactory(GsonConverterFactory.create())
            //添加对 Deferred 的支持
            .addCallAdapterFactory(CoroutineCallAdapterFactory())
            .build()
        retrofit.create(MyApi::class.java)
    }
}