package com.example.listviewdemo

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import androidx.viewpager2.widget.ViewPager2
import com.example.listviewdemo.adapter.HorizontalVpAdapter

class ViewPagerTwo: AppCompatActivity() {

    lateinit var viewpager2: ViewPager2
    private val pageControllers = ArrayList<Button>()
    init {
        print(123123)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.viewpagertwo);

        viewpager2 = findViewById(R.id.viewpager2)

        // 竖直滑动  或则 设置 水平滑动
//        viewpager2.orientation = ViewPager2.ORIENTATION_VERTICAL

        viewpager2.adapter = HorizontalVpAdapter(this)

        pageControllers.add(findViewById(R.id.rd_1))
        pageControllers.add(findViewById(R.id.rd_2))
        pageControllers.add(findViewById(R.id.rd_3))

        pageControllers.first().isSelected = true

        viewpager2.registerOnPageChangeCallback(object: ViewPager2.OnPageChangeCallback(){
            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {
                super.onPageScrolled(position, positionOffset, positionOffsetPixels)
            }

            override fun onPageScrollStateChanged(state: Int) {
                super.onPageScrollStateChanged(state)
            }

            override fun onPageSelected(position: Int) {
                Log.d("123", position.toString())
                for (index in pageControllers.indices) {
                    pageControllers[index].isSelected = index == position
                }
            }
        })
    }

}