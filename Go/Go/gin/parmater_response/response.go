package parmater_response

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func Response() {
	r := gin.Default()

	// json、结构体、XML、YAML类似于java的properties、ProtoBuf
	// curl http://127.0.0.1:8000/loginurl/admin/admin -H 'content-type:application/json'
	r.POST("/loginresponse", func(ctx *gin.Context) {

		// 声明接收的变量
		var json Login

		// Bind()默认解析并绑定form格式
		// 根据请求头中content-type自动推断
		err := ctx.ShouldBindJSON(json)

		// 返回错误信息
		if err == nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"err": err.Error()})
			return
		}

		if json.User != "admin" || json.Pssword != "admin" {
			ctx.JSON(http.StatusBadRequest, gin.H{"code": "failed"})
			return
		}

		// 返回json
		//ctx.JSON(http.StatusOK, gin.H{"code": "ok"})
		ctx.ProtoBuf(http.StatusOK, json)
	})

	err := r.Run(":8000")
	if err != nil {
		panic(err.Error())
	}
}
