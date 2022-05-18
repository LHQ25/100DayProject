package main

import (
	"github.com/kataras/iris/v12"
	"github.com/kataras/iris/v12/context"
)

func main() {

	r := iris.Default()

	r.Handle("GET", "/v1/h", func(c context.Context) {

		c.JSON(iris.Map{"v": "s"})
	})

	_ = r.Run(iris.Addr(":8000"))
}
