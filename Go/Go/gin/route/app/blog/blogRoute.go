package blog

import (
	"github.com/gin-gonic/gin"
)

func Routes(e *gin.Engine) {
	e.GET("/shop/post", blogHandler)
	e.GET("/shop/comment", blogCommentHandler)
}
