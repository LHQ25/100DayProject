package com.example.retrofitdemo.study


/* 序列生成器篇 */
class SequenceSeven {

    fun test(){
        val fibonacci = sequence {
            yield(1L)
            var cur = 1L
            var next = 1L
            while (true) {
                yield(next)
                val tmp = cur + next
                cur = next
                next = tmp
            }
        }

        fibonacci.take(5).forEach(::log)
        // 这个 sequence 实际上也是启动了一个协程，yield 则是一个挂起点，
        // 每次调用时先将参数保存起来作为生成的序列迭代器的下一个值，之后返回 COROUTINE_SUSPENDED，这样协程就不再继续执行，而是等待下一次 resume 或者 resumeWithException 的调用，
        // 而实际上，这下一次的调用就在生成的序列的迭代器的 next() 调用时执行。
        // 如此一来，外部在遍历序列时，每次需要读取新值时，协程内部就会执行到下一次 yield 调用
    }

    fun test2(){
        val fibonacci = sequence {
            log("yield 1,2,3")
            yieldAll(listOf(1, 2, 3))
            log("yield 4,5,6")
            yieldAll(listOf(4, 5, 6))
            log("yield 7,8,9")
            yieldAll(listOf(7, 8, 9))
        }

        fibonacci.take(5).forEach(::log)
        // 除了使用 yield(T) 生成序列的下一个元素以外，我们还可以用 yieldAll() 来生成多个元素

    }

    //MARK: - 深入序列生成器
    // 已经不止一次提到 COROUTINE_SUSPENDED 了，我们也很容易就知道 yield 和 yieldAll 都是 suspend 函数，
    // 既然能做到”懒“，那么必然在 yield 和 yieldAll 处是挂起的，因此它们的返回值一定是 COROUTINE_SUSPENDED


}