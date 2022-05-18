package main

import "fmt"

func main4() {

	// Golang 表达式 ：根据调用者不同，方法分为两种表现形式:
	// 1
	// instance.method(args...) ---> <type>.func(instance, args...)
	// 前者称为 method value，后者 method expression。
	// 2
	// 两者都可像普通函数那样赋值和传参，区别在于 method value 绑定实例，而 method expression 则须显式传参

	u := UserF{1, "Tom"}
	u.Test()

	mValue := u.Test
	mValue() // 隐式传递 receiver

	mExpression := (*UserF).Test
	mExpression(&u) // 显式传递 receiver

	// 需要注意，method value 会复制 receiver
	mValue2 := u.Test        // 立即复制 receiver，因为不是指针类型，不受后续修改影响。
	u.id, u.name = 2, "Jack" // 修改不影响 mValue2 的 receiver
	u.Test()
	mValue2()

	// 在汇编层面，method value 和闭包的实现方式相同，实际返回 FuncVal 类型对象。
	//
	// FuncVal { method_address, receiver_copy }
	// 可依据方法集转换 method expression，注意 receiver 类型的差异
	u2 := UserF{1, "Tom"}
	fmt.Printf("User: %p, %v\n", &u2, u2)

	mv := UserF.TestValue
	mv(u)

	mp := (*UserF).TestPointer
	mp(&u)

	mp2 := (*UserF).TestValue // *UserF 方法集包含 TestValue。签名变为 func TestValue(self *UserF)。实际依然是 receiver value copy。
	mp2(&u)
}

type UserF struct {
	id   int
	name string
}

func (self *UserF) Test() {
	fmt.Printf("%p, %v\n", self, self)
}

func (self *UserF) TestPointer() {
	fmt.Printf("TestPointer: %p, %v\n", self, self)
}

func (self UserF) TestValue() {
	fmt.Printf("TestValue: %p, %v\n", &self, self)
}
