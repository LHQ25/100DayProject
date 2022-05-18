package main

import "fmt"

func main3() {
	// 方法集
	//每个类型都有与之关联的方法集，这会影响到接口实现规则。
	//
	//• 类型 T 方法集包含全部 receiver T 方法。
	//• 类型 *T 方法集包含全部 receiver T + *T 方法。
	//• 如类型 S 包含匿名字段 T，则 S 和 *S 方法集包含 T 方法。
	//• 如类型 S 包含匿名字段 *T，则 S 和 *S 方法集包含 T + *T 方法。
	//• 不管嵌入 T 或 *T，*S 方法集总是包含 T + *T 方法。

	//用实例 value 和 pointer 调用方法 (含匿名字段) 不受方法集约束，编译器总是查找全部方法，并自动转换 receiver 实参。
	// Go 语言中内部类型方法集提升的规则：
	// 类型 T 方法集包含全部 receiver T 方法
	t1 := T{1}
	fmt.Printf("t1 is : %v\n", t1)
	t1.test()

	// 类型 *T 方法集包含全部 receiver T + *T 方法。
	t2 := &t1
	fmt.Printf("t2 is : %v\n", t2)
	t2.testT()
	t2.testP()

	// 给定一个结构体类型 S 和一个命名为 T 的类型，方法提升像下面规定的这样被包含在结构体方法集中：
	// 如类型 S 包含匿名字段 T，则 S 和 *S 方法集包含 T 方法。
	// 这条规则说的是当我们嵌入一个类型，嵌入类型的接受者为值类型的方法将被提升，可以被外部类型的值和指针调用。
	s1 := S{T{1}}
	s2 := &s1
	fmt.Printf("s1 is : %v\n", s1)
	s1.testT3()
	fmt.Printf("s2 is : %v\n", s2)
	s2.testT3()

	// 如类型 S 包含匿名字段 *T，则 S 和 *S 方法集包含 T + *T 方法。
	// 这条规则说的是当我们嵌入一个类型的指针，嵌入类型的接受者为值类型或指针类型的方法将被提升，可以被外部类型的值或者指针调用。

	fmt.Printf("s1 is : %v\n", s1)
	s1.testT3()
	s1.testP3()
	fmt.Printf("s2 is : %v\n", s2)
	s2.testT3()
	s2.testP3()
}

type T struct {
	int
}

func (t T) test() {
	fmt.Println("类型 T 方法集包含全部 receiver T 方法。")
}

func (t T) testT() {
	fmt.Println("类型 *T 方法集包含全部 receiver T 方法。")
}

func (t *T) testP() {
	fmt.Println("类型 *T 方法集包含全部 receiver *T 方法。")
}

type S struct {
	T
}

func (t T) test3() {
	fmt.Println("如类型 S 包含匿名字段 T，则 S 和 *S 方法集包含 T 方法。")
}

func (t T) testT3() {
	fmt.Println("如类型 S 包含匿名字段 *T，则 S 和 *S 方法集包含 T 方法")
}
func (t *T) testP3() {
	fmt.Println("如类型 S 包含匿名字段 *T，则 S 和 *S 方法集包含 *T 方法")
}
