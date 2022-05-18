package log

import (
	"github.com/gin-gonic/gin"
	"io"
	"net/http"
	"os"
)

func Log() {

	gin.DisableConsoleColor()

	lgo_file, err := os.CreateTemp("./", "gin_log")
	if err != nil {
		panic(err.Error())
	}
	gin.DefaultWriter = io.MultiWriter(lgo_file)
	// 如果需要同时将日志写入文件和控制台，请使用以下代码。
	// gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

	r := gin.Default()
	r.GET("/gin/log", func(c *gin.Context) {

		c.JSON(http.StatusOK, gin.H{"key": "v"})
	})

	_ = r.Run(":8080")
}
