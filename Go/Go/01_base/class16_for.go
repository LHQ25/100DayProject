package main

func main16()  {

	// Golang for支持三种循环方式，包括类似 while 的语法。
	//
	//for循环是一个循环控制结构，可以执行指定次数的循环。
	//
	//语法
	//
	//Go语言的For循环有3中形式，只有其中的一种使用分号。
	//
	//    for init; condition; post { }
	//    for condition { }
	//    for { }
	//    init： 一般为赋值表达式，给控制变量赋初值；
	//    condition： 关系表达式或逻辑表达式，循环控制条件；
	//    post： 一般为赋值表达式，给控制变量增量或减量。
	//    for语句执行过程如下：
	//    ①先对表达式 init 赋初值；
	//    ②判别赋值表达式 init 是否满足给定 condition 条件，若其值为真，满足循环条件，
	//   则执行循环体内语句，然后执行 post，进入第二次循环，再判别 condition；否则判断 condition 的值为假，不满足条件，
	//  就终止for循环，执行循环体外语句。

	s := "abc"

	for i, n := 0, len(s); i < n; i++ { // 常见的 for 循环，支持初始化语句。
		println(s[i])
	}

	n := len(s)
	for n > 0 {                // 替代 while (n > 0) {}
		println(s[n])        // 替代 for (; n > 0;) {}
		n--
	}

	for {                    // 替代 while (true) {}
		println(s)            // 替代 for (;;) {}
	}
	// 不要期望编译器能理解你的想法，在初始化语句中计算出全部结果是个好主意
}
