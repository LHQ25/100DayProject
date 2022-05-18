package parmater_response

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

// 定义接收数据的结构体
type Login struct {
	// binding:"required"修饰的字段，若接收为空值，则报错，是必须字段
	User    string `form:"username" json:"user" uri:"user" xml:"user" binding:"required"`
	Pssword string `form:"password" json:"password" uri:"password" xml:"password" binding:"required"`
}

func Json() {

	r := gin.Default()

	// -H 请求头
	// -d POST参数
	// -X POST: POST请求
	// curl http://127.0.0.1:8000/loginjson -H 'content-type:application/json' -d {"user":"admin","password":"admin"} -X POST
	r.POST("/loginjson", func(ctx *gin.Context) {

		// 声明接收的变量
		var json Login

		// 将request的body中的数据，自动按照json格式解析到结构体
		err := ctx.ShouldBindJSON(json)

		// 返回错误信息
		if err == nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"err": err.Error()})
			return
		}

		if json.User != "admin" || json.Pssword != "admin" {
			ctx.JSON(http.StatusBadRequest, gin.H{"code": "failedllll"})
			return
		}

		ctx.JSON(http.StatusOK, gin.H{"code": "ok"})
	})

	err := r.Run(":8000")
	if err != nil {
		panic(err.Error())
	}
}
