package route

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"strings"
)

//type Route struct {}

func Route() {
	// 1.创建路由
	r := gin.Default()
	// 2.绑定路由规则，执行的函数
	// gin.Context，封装了request和response
	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello World!")
	})

	//************ 2 ************
	/*
		gin支持Restful风格的API

		即Representational State Transfer的缩写。直接翻译的意思是"表现层状态转化"，是一种互联网应用程序的API设计理念：URL定位资源，用HTTP描述操作

		1.获取文章 /blog/getXxx Get blog/Xxx

		2.添加 /blog/addXxx POST blog/Xxx

		3.修改 /blog/updateXxx PUT blog/Xxx

		4.删除 /blog/delXxxx DELETE blog/Xxx
	*/

	//************ 3 Api paramter ************
	r.GET("/user/:name/*action", func(c *gin.Context) {
		name := c.Param("name")
		action := c.Param("action")
		//截取/
		action = strings.Trim(action, "/")
		c.String(http.StatusOK, name+" is "+action)
	})

	//************ 4 URL参数 ************
	// URL参数可以通过DefaultQuery()或Query()方法获取
	// DefaultQuery()若参数不村则，返回默认值，Query()若不存在，返回空串
	// API ? name=zs
	r.GET("/user2", func(c *gin.Context) {
		//指定默认值
		//http://localhost:8080/user 才会打印出来默认的值
		name := c.DefaultQuery("name", "枯藤")
		c.String(http.StatusOK, fmt.Sprintf("hello %s", name))
	})

	//************ 5 表单参数 ************
	// 表单传输为post请求，http常见的传输格式为四种：
	// application/json
	// application/x-www-form-urlencoded
	// application/xml
	// multipart/form-data
	// 表单参数可以通过PostForm()方法获取，该方法默认解析的是x-www-form-urlencoded或from-data格式的参数
	r.POST("/form", func(c *gin.Context) {
		types := c.DefaultPostForm("type", "post")
		username := c.PostForm("username")
		password := c.PostForm("userpassword")
		// c.String(http.StatusOK, fmt.Sprintf("username:%s,password:%s,type:%s", username, password, types))
		c.String(http.StatusOK, fmt.Sprintf("username:%s,password:%s,type:%s", username, password, types))
	})

	//************ 6 上传单个文件 ************
	// multipart/form-data格式用于文件上传
	// gin文件上传与原生的net/http方法类似，不同在于gin把原生的request封装到c.Request中
	//限制上传最大尺寸
	r.MaxMultipartMemory = 8 << 20
	r.POST("/upload", func(c *gin.Context) {
		file, err := c.FormFile("file")
		if err != nil {
			c.String(500, "上传图片出错")
		}
		// c.JSON(200, gin.H{"message": file.Header.Context})
		c.SaveUploadedFile(file, file.Filename)
		c.String(http.StatusOK, file.Filename)
	})

	// 解除限制大小以及文件类型的上传函数
	r.POST("/upload2", func(c *gin.Context) {
		_, headers, err := c.Request.FormFile("file")
		if err != nil {
			log.Printf("Error when try to get file: %v", err)
		}
		//headers.Size 获取文件大小
		if headers.Size > 1024*1024*2 {
			fmt.Println("文件太大了")
			return
		}
		//headers.Header.Get("Content-Type")获取上传文件的类型
		if headers.Header.Get("Content-Type") != "image/png" {
			fmt.Println("只允许上传png图片")
			return
		}
		err = c.SaveUploadedFile(headers, "./video/"+headers.Filename)
		if err != nil {
			fmt.Println(err.Error())
		}
		c.String(http.StatusOK, headers.Filename)
	})

	//************ 6 上传多个文件 ************
	// 限制表单上传大小 8MB，默认为32MB
	r.MaxMultipartMemory = 8 << 20
	r.POST("/upload3", func(c *gin.Context) {
		form, err := c.MultipartForm()
		if err != nil {
			c.String(http.StatusBadRequest, fmt.Sprintf("get err %s", err.Error()))
		}
		// 获取所有图片
		files := form.File["files"]
		// 遍历所有图片
		for _, file := range files {
			// 逐个存
			if err := c.SaveUploadedFile(file, file.Filename); err != nil {
				c.String(http.StatusBadRequest, fmt.Sprintf("upload err %s", err.Error()))
				return
			}
		}
		c.String(200, fmt.Sprintf("upload ok %d files", len(files)))
	})

	//************ 7 routes group ************
	// routes group是为了管理一些相同的URL
	// 路由组1 ，处理GET请求
	v1 := r.Group("/v1")
	// {} 是书写规范
	{
		v1.GET("/login", login)
		v1.GET("submit", submit)
	}
	v2 := r.Group("/v2")
	{
		v2.POST("/login", login)
		v2.POST("/submit", submit)
	}

	//************ 8 路由拆分成多个文件 ************
	LoadBlog(r)
	LoadShop(r)

	// 3.监听端口，默认在8080
	// Run("里面不指定端口号默认为8080")
	err := r.Run(":8000")
	if err != nil {
		panic(err.Error())
	}
}

func login(c *gin.Context) {
	name := c.DefaultQuery("name", "jack")
	c.String(200, fmt.Sprintf("hello %s\n", name))
}

func submit(c *gin.Context) {
	name := c.DefaultQuery("name", "lily")
	c.String(200, fmt.Sprintf("hello %s\n", name))
}
