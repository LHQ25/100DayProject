package render

import (
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"time"
)

func Render() {
	r := gin.Default()

	// 渲染
	// curl http://127.0.0.1:8000/loginurl/admin/admin -H 'content-type:application/json'
	r.POST("/render/html", func(ctx *gin.Context) {

		// gin支持加载HTML模板, 然后根据模板参数进行配置并返回相应的数据，本质上就是字符串替换
		// LoadHTMLGlob()方法可以加载模板文件
		ctx.HTML(http.StatusOK, "./index.html", gin.H{"title": "我是测试", "ce": "123456"})
	})

	r.GET("/render/redirect", func(ctx *gin.Context) {

		// 重定向
		ctx.Redirect(http.StatusMovedPermanently, "./index.html")
	})

	// 同步
	r.GET("/render/sync", func(ctx *gin.Context) {

		// 简单返回一下
		ctx.String(http.StatusMovedPermanently, "./index.html")
	})

	// 异步
	r.GET("/render/sync", func(ctx *gin.Context) {

		// 需要一个副本
		copyContext := ctx.Copy()
		// 异步处理
		go func() {
			time.Sleep(3 * time.Second)
			log.Println("异步执行：" + copyContext.Request.URL.Path)
		}()
	})

	//如果你需要引入静态文件需要定义一个静态文件目录
	//r.StaticFile("/assest", "./assest")

	err := r.Run(":8000")
	if err != nil {
		panic(err.Error())
	}
}
