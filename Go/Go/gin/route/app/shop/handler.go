package shop

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func shopHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Hello www.topgoer.com",
	})
}

func shopCommentHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Hello www.topgoer.com",
	})
}
