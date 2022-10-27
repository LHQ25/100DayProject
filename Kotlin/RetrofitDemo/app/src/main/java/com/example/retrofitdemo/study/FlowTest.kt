package com.example.retrofitdemo.study

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

/* Flow 就是 Kotlin 协程与响应式编程模型结合的产物，你会发现它与 RxJava 非常像，二者之间也有相互转换的 API，使用起来非常方便。 */
class FlowTest {

    @OptIn(InternalCoroutinesApi::class)
    suspend fun test() {
        // 认识一下 Flow 了。它的 API 与序列生成器极为相似：

        val intFlow = flow {
            (1..3).forEach {
                emit(it) // 新元素通过 emit 函数提供，Flow 的执行体内部也可以调用其他挂起函数，这样我们就可以在每次提供一个新元素后再延时 100ms 了
                delay(1000)
            }
        }
        // Flow 也可以设定它运行时所使用的调度器：
        // intFlow.flowOn(Dispatchers.IO)
        // 通过 flowOn 设置的调度器只对它之前的操作有影响，因此这里意味着 intFlow 的构造逻辑会在 IO 调度器上执行。
        // 最终消费 intFlow 需要调用 collect 函数，这个函数也是一个挂起函数，我们启动一个协程来消费 intFlow：

        // 消费 Flow
        GlobalScope.launch(Dispatchers.Main) {
            intFlow.flowOn(Dispatchers.IO)
            // 调用
        }.join()
    }

}