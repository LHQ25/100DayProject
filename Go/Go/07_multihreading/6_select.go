package main

import (
	"fmt"
	"time"
)

func main6() {

	// select的使用类似于switch语句，它有一系列case分支和一个默认的分支。每个case会对应一个通道的通信（接收或发送）过程。
	// select会一直等待，直到某个case的通信操作完成时，就会执行case分支对应的语句
	/*
		select {
		    case <-chan1:
		       // 如果chan1成功读到数据，则进行该case处理语句
		    case chan2 <- 1:
		       // 如果成功向chan2写入数据，则进行该case处理语句
		    default:
		       // 如果上面都没有成功，则进入default处理流程
		    }
	*/

	// 2个管道
	output1 := make(chan string)
	output2 := make(chan string)

	// 跑2个子协程，写数据
	go test1(output1)
	go test2(output2)

	// 用select监控
	select {
	case s1 := <-output1:
		fmt.Println("s1=", s1)
	case s2 := <-output2:
		fmt.Println("s2=", s2)
	}

	// 如果多个channel同时ready，则随机选择一个执行
	// 创建2个管道
	intChan := make(chan int, 1)
	stringChan := make(chan string, 1)
	go func() {
		//time.Sleep(2 * time.Second)
		intChan <- 1
	}()
	go func() {
		stringChan <- "hello"
	}()
	select {
	case value := <-intChan:
		fmt.Println("int:", value)
	case value := <-stringChan:
		fmt.Println("string:", value)
	}
	fmt.Println("main结束")

	// 可以用于判断管道是否存满
	// 创建管道
	output4 := make(chan string, 10)
	// 子协程写数据
	go write(output4)
	// 取数据
	for s := range output4 {
		fmt.Println("res:", s)
		time.Sleep(time.Second)
	}
}

func test1(ch chan string) {
	time.Sleep(time.Second * 5)
	ch <- "test1"
}
func test2(ch chan string) {
	time.Sleep(time.Second * 2)
	ch <- "test2"
}

func write(ch chan string) {
	for {
		select {
		// 写数据
		case ch <- "hello":
			fmt.Println("write hello")
		default:
			fmt.Println("channel full")
		}
		time.Sleep(time.Millisecond * 500)
	}
}
