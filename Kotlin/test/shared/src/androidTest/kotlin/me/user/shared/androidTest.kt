package me.user.shared

import androidx.appcompat.app.AppCompatActivity
import org.junit.Assert.assertTrue
import org.junit.Test

class AndroidGreetingTest {

    @Test
    fun testExample() {

        val a = 180
        print(abc())
    }

    fun abc(): Int {
        return 13;
    }
}

class BaseActivity: AppCompatActivity() {

    
}