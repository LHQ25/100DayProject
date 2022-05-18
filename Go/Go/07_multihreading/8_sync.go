package main

import (
	"fmt"
	"image"
	"os"
	"strconv"
	"sync"
)

var wg_s sync.WaitGroup

var m = sync.Map{}

func main8() {

	// sync.WaitGroup
	// 在代码中生硬的使用time.Sleep肯定是不合适的
	// Go语言中可以使用sync.WaitGroup来实现并发任务的同步

	// sync.WaitGroup内部维护着一个计数器，计数器的值可以增加和减少。
	// 例如当我们启动了N 个并发任务时，就将计数器值增加N。
	// 每个任务完成时通过调用Done()方法将计数器减1。
	// 通过调用Wait()来等待并发任务执行完，
	// 当计数器值为0时，表示所有并发任务已经完成
	wg_s.Add(1)
	go hello2() // 启动另外一个goroutine去执行hello函数
	fmt.Println("main goroutine done!")
	wg_s.Wait()

	// sync.Once
	// 在编程的很多场景下我们需要确保某些操作在高并发的场景下只执行一次，例如只加载一次配置文件、只关闭一次通道等。
	//Go语言中的sync包中提供了一个针对只执行一次场景的解决方案–sync.Once。
	//sync.Once只有一个Do方法，其签名如下：
	//func (o *Once) Do(f func()) {}
	//注意：如果要执行的函数f需要传递参数就需要搭配闭包来使用

	// 加载配置文件示例
	// 延迟一个开销很大的初始化操作到真正用到它的时候再执行是一个很好的实践。
	// 因为预先初始化一个变量（比如在init函数中完成初始化）会增加程序的启动耗时，
	// 而且有可能实际执行过程中这个变量没有用上，那么这个初始化操作就不是必须要做的

	// sync.Once其实内部包含一个互斥锁和一个布尔值，互斥锁保证布尔值和数据的安全，
	// 而布尔值用来记录初始化是否完成。这样设计就能保证初始化操作的时候是并发安全的并且初始化操作也不会被执行多次
	_ = Icon("left.png")

	//sync.Map
	//Go语言中内置的map不是并发安全的

	wgq := sync.WaitGroup{}
	for i := 0; i < 20; i++ {
		wgq.Add(1)
		go func(n int) {
			key := strconv.Itoa(n)
			m.Store(key, n)
			value, _ := m.Load(key)
			fmt.Printf("k=:%v,v:=%v\n", key, value)
			wgq.Done()
		}(i)
	}
	wgq.Wait()
}

func hello2() {
	defer wg_s.Done()
	fmt.Println("Hello Goroutine!")
}

var icons map[string]image.Image
var loadIconsOnce sync.Once

func loadIcons() {
	icons = map[string]image.Image{
		"left":  loadIcon("left.png"),
		"up":    loadIcon("up.png"),
		"right": loadIcon("right.png"),
		"down":  loadIcon("down.png"),
	}
}

// Icon 是并发安全的
func Icon(name string) image.Image {
	loadIconsOnce.Do(loadIcons)
	return icons[name]
}

func loadIcon(string2 string) image.Image {

	file, err := os.Open(string2)
	if err != nil {
		panic(err.Error())
	}
	img, _, _ := image.Decode(file)
	return img
}
