package main

import "fmt"

// 全局数组
var arr0 [5]int = [5]int{1, 2, 3}
var arr1 = [5]int{1, 2, 3, 4, 5}
var arr2 = [...]int{1, 2, 3, 4, 5, 6}
var str = [5]string{3: "hello world", 4: "tom"}

// 全局 多维数组
var arr3 [5][3]int
var arr4 [2][3]int = [...][3]int{{1, 2, 3}, {7, 8, 9}}

func main8()  {

	/*
	1. 数组：是同一种数据类型的固定长度的序列。
	    2. 数组定义：var a [len]int，比如：var a [5]int，数组长度必须是常量，且是类型的组成部分。一旦定义，长度不能变。
	    3. 长度是数组类型的一部分，因此，var a[5] int和var a[10]int是不同的类型。
	    4. 数组可以通过下标进行访问，下标是从0开始，最后一个元素下标是：len-1
	    for i := 0; i < len(a); i++ {
	    }
	    for index, v := range a {
	    }
	    5. 访问越界，如果下标在数组合法范围之外，则触发访问越界，会panic
	    6. 数组是值类型，赋值和传参会复制整个数组，而不是指针。因此改变副本的值，不会改变本身的值。
	    7.支持 "=="、"!=" 操作符，因为内存总是被初始化过的。
	    8.指针数组 [n]*T，数组指针 *[n]T。
	 */

	// 数组的初始化
	a := [3]int{1, 2}           // 未初始化元素值为 0。
	b := [...]int{1, 2, 3, 4}   // 通过初始化值确定数组长度。
	c := [5]int{2: 100, 4: 200} // 使用引号初始化元素。
	d := [...]struct {
		name string
		age  uint8
	}{
		{"user1", 10}, // 可省略元素类型。
		{"user2", 20}, // 别忘了最后一行的逗号。
	}
	fmt.Println(arr0, arr1, arr2, str)
	fmt.Println(a, b, c, d)

	a1 := [2][3]int{{1, 2, 3}, {4, 5, 6}}
	b1 := [...][2]int{{1, 1}, {2, 2}, {3, 3}} // 第 2 纬度不能用 "..."。
	fmt.Println(arr3, arr4)
	fmt.Println(a1, b1)

	// 值拷贝行为会造成性能问题，通常会建议使用 slice，或数组指针

	// 内置函数 len 和 cap 都返回数组长度 (元素数量)
	fmt.Println(len(a1), cap(a1))

	// 多维数组的遍历
	var f [2][3]int = [...][3]int{{1, 2, 3}, {7, 8, 9}}

	for k1, v1 := range f {
		for k2, v2 := range v1 {
			fmt.Printf("(%d,%d)=%d ", k1, k2, v2)
		}
		fmt.Println()
	}

	// 数组拷贝和传参
	var arr1 [5]int
	printArr(&arr1)
	fmt.Println(arr1)
	arr2 := [...]int{2, 4, 6, 8, 10}
	printArr(&arr2)
	fmt.Println(arr2)
}

func printArr(arr *[5]int) {
	arr[0] = 10
	for i, v := range arr {
		fmt.Println(i, v)
	}
}