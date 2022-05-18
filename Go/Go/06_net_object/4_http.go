package main

import "net/http"

func main() {
	//web工作流程
	//
	//Web服务器的工作原理可以简单地归纳为
	//客户机通过TCP/IP协议建立到服务器的TCP连接
	//客户端向服务器发送HTTP协议请求包，请求服务器里的资源文档
	//服务器向客户机发送HTTP协议应答包，如果请求的资源包含有动态语言的内容，那么服务器会调用动态语言的解释引擎负责处理“动态内容”，并将处理得到的数据返回给客户端
	//客户机与服务器断开。由客户端解释HTML文档，在客户端屏幕上渲染图形结果
	//1.1.2. HTTP协议
	//
	//超文本传输协议(HTTP，HyperText Transfer Protocol)是互联网上应用最为广泛的一种网络协议，它详细规定了浏览器和万维网服务器之间互相通信的规则，通过因特网传送万维网文档的数据传送协议
	//HTTP协议通常承载于TCP协议之上

	//http://127.0.0.1:8000/go
	// 单独写回调函数
	http.HandleFunc("/go", myHandler)

	// addr：监听的地址
	// handler：回调函数
	err := http.ListenAndServe(":8000", nil)
	if err != nil {
		panic(err.Error())
	}
	// 客户端就不用写了，直接访问接口就可以看到返回的数据
}

func myHandler(response http.ResponseWriter, r *http.Request) {

	_, err := response.Write([]byte("ResponseWriter"))
	if err != nil {
		panic(err.Error())
	}
}
