package main

import (
	"fmt"
	"math/rand"
	"sort"
	"time"
)

func main11()  {

	// map是一种无序的基于key-value的数据结构，Go语言中的map是引用类型，必须初始化才能使用
	// map的定义语法 :  map[KeyType]ValueType
	// KeyType:表示键的类型。
	// ValueType:表示键对应的值的类型。
	// map类型的变量默认初始值为nil，需要使用make()函数来分配内存
	// make(map[KeyType]ValueType, [cap])

	// map基本使用
	map_base()

	// 判断某个键是否存在
	map_keyIsExist()

	// map的遍历
	map_foreach()
	
	// 使用delete()函数删除键值对
	map_delete()

	// 按照指定顺序遍历map
	map_conditionForEach()
	
	// 元素为map类型的切片
	map_elementWithSlice()
	
	// 值为切片类型的map
	map_valueWithSlice()
}

func map_base(){
	scoreMap := make(map[string]int, 8)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	fmt.Println(scoreMap)
	fmt.Println(scoreMap["小明"])
	fmt.Printf("type of a:%T\n", scoreMap)

	// map也支持在声明的时候填充元素
	userInfo := map[string]string{
		"username": "pprof.cn",
		"password": "123456",
	}
	fmt.Println(userInfo) //
}

func map_keyIsExist(){

	// value, ok := map[key]

	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	// 如果key存在ok为true,v为对应的值；不存在ok为false,v为值类型的零值
	v, ok := scoreMap["张三"]
	if ok {
		fmt.Println(v)
	} else {
		fmt.Println("查无")
	}
}

func map_foreach(){
	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	scoreMap["王五"] = 60
	for k, v := range scoreMap {
		fmt.Println(k, v)
	}

	// 只遍历key
	for k := range scoreMap {
		fmt.Println(k)
	}
}

func  map_delete()  {
	// delete(map, key)
	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	scoreMap["王五"] = 60
	delete(scoreMap, "小明")//将小明:100从map中删除
	for k,v := range scoreMap{
		fmt.Println(k, v)
	}
}

func map_conditionForEach(){
	rand.Seed(time.Now().UnixNano()) //初始化随机数种子

	var scoreMap = make(map[string]int, 200)

	for i := 0; i < 100; i++ {
		key := fmt.Sprintf("stu%02d", i) //生成stu开头的字符串
		value := rand.Intn(100)          //生成0~99的随机整数
		scoreMap[key] = value
	}
	//取出map中的所有key存入切片keys
	var keys = make([]string, 0, 200)
	for key := range scoreMap {
		keys = append(keys, key)
	}
	//对切片进行排序
	sort.Strings(keys)
	//按照排序后的key遍历map
	for _, key := range keys {
		fmt.Println(key, scoreMap[key])
	}
}

func map_elementWithSlice()  {
	var mapSlice = make([]map[string]string, 3)
	for index, value := range mapSlice {
		fmt.Printf("index:%d value:%v\n", index, value)
	}
	fmt.Println("after init")
	// 对切片中的map元素进行初始化
	mapSlice[0] = make(map[string]string, 10)
	mapSlice[0]["name"] = "王五"
	mapSlice[0]["password"] = "123456"
	mapSlice[0]["address"] = "红旗大街"
	for index, value := range mapSlice {
		fmt.Printf("index:%d value:%v\n", index, value)
	}
}

func map_valueWithSlice()  {
	var sliceMap = make(map[string][]string, 3)
	fmt.Println(sliceMap)
	fmt.Println("after init")
	key := "中国"
	value, ok := sliceMap[key]
	if !ok {
		value = make([]string, 0, 2)
	}
	value = append(value, "北京", "上海")
	sliceMap[key] = value
	fmt.Println(sliceMap)
}