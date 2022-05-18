package middleWare

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"time"
)

func MiddleWare() {

	// 1.创建路由
	// 默认使用了2个中间件Logger(), Recovery()
	r := gin.Default()

	// 注册中间件
	r.Use(createMiddleWare())

	// {}为了代码规范
	{
		r.GET("/ce", func(c *gin.Context) {
			// 取值, 中间件set的request值
			req, _ := c.Get("request")
			fmt.Println("request:", req)
			// 页面接收
			c.JSON(200, gin.H{"request": req})
		})

		// 局部中间件
		r.GET("/partce", partMiddleWare(), func(c *gin.Context) {
			// 取值, 中间件set的request值
			req, _ := c.Get("request")
			req2, _ := c.Get("request2")
			fmt.Println("request:", req, "part request", req2)
			// 页面接收
			c.JSON(200, gin.H{"request": req})
		})
	}

	err := r.Run(":8000")
	if err != nil {
		panic(err.Error())
	}
}

func createMiddleWare() gin.HandlerFunc {
	return func(c *gin.Context) {

		t := time.Now()
		fmt.Println("中间件开始执行了")

		// 设置变量到Context的key中，可以通过Get()取
		c.Set("request", "中间件")

		// 执行函数
		c.Next()

		// 中间件执行完后续的一些事情
		status := c.Writer.Status()
		fmt.Println("中间件执行完毕", status)

		t2 := time.Since(t)
		fmt.Println("time:", t2)
	}
}

func partMiddleWare() gin.HandlerFunc {
	return func(c *gin.Context) {

		t := time.Now()
		fmt.Println("中间件开始执行了")

		// 设置变量到Context的key中，可以通过Get()取
		c.Set("request2", "局部中间件")

		// 执行函数
		c.Next()

		// 中间件执行完后续的一些事情
		status := c.Writer.Status()
		fmt.Println("中间件执行完毕", status)

		t2 := time.Since(t)
		fmt.Println("time:", t2)
	}
}
