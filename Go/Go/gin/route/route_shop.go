package route

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func LoadShop(e *gin.Engine) {
	e.GET("/shop/post", postGoodsHandler)
	e.GET("/shop/comment", commentGoodsHandler)
}

func postGoodsHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Hello www.topgoer.com",
	})
}

func commentGoodsHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Hello www.topgoer.com",
	})
}
