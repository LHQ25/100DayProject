package routes

import "github.com/gin-gonic/gin"

type Option func(engine *gin.Engine)

var optios = []Option{}

func InClude(opts ...Option) {
	optios = append(optios, opts...)
}

func Init() *gin.Engine {

	r := gin.New()
	for _, opt := range optios {
		opt(r)
	}

	return r
}
