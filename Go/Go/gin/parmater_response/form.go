package parmater_response

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func Form() {

	r := gin.Default()

	// curl http://127.0.0.1:8000/loginform -H 'content-type:application/json' -d {"user":"admin","password":"admin"} -X POST
	r.POST("/loginform", func(ctx *gin.Context) {

		// 声明接收的变量
		var json Login

		// Bind()默认解析并绑定form格式
		// 根据请求头中content-type自动推断
		err := ctx.Bind(json)

		// 返回错误信息
		if err == nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"err": err.Error()})
			return
		}

		if json.User != "admin" || json.Pssword != "admin" {
			ctx.JSON(http.StatusBadRequest, gin.H{"code": "failed"})
			return
		}

		ctx.JSON(http.StatusOK, gin.H{"code": "ok"})
	})

	err := r.Run(":8000")
	if err != nil {
		panic(err.Error())
	}
}
