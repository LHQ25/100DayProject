package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"strings"
)

/*
Go语言实现TCP通信

TCP协议

TCP/IP(Transmission Control Protocol/Internet Protocol)
即传输控制协议/网间协议，是一种面向连接（连接导向）的、可靠的、基于字节流的传输层（Transport layer）通信协议，
因为是面向连接的协议，数据像水流一样传输，会存在黏包问题。

TCP服务端

一个TCP服务端可以同时连接很多个客户端，例如世界各地的用户使用自己电脑上的浏览器访问淘宝网。因为Go语言中创建多个goroutine实现并发非常方便和高效，
所以我们可以每建立一次链接就创建一个goroutine去处理。

TCP服务端程序的处理流程：

    1.监听端口
    2.接收客户端请求建立链接
    3.创建goroutine处理链接
*/

func main1() {

	//将代码编译成client或client.exe可执行文件，
	//先启动server端再启动client端，在client端输入任意内容回车之后就能够在server端看到client端发送的数据，从而实现TCP通信

	conn, err := net.Dial("tcp", "127.0.0.1:20000")
	if err != nil {
		panic(err.Error())
	}

	defer conn.Close() // 关闭连接

	inputReader := bufio.NewReader(os.Stdin)
	for {
		input, _ := inputReader.ReadString('\n') // 读取用户输入
		inputInfo := strings.Trim(input, "\r\n")
		if strings.ToUpper(inputInfo) == "Q" { // 如果输入q就退出
			return
		}
		_, err = conn.Write([]byte(inputInfo)) // 发送数据
		if err != nil {
			return
		}
		buf := [512]byte{}
		n, err := conn.Read(buf[:])
		if err != nil {
			fmt.Println("recv failed, err:", err)
			return
		}
		fmt.Println(string(buf[:n]))
	}
}
