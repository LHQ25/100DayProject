package main

import "Go/gin/parmater_response"

func main() {

	// 路由 基础&简单路由分组
	//route.Route()

	// 路由拆分到不同的APP
	//routes.InClude(shop.Routes, blog.Routes)
	//routes.Init()

	// 数据绑定和解析
	// JSON url form
	parmater_response.Json()
	// 返回数据
	//parmater_response.Response()

	// 渲染： 返回html、重定向、同步、异步
	//render.Render()

	// 中间件
	//middleWare.MiddleWare()

	// cookies & session
	//cookie_session.Cookies()
	//cookie_session.Session()

	// 参数验证
	//parmaterVerify.Gin_vertfy()
	//parmaterVerify.CustomeVerify()
	// 多语言转换
	//parmaterVerify.Test()
}
