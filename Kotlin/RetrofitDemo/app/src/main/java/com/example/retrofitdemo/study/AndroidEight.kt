package com.example.retrofitdemo.study

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.example.retrofitdemo.R
import kotlinx.coroutines.*

class AndroidEight {
    // 配置依赖
    // 如果在 Android 上做开发，那么我们需要引入
    // implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:$kotlin_coroutine_version'
    // 这个框架里面包含了 Android 专属的 Dispatcher，我们可以通过 Dispatchers.Main 来拿到这个实例；也包含了 MainScope，用于与 Android 作用域相结合
    // kotlinx-coroutines-android 这个框架是必选项，主要提供了专属调度器


    //MARK: - 谨慎使用 GlobalScope
    // lobalScope 存在什么问题
    // 之前做例子经常使用 GlobalScope，但 GlobalScope 不会继承外部作用域，因此大家使用时一定要注意，如果在使用了绑定生命周期的 MainScope 之后，
    // 内部再使用 GlobalScope 启动协程，意味着 MainScope 就不会起到应有的作用。
}

//MARK: - 体现1
class CoroutineActivity : AppCompatActivity() {

    private lateinit var button: Button
    private lateinit var textView: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        button = findViewById(R.id.button)
        textView = findViewById(R.id.textview)
    }

    //MARK: - UI 生命周期作用域
    // Android 开发经常想到的一点就是让发出去的请求能够在当前 UI 或者 Activity 退出或者销毁的时候能够自动取消
    // 使用 MainScope
    // 协程有一个很天然的特性能刚够支持这一点，那就是作用域。官方也提供了 MainScope 这个函数，我们具体看下它的使用方法：
    fun netWorkTest() {

        val mainScope = MainScope()

        button.setOnClickListener {
            mainScope.launch {
                log(1)
                textView.text = async(Dispatchers.IO) {
                    log(2)
                    delay(1000)
                    log(3)
                    "hello"
                }.await()
                log(4)
            }
        }

        // mainScope.cancel() // 在触发前面的操作之后立即在其他位置触发作用域的取消，那么该作用域内的协程将不再继续执行


        // 其实与其他的 CoroutineScope 用起来没什么不一样的地方，通过同一个叫 mainScope 的实例启动的协程，都会遵循它的作用域定义，
        // 原来就是 SupervisorJob 整合了 Dispatchers.Main 而已，它的异常传播是自上而下的，这一点与 supervisorScope 的行为一致，
        // 此外，作用域内的调度是基于 Android 主线程的调度器的，因此作用域内除非明确声明调度器，协程体都调度在主线程执行
    }
}

//MARK: - 体现2
// 构造带有作用域的抽象 Activity
//尽管我们前面体验了 MainScope 发现它可以很方便的控制所有它范围内的协程的取消，以及能够无缝将异步任务切回主线程，这都是我们想要的特性，不过写法上还是不够美观。
//官方推荐我们定义一个抽象的 Activity
// 在 Activity 退出的时候，对应的作用域就会被取消，所有在该 Activity 中发起的请求都会被取消掉
//class MyScopedActivity: ScopedActivity() {
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//    }
//}