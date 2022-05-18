package parmaterVerify

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	"net/http"
	"time"
)

// Person 用gin框架的数据验证，可以不用解析数据，减少if else，会简洁许多
type Person struct {
	//不能为空并且大于10
	Age      int       `form:"age" binding:"required,gt=10"`
	Name     string    `form:"name" binding:"required"`
	Birthday time.Time `form:"birthday" time_format:"2006-01-02" time_utc:"1"`
}

// Person2 对绑定解析到结构体上的参数，自定义验证功能
//    比如我们要对 name 字段做校验，要不能为空，并且不等于 admin ，类似这种需求，就无法 binding 现成的方法
//    需要我们自己验证方法才能实现 官网示例（https://godoc.org/gopkg.in/go-playground/validator.v8#hdr-Custom_Functions）
//    这里需要下载引入下 gopkg.in/go-playground/validator.v8

type Person2 struct {
	Age int `form:"age" binding:"required,gt=10"`
	// 2、在参数 binding 上使用自定义的校验方法函数注册时候的名称
	Name    string `form:"name" binding:"NotNullAndAdmin"`
	Address string `form:"address" binding:"required"`
}

func Gin_vertfy() {

	r := gin.Default()

	r.POST("/parmater/verify", func(context *gin.Context) {

		var person Person
		err := context.ShouldBind(person)
		if err != nil {
			context.String(500, fmt.Sprint(err))
			return
		}
		context.String(200, fmt.Sprintf("%#v", person))
	})

	r.Run(":8000")
}

// 自定义验证
// 1、自定义的校验方法
func nameNotNullAndAdmin(fl validator.FieldLevel) bool {

	if value, ok := fl.Field().Interface().(string); ok {
		// 字段不能为空，并且不等于  admin
		return value != "" && !("5lmh" == value)
	}

	return true
}
func CustomeVerify() {

	r := gin.Default()

	// 3、将我们自定义的校验方法注册到 validator中
	v, ok := binding.Validator.Engine().(*validator.Validate)
	if ok {
		// 这里的 key 和 fn 可以不一样最终在 struct 使用的是 key
		err := v.RegisterValidation("NotNullAndAdmin", nameNotNullAndAdmin)
		if err != nil {
			return
		}
	}

	r.POST("/parameter/customerVerify", func(c *gin.Context) {

		var person Person2
		if e := c.ShouldBind(&person); e == nil {
			c.String(http.StatusOK, "%v", person)
		} else {
			c.String(http.StatusOK, "person bind err:%v", e.Error())
		}
	})

	r.Run(":8000")
}
