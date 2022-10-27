package com.example.jetpackdemo.activity

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import com.example.jetpackdemo.R
import com.example.jetpackdemo.databinding.ActivityMainBinding
import com.example.jetpackdemo.navigation.MainViewModel

class ViewModelTest : AppCompatActivity() {

    private lateinit var viewModel: MainViewModel
    private var binding = ActivityMainBinding.inflate(layoutInflater)

    private lateinit var textView: TextView
    private lateinit var addButton: Button
    private lateinit var clearButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        textView = findViewById(R.id.counterView)
        addButton = findViewById(R.id.add)
        clearButton = findViewById(R.id.clear)


        /**
        通过ViewModelProvider 来获取ViewModel 的实例
        * 因为ViewModel 有其独立的生命周期，并且其生命周期要长于Activity 。
        如果我们在onCreate()方法中创建ViewModel 的实例，那么每次onCreate()方法执行的时
        候，ViewModel 都会创建一个新的实例，这样当手机屏幕发生旋转的时候，就无法保留其中的
        数据了
        */
        addButton.setOnClickListener {
            viewModel.plusOne()
        }

        clearButton.setOnClickListener {
            viewModel.clear()
        }

        // LiveData对象可以调用它的observe()方法观察数据的变化
        // 第一个参数是一个LifecycleOwner对象，Activity 本身就是一个LifecycleOwner对象，这里我们直接传this
        // 第二个参数是一个Observer接口，当counter中的数据发生变化时，就会回调到这里，我们在这里更新UI
        viewModel.counter.observe(this, Observer {
            binding.counterView.text = it.toString()
        })

        /*
        如果想要重启程序后不会丢失数据，就需要在退出程序的时候对当前的计数进行保存，然后在重新打开程序的时候读取之前保存的计数，并传递给MainViewModel。
        要将参数传递到ViewModel需要借助ViewModelProvider.Factory实现
         */

        /*
        LiveData是响应式编程组件，当底层数据发生变化时，LiveData 会通知Observer对象，我们可以在Observer对象中编写更新UI的代码，
        意思就是，当LiveData发生变化时，UI会收到新数据并重绘。且与一般的遵循观察者模式的组件不同，LiveData还具有生命周期感知能力
         */
    }
}