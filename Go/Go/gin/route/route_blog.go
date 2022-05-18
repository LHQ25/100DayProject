package route

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func LoadBlog(e *gin.Engine) {
	e.GET("/shop/post", postHandler)
	e.GET("/shop/comment", commentHandler)
}

func postHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Hello www.topgoer.com",
	})
}

func commentHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Hello www.topgoer.com",
	})
}
