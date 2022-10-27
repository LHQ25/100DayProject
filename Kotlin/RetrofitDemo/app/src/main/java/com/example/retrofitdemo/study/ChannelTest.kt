package com.example.retrofitdemo.study

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.actor
import kotlinx.coroutines.channels.broadcast
import kotlinx.coroutines.channels.produce
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.logging.Logger

/* Channel 实际上就是一个队列，而且是并发安全的，它可以用来连接协程，实现不同协程的通信 */
class ChannelTest {

    suspend fun test(){

        // 参数叫 capacity，指定缓冲区的容量，默认值 RENDEZVOUS 就是 0，这个词本意就是描述“不见不散”的场景，所以你不来 receive，我这 send 就一直搁这儿挂起等着
        // 1 : 比较好理解，来者不拒, 没有限制
        // 2 : 这个类型的 Channel 有一个元素大小的缓冲区，但每次有新元素过来，都会用新的替换旧的，也就是说我发了个 1、2、3、4、5 之后收端才接收的话，就只能收到 5 了
        // 其它 :  它接收一个值作为缓冲区容量的大小
        val channel = Channel<Int>(capacity = 0)

        val producer = GlobalScope.launch {
            var i = 0
            while (true) {
                channel.send(i++)
                delay(1000)
            }
        }

        val consumer = GlobalScope.launch {
            while (true) {
                val element = channel.receive()
                log(element)
            }
        }

        producer.join()
        consumer.join()

        // 构造了两个协程，分别叫他们 producer 和 consumer，
        // 我们没有明确的指定调度器，所以他们的调度器都是默认的，
        // 在 Java 虚拟机上就是那个大家都很熟悉的线程池：他们可以运行在不同的线程上，当然也可以运行在同一个线程上。
        //
        //例子的运行机制是，producer 当中每隔 1s 向 Channel 中发送一个数字，而 consumer 那边则是一直在读取 Channel 来获取这个数字并打印，
        // 我们能够发现这里发端是比收端慢的，在没有值可以读到的时候，receive 是挂起的，直到有新元素 send 过来
        // 所以你知道了 receive 是一个挂起函数，那么 send 呢？
    }

    //MARK: - 迭代 Channel
    fun test2() {
        val channel = Channel<Int>(capacity = 0)
        // 发送和读取 Channel 的时候用了 while(true)，因为我们想要去不断的进行读写操作，Channel 本身实际上也有点儿像序列，
        // 可以一个一个读，所以我们在读取的时候也可以直接获取一个 Channel 的 iterator
        val consumer = GlobalScope.launch {
            val iterator = channel.iterator()
            while (iterator.hasNext()) {  // 那么这个时候，iterator.hasNext() 是挂起函数，在判断是否有下一个元素的时候实际上就需要去 Channel 当中读取元素了
                val element = iterator.next()
                log(element)
                delay(2000)
            }
        }
    }

    //MARK: - produce 和 actor
    fun test3() {
        // 在协程外部定义 Channel，并在协程当中访问它，实现了一个简单的生产-消费者的示例，那么有没有便捷的办法构造生产者 和消费者呢？
        val receiveChannel = GlobalScope.produce {
            while (true) {
                delay(1000)
                send(2)
            }
        }
        // 通过 produce 这个方法启动一个生产者协程，并返回一个 ReceiveChannel，其他协程就可以拿着这个 Channel 来接收数据了。
        // 反过来，我们可以用 actor 启动一个消费者协程

        val sendChannel = GlobalScope.actor<Int> {
            while (true) {
                val element = receive()
            }
        }

        // produce 和 actor 与 launch 一样都被称作“协程启动器”。
        // 通过这两个协程的启动器启动的协程也自然的与返回的 Channel 绑定到了一起，因此 Channel 的关闭也会在协程结束时自动完成

        /*
        这样看上去还是挺有用的。
        不过截止这俩 API produce 和 actor 目前都没有稳定，前者仍被标记为 ExperimentalCoroutinesApi，后者则标记为 ObsoleteCoroutinesApi，
        这就比较尴尬了，明摆着不让用嘛。actor 的文档中提到的 issue 的讨论也说明相比基于 Actor 模型的并发框架，
        Kotlin 协程提供的这个 actor API 也不过就是提供了一个 SendChannel 的返回值而已。
        当然，协程的负责人也有实现一套更复杂的 Actor 的想法，只是这一段时间的高优明显是 Flow——这货从协程框架的 v1.2 开始公测，
        到协程 v1.3 就稳定，真是神速，我们后面的文章会介绍它。

        虽然 produce 没有被标记为 ObsoleteCoroutinesApi，显然它作为 actor 的另一半，不可能单独转正的，这俩 API 我的建议是看看就好了
         */
    }

    //MARK: - Channel 的关闭
    fun test4(){
        // 前提到了 produce 和 actor 返回的 Channel 都会伴随着对应的协程执行完毕而关闭。Channel 还有一个关闭的概念。
        //Channel 和我们后面的文章即将要探讨的 Flow 不同，它是在线的，是一个热数据源，换句话说就是有想要收数据，就要有人在对面给他发，就像发微信一样。
        // 既然这样，就难免曲终人散，对于一个 Channel，如果我们调用了它的 close，它会立即停止接受新元素，也就是说这时候它的 isClosedForSend 会立即返回 true，
        // 而由于 Channel 缓冲区的存在，这时候可能还有一些元素没有被处理完，所以要等所有的元素都被读取之后 isClosedForReceive 才会返回 true
        val channel = Channel<Int>(3)

        val producer = GlobalScope.launch {
            List(5){
                channel.send(it)
                log("send $it")
            }
            channel.close()
            log("close channel. ClosedForSend = ${channel.isClosedForSend} ClosedForReceive = ${channel.isClosedForReceive}")
        }

        val consumer = GlobalScope.launch {
            for (element in channel) {
                log("receive: $element")
                delay(1000)
            }

            log("After Consuming. ClosedForSend = ${channel.isClosedForSend} ClosedForReceive = ${channel.isClosedForReceive}")
        }

        // 一说起关闭，我们就容易想到 IO，如果不关闭可能造成资源泄露，那么 Channel 的关闭是个什么概念呢？
        // 我们前面提到过，Channel 其实内部的资源就是个缓冲区，这个东西本质上就是个线性表，就是一块儿内存，所以如果我们开了一个 Channel 而不去关闭它，
        // 其实也不会造成什么资源泄露，发端如果自己已经发完，它就可以不理会这个 Channel 了
        // 这时候在接收端就比较尴尬了，它不知道会不会有数据发过来，如果 Channel 是微信，那么接收端打开微信的窗口可能一直看到的是『对方正在输入』，
        // 然后它就一直这样了，孤独终老。所以这里的关闭更多像是一种约定

        // 那么 Channel 的关闭究竟应该有谁来处理呢？正常的通信，如果是单向的，就好比领导讲话，讲完都会说『我讲完了』，
        // 你不能在领导还没讲完的时候就说『我听完了』，所以单向通信的情况比较推荐由发端处理关闭；
        // 而对于双向通信的情况，就要考虑协商了，双向通信从技术上两端是对等的，但业务场景下通常来说不是，建议由主导的一方处理关闭。
    }

    //MARK: - BroadcastChannel
    suspend fun test5() {

//        val broadcastChannel = broadcastChannel<Int>()
        // 除了直接创建以外，我们也可以直接用前面定义的普通的 Channel 来做个转换：
        val channel = Channel<Int>()
        val broadcast = channel.broadcast(3) // 参数表示缓冲区的大小。

        val producer = GlobalScope.launch {
            List(5) {
                channel.send(it)
                log("send $it")
            }
            channel.close()
        }

        List(3) {
            GlobalScope.launch {
                val receiveChannel = broadcast.openSubscription()
                for (element in receiveChannel) {
                    log("$it receive $element")
                    delay(1000)
                }
            }
        }.forEach {
            it.join()
        }

        producer.join()
    }

    //MARK: - Channel 版本的序列生成器
    suspend fun test6() {
        // Sequence，它的生成器是基于标准库的协程的 API 实现的，实际上 Channel 本身也可以用来生成序列
        val channel = GlobalScope.produce(Dispatchers.Unconfined) {
            log("A")
            send(1)
            log("B")
            send(2)
            log("Done")
        }

        for (item in channel) {
            log("$item")
        }
        // produce 创建的协程返回了一个缓冲区大小为 0 的 Channel，
        // 为了问题描述起来比较容易，我们传入了一个 Dispatchers.Unconfined 调度器，
        // 意味着协程会立即在当前协程执行到第一个挂起点，所以会立即输出 A 并在 send(1) 处挂起，
        // 直到后面的 for 循环读到第一个值时，实际上就是 channel 的 iterator 的 hasNext 方法的调用，
        // 这个 hasNext 方法会检查是否有下一个元素，是一个挂起函数，在检查的过程中就会让前面启动的协程从 send(1) 挂起的位置继续执行，
        // 因此会看到日志 B 输出，然后再挂起到 send(2) 这里，这时候 hasNext 结束挂起，for 循环终于输出第一个元素，依次类推
    }
}