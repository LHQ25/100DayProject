package com.example.jetpackdemo.navigation

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Transformations
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

class MainViewModel(countReserved: Int): ViewModel() {

    private var userLiveData = MutableLiveData<User>()
    // map方法的作用是将实际包含数据的LiveData 和仅用于观察数据的LiveData 进行转换
    var userName: LiveData<String> = Transformations.map(userLiveData) {
        it.firstName + it.lastName
    }

    private var studentLiveData = MutableLiveData<Student>()
    // switchMap可以根据传入的LiveData的值去切换或创建新的LiveData，当ViewModel 中的某个LiveData 对象是通过调用另外的方法获取的时（
    // 比如我们有些数据需要依赖其他数据进行查询），我们可以使用switchMap()方法
    // 第一个参数传入我们新增的studentLiveData
    // 第二个参数是一个转换函数，我们再次编写转换逻辑
    val transformationsLiveData = Transformations.switchMap(studentLiveData) {
        if (it.scoreTAG) {
            MutableLiveData(it.englishScore)
        }else{
            MutableLiveData(it.mathScore)
        }
    }

    /*
    把原来的counter改成了一个包含Int型的MutableLiveData对象。
    MutableLiveData是一种可变的LiveData，它有3钟读写数据的方法，分别为getValue()、setValue()和postValue()，
    值得注意的是，postValue()方法用于在非主线程中给LiveData 设置数据，其他两个方法用于主线程。
    我们在initt结构体中用setValue()给counter设置数据，在plusOne()和clear()中对counter进行修改
     */
    private var _counter = MutableLiveData<Int>()
//    var counter: Int = countReserved

    // 隐藏真正的变量
    val counter: LiveData<Int>
        get() = _counter ////在counter的get方法中返回_counter变量

    init {
        _counter.value = countReserved
    }

    fun plusOne(){
        val count = _counter.value ?: 0
        _counter.value = count + 1
    }

    fun clear() {
        _counter.value = 0
    }

}

/*
ViewModelProvider.Factory接口要求我们必须实现create()方法，在create()方法中我们创建了带有已保存数值的MainViewModel实例
 */
class MainViewModelFactory(private val countReserved: Int): ViewModelProvider.Factory {

    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return MainViewModel(countReserved) as T
    }
}

data class User(val firstName: String, val lastName: String, val age: Int) {}

data class Student (var englishScore: Double, var mathScore: Double, val scoreTAG: Boolean)