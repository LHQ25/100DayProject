package com.example.retrofitdemo

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.example.retrofitdemo.study.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    private lateinit var button: Button
    private lateinit var textView: TextView

    /// 入门篇
    private val first = IntroFirst()

    /// 协程启动篇
    private  val second = LaunchSecond()

    /// 协程调度篇
    private  val three = SchedulerThree()

    /// 异常处理
    private  val four = ExceptionHandlerFour()

    /// 协程取消篇
    private val  five = CancelFive()

    /// 协程挂起篇
    private val six = SuspendSix()

    /// 序列生成器篇
    private val seven = SequenceSeven()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        button = findViewById(R.id.button)
        textView = findViewById(R.id.textview)

        button.setOnClickListener {

//            first.normal()
//            first.callAdapter_test()
//            first.suspend_test()

            seven.test2()
//            GlobalScope.launch(Dispatchers.Main) {
//                four.joinTest()
//            }
        }

    }
}