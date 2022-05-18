package cookie_session

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func Cookies() {

	r := gin.Default()

	// 服务端要给客户端cookie
	r.GET("/net/cookies", func(c *gin.Context) {

		// 获取客户端是否携带cookie
		cookie, err := c.Cookie("key_cookie")
		if err != nil {
			cookie = "NotSet"
			// 给客户端设置cookie
			//  maxAge int, 单位为秒
			// path,cookie所在目录
			// domain string,域名
			//   secure 是否智能通过https访问
			// httpOnly bool  是否允许别人通过js获取自己的cookie
			c.SetCookie("key_cookie", "value_cookie", 60, "/",
				"localhost", false, true)
		}

		c.JSON(http.StatusOK, gin.H{"c": cookie})
	})

	r.Run(":8000")
}
