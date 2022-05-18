package main

import "fmt"

func main10()  {

	// 区别于C/C++中的指针，Go语言中的指针不能进行偏移和运算，是安全指针。
	//要搞明白Go语言中的指针需要先知道3个概念：指针地址、指针类型和指针取值

	// Go语言中的函数传参都是值拷贝，当我们想要修改某个变量的时候，
	// 我们可以创建一个指向该变量地址的指针变量。传递数据使用指针，而无须拷贝数据。
	// 类型指针不能进行偏移和运算。Go语言中的指针操作非常简单，只需要记住两个符号：&（取地址）和*（根据地址取值）

	// Go语言中的值类型（int、float、bool、string、array、struct）都有对应的指针类型，如：*int、*int64、*string等
	a := 10
	b := &a
	fmt.Printf("a:%d ptr:%p\n", a, &a) // a:10 ptr:0xc00001a078
	fmt.Printf("b:%p type:%T\n", b, b) // b:0xc00001a078 type:*int
	fmt.Println(&b)                    // 0xc00000e018

	// 指针取值
	pointer_getValue()

	// 空指针
	pointer_emptyPointer()

	//  Go语言中new和make是内建的两个函数，主要用来分配内存
	pointer_new()

	pointer_make()

	// 1.二者都是用来做内存分配的。
	// 2.make只用于slice、map以及channel的初始化，返回的还是这三个引用类型本身；
	// 3.而new用于类型的内存分配，并且内存对应的值为类型零值，返回的是指向类型的指针
}

func pointer_getValue(){

	a := 10
	b := &a // 取变量a的地址，将指针保存到b中
	fmt.Printf("type of b:%T\n", b)
	c := *b // 指针取值（根据指针去内存取值）
	fmt.Printf("type of c:%T\n", c)
	fmt.Printf("value of c:%v\n", c)
}

func pointer_emptyPointer(){
	var p *string
	fmt.Println(p)
	fmt.Printf("p的值是%v\n", p)
	if p != nil {
		fmt.Println("非空")
	} else {
		fmt.Println("空值")
	}
}

func pointer_new() {
	// 函数签名
	// func new(Type) *Type
	// 1.Type表示类型，new函数只接受一个参数，这个参数是一个类型
	// 2.*Type表示类型指针，new函数返回一个指向该类型内存地址的指针。
	// new函数不太常用，使用new函数得到的是一个类型的指针，并且该指针对应的值为该类型的零值
	a := new(int)
	b := new(bool)
	fmt.Printf("%T\n", a) // *int
	fmt.Printf("%T\n", b) // *bool
	fmt.Println(*a)       // 0
	fmt.Println(*b)       // false

	// 示例代码中var a *int只是声明了一个指针变量a但是没有初始化，
	// 指针作为引用类型需要初始化后才会拥有内存空间，才可以给它赋值。
	// 应该按照如下方式使用内置的new函数对a进行初始化之后就可以正常对其赋值了
}

func pointer_make(){
	// make也是用于内存分配的，区别于new，它只用于slice、map以及chan的内存创建，
	// 而且它返回的类型就是这三个类型本身，而不是他们的指针类型，因为这三种类型就是引用类型，所以就没有必要返回他们的指针了

	// make函数是无可替代的，我们在使用slice、map以及channel的时候，都需要使用make进行初始化，然后才可以对它们进行操作

	// 示例中var b map[string]int只是声明变量b是一个map类型的变量，
	// 需要像下面的示例代码一样使用make函数进行初始化操作之后，才能对其进行键值对赋值
	var b map[string]int
	b = make(map[string]int, 10)
	b["测试"] = 100
	fmt.Println(b)
}