package com.example.jetpackdemo.activity

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent

class LifecyclesTest: AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        /*
        在平时的开发任务中，可能需要在其他类中感知Activity 的生命周期，这通常要消耗一定的工作量，同时要在Activity中编写许多逻辑。
        Lifecycles的出现就优雅的解决了这个问题，Lifecycles组件的使用使得感知Activity生命周期的过程变得更加简洁

        获取LifecycleOwner实例。其实通常情况下实现LifecycleOwner的操作已经由AndroidX库自动帮我们完成了，
        Activity、Fragment本身就已经是LifecycleOwner 的实例，所以在MainActivity 当中就可以这样写
         */
        lifecycle.addObserver(MyObserver())
    }
}

/*
    使用方法
    新建一个MyObserver类，并让它实现LifecycleObserver接口
 */
class MyObserver: LifecycleObserver {

    /*
    使用@OnLifecycleEvent()注解，我们需要向注解传入一项代表生命周期事件类型的参数，
    这个参数有七种：ON_CREATE、ON_START、ON_RESUME、ON_PAUSE、ON_STOP和ON_DESTROY，参数名与Activity生命周期回调匹配，
    所以activityStart()和activityStop()方法就将分别在Activity 的onStart()和onStop()触发的时候执行。
    还有一种ON_ANY类型与Activity 的任何生命周期回调匹配
     */

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun activityStart() {
        Log.d("MyObserver", "activityStart")
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun activityStop() {
        Log.d("MyObserver", "activityStop")
    }
}