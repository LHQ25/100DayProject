package main

import "fmt"

func main2() {

	// 匿名字段 ：可以像字段成员那样访问匿名字段方法，编译器负责查找。
	m := Manager{UserD{1, "Tom"}}
	fmt.Printf("Manager: %p\n", &m)
	fmt.Println(m.ToString()) // 调用 UserD 的 ToString。 前提-》 Manager 没重写 UserD 的 ToString 方法

	//通过匿名字段，可获得和继承类似的复用能力。依据编译器查找次序，只需在外层定义同名方法，就可以实现 "override"
	fmt.Println(m.ToString()) // 调用 Manager 的 ToString  `这里已经`重写了 UserD 的同名方法
}

type UserD struct {
	id   int
	name string
}

type Manager struct {
	UserD
}

func (self *UserD) ToString() string { // receiver = &(Manager.UserD)
	return fmt.Sprintf("UserD: %p, %v", self, self)
}

func (self *Manager) ToString() string {
	return fmt.Sprintf("Manager: %p, %v", self, self)
}
