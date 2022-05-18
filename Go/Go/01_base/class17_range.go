package main

import "fmt"

func main17()  {

	// Golang range类似迭代器操作，返回 (索引, 值) 或 (键, 值)。
	//
	//for 循环的 range 格式可以对 slice、map、数组、字符串等进行迭代循环

	s := "abc"
	// 忽略 2nd value，支持 string/array/slice/map。
	for i := range s {
		println(s[i])
	}
	// 忽略 index。
	for _, c := range s {
		println(c)
	}
	// 忽略全部返回值，仅迭代。
	for range s {

	}

	m := map[string]int{"a": 1, "b": 2}
	// 返回 (key, value)。
	for k, v := range m {
		println(k, v)
	}

	// *注意，range 会复制对象。
	a := [3]int{0, 1, 2}

	for i, v := range a { // index、value 都是从复制品中取出。

		if i == 0 { // 在修改前，我们先修改原数组。
			a[1], a[2] = 999, 999
			fmt.Println(a) // 确认修改有效，输出 [0, 999, 999]。
		}

		a[i] = v + 100 // 使用复制品中取出的 value 修改原数组。

	}

	fmt.Println(a) // 输出 [100, 101, 102]。
	// 建议改用引用类型，其底层数据不会被复制

	//另外两种引用类型 map、channel 是指针包装，而不像 slice 是 struct。
	//
	//for 和 for range有什么区别?
	//
	//主要是使用场景不同
	//
	//for可以
	//
	//遍历array和slice
	//
	//遍历key为整型递增的map
	//
	//遍历string
	//
	//for range可以完成所有for可以做的事情，却能做到for不能做的，包括
	//
	//遍历key为string类型的map并同时获取key和value
	//
	//遍历channel
}
