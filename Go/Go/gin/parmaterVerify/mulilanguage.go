package parmaterVerify

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/locales/en"
	"github.com/go-playground/locales/zh"
	"github.com/go-playground/locales/zh_Hant_TW"
	ut "github.com/go-playground/universal-translator"
	"github.com/go-playground/validator/v10"

	//"gopkg.in/go-playground/validator.v9"
	en_translations "github.com/go-playground/validator/v10/translations/en"
	zh_translations "github.com/go-playground/validator/v10/translations/zh"
	zh_tw_translations "github.com/go-playground/validator/v10/translations/zh_tw"
)

// 当业务系统对验证信息有特殊需求时，
// 例如：返回信息需要自定义，手机端返回的信息需要是中文而pc端发挥返回的信息需要时英文，
// 如何做到请求一个接口满足上述三种情况

var (
	Uni      *ut.UniversalTranslator
	Validate *validator.Validate
)

type User struct {
	Username string `form:"user_name" validate:"required"`
	Tagline  string `form:"tag_line" validate:"required,lt=10"`
	Tagline2 string `form:"tag_line2" validate:"required,gt=1"`
}

func Test() {

	en := en.New()
	zh := zh.New()
	zh_tw := zh_Hant_TW.New()
	Uni = ut.New(en, zh, zh_tw)
	Validate = validator.New()

	route := gin.Default()
	route.GET("/5lmh", startPage)
	route.POST("/5lmh", startPage)
	route.Run(":8080")
}

func startPage(c *gin.Context) {
	//这部分应放到中间件中
	locale := c.DefaultQuery("locale", "zh")
	trans, _ := Uni.GetTranslator(locale)
	switch locale {
	case "zh":
		_ = zh_translations.RegisterDefaultTranslations(Validate, trans)
		break
	case "en":
		_ = en_translations.RegisterDefaultTranslations(Validate, trans)
		break
	case "zh_tw":
		_ = zh_tw_translations.RegisterDefaultTranslations(Validate, trans)
		break
	default:
		_ = zh_translations.RegisterDefaultTranslations(Validate, trans)
		break
	}

	//自定义错误内容
	_ = Validate.RegisterTranslation("required", trans, func(ut ut.Translator) error {
		return ut.Add("required", "{0} must have a value!", true) // see universal-translator for details
	}, func(ut ut.Translator, fe validator.FieldError) string {
		t, _ := ut.T("required", fe.Field())
		return t
	})

	//这块应该放到公共验证方法中
	user := User{}
	_ = c.ShouldBind(&user)
	fmt.Println(user)
	err := Validate.Struct(user)
	if err != nil {
		errs := err.(validator.ValidationErrors)
		sliceErrs := []string{}
		for _, e := range errs {
			sliceErrs = append(sliceErrs, e.Translate(trans))
		}
		c.String(200, fmt.Sprintf("%#v", sliceErrs))
	}
	c.String(200, fmt.Sprintf("%#v", "user"))
}
