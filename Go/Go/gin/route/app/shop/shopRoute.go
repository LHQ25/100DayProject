package shop

import (
	"github.com/gin-gonic/gin"
)

func Routes(e *gin.Engine) {
	e.GET("/shop/post", shopHandler)
	e.GET("/shop/comment", shopCommentHandler)
}
