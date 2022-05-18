package main

import "fmt"

func main5()  {

	const a = 55 // 允许
	//a = 89       // 不允许重新赋值
	fmt.Println(a)

	//字符串常量
	// Go 是一个强类型的语言，在分配过程中混合类型是不允许的
	var defaultName = "Sam" // 允许
	type myString string
	var customName myString = "Sam" // 允许
	//customName = defaultName // 不允许
	fmt.Println(defaultName, customName)

	// bool常量
	const trueConst = true
	type myBool bool
	var defaultBool = trueConst // 允许
	var customBool myBool = trueConst // 允许
	//defaultBool = customBool // 不允许
	fmt.Println(trueConst, defaultBool, customBool)

	// 数字常量
	const aa = 5
	var intVar int = a
	var int32Var int32 = a
	var float64Var float64 = a
	var complex64Var complex64 = a
	fmt.Println(aa)
	fmt.Println("intVar",intVar, "\nint32Var", int32Var, "\nfloat64Var", float64Var, "\ncomplex64Var",complex64Var)

	// 数字表达式
	var ab = 5.9/8
	fmt.Printf("a's type %T value %v",ab, ab)

	// 多个声明
	const (
		pi = 3.1415
		e = 2.7182
	)

	// const同时声明多个常量时，如果省略了值则表示和上面一行的值相同
	const (
		n1 = 100
		n2
		n3
	)

	// iota
	// iota是go语言的常量计数器，只能在常量的表达式中使用。
	// iota在const关键字出现时将被重置为0。
	// const中每新增一行常量声明将使iota计数一次(iota可理解为const语句块中的行索引)。
	// 使用iota能简化定义，在定义枚举时很有用
	const (
		n4 = iota //0
		n5        //1
		n6        //2
		n7        //3
	)

	// 使用_跳过某些值
	const (
		n8 = iota //0
		n9        //1
		_
		n10        //3
	)

	// iota声明中间插队
	const (
		n11 = iota //0
		n12 = 100  //100
		n13 = iota //2
		n14        //3
	)
	const n15 = iota //0

	// 定义数量级 （这里的<<表示左移操作，1<<10表示将1的二进制表示向左移10位，
	// 也就是由1变成了10000000000，也就是十进制的1024。同理2<<2表示将2的二进制表示向左移2位，
	// 也就是由10变成了1000，也就是十进制的8。）
	const (
		_  = iota
		KB = 1 << (10 * iota)
		MB = 1 << (10 * iota)
		GB = 1 << (10 * iota)
		TB = 1 << (10 * iota)
		PB = 1 << (10 * iota)
	)

	// 多个iota定义在一行
	const (
		a1, b1 = iota + 1, iota + 2 //1,2
		c1, d1                      //2,3
		e1, f1                      //3,4
	)
}