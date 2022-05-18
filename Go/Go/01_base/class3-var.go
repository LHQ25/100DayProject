package main

import "fmt"

func main3() {

	// 标准声明
	// var 变量名 变量类型

	var a int // 声明变量
	fmt.Println("声明变量 $a")

	a = 25 // 赋值
	fmt.Println(a)

	var b int = 90 // 声明变量并赋值初始值
	fmt.Println(b)

	var c = 29 // 类型推断,根据初始值自动推断变量的类型
	fmt.Println(c)

	var d, f, g int //声明多个变量
	fmt.Println(d, f, g)

	var h, i, j int = 1, 2, 3 //声明多个变量,并初始化
	fmt.Println(h, i, j)

	// 类型推导
	// 将变量的类型省略，这个时候编译器会根据等号右边的值来推导变量的类型完成初始化
	var name1 = "pprof.cn"
	var sex1 = 1
	fmt.Println(name1, sex1)

	// 有些情况下，我们可能会想要在一个语句中声明不同类型的变量
	var (
		name   = "name"
		age    = 19
		height int
	)
	fmt.Println(name, age, height)

	// 简短声明
	// 该声明使用了 := 操作符。
	// 声明变量的简短语法是 name := initialvalue。
	// 多个声明的时候,左边至少有一个变量是尚未声明的

	aa := 10                        // 单个
	name1, age1, aa := "na", 12, 90 // 多个
	fmt.Println(aa)
	fmt.Println(name1, age1)
}
