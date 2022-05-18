package main

import "fmt"

func main6()  {

	// 函数的声明
	/*
	func functionname(parametername type) returntype {
	    // 函数体（具体实现的功能）
	}
	 */

	price := calculateBill(10,20)
	fmt.Println(price)

	price2 := calculateBill2(1,2)
	fmt.Println(price2)

	area, perimter := rectProps(10, 20)
	fmt.Println(area, perimter)

	// _ 用来跳过不要的计算结果
	area2, _ := rectProps(20, 20)
	fmt.Println(area2)

	// 函数是第一类对象，可作为参数传递。建议将复杂签名定义为函数类型，以便于阅读
	s1 := test(func() int { return 100 }) // 直接将匿名函数当参数。
	s2 := format(func(s string, x, y int) string {
		return fmt.Sprintf(s, x, y)
	}, "%d, %d", 10, 20)

	println(s1, s2)
}

func calculateBill(price int, no int) int {
	var totalPrice = price * no // 商品总价 = 商品单价 * 数量
	return totalPrice // 返回总价
}

// 如果有连续若干个参数，它们的类型一致，那么我们无须一一罗列，只需在最后一个参数后添加该类型
func calculateBill2(price, no int) int {
	var totalPrice = price * no
	return totalPrice
}

// 多返回值
func rectProps(length, width float64)(float64, float64) {
	var area = length * width
	var perimeter = (length + width) * 2
	return area, perimeter
}

// 定义函数类型。
type FormatFunc func(s string, x, y int) string

func test(fn func() int) int {
	return fn()
}
func format(fn FormatFunc, s string, x, y int) string {
	return fn(s, x, y)
}