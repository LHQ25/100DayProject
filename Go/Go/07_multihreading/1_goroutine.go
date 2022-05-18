package main

import (
	"fmt"
	"sync"
	"time"
)

func main1() {

	// 在Go语言编程中你不需要去自己写进程、线程、协程，你的技能包里只有一个技能–goroutine，
	// 当你需要让某个任务并发执行的时候，你只需要把这个任务包装成一个函数，开启一个goroutine去执行这个函数就可以了

	//使用goroutine
	//Go语言中使用goroutine非常简单，只需要在调用函数的时候在前面加上go关键字，就可以为一个函数创建一个goroutine。
	//一个goroutine必定对应一个函数，可以创建多个goroutine去执行相同的函数

	// hello函数前面加上关键字go，也就是启动一个goroutine去执行hello这个函数
	go hello()
	fmt.Println("main goroutine done!")

	//在程序启动时，Go程序就会为main()函数创建一个默认的goroutine
	//当main()函数返回的时候该goroutine就结束了，所有在main()函数中启动的goroutine会一同结束，
	// main函数所在的goroutine就像是权利的游戏中的夜王，其他的goroutine都是异鬼，夜王一死它转化的那些异鬼也就全部GG了

	//让main函数等一等hello函数，最简单粗暴的方式就是time.Sleep
	time.Sleep(time.Second * 1)

	// 启动多个goroutine
	// 在Go语言中实现并发就是这样简单，我们还可以启动多个goroutine。
	// 这里使用了sync.WaitGroup来实现goroutine的同步
	for i := 0; i < 5; i++ {
		wg.Add(1) // 启动一个goroutine就登记+1
		go helloWithIndex(i)
	}
	wg.Wait() // 等待所有登记的goroutine都结束
}

func hello() {
	fmt.Println("Hello Goroutine!")
}

var wg sync.WaitGroup

func helloWithIndex(i int) {

	defer wg.Done() // goroutine结束就登记-1

	fmt.Println("Hello Goroutine!", i)
}
