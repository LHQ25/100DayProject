package main

import "fmt"

//类型定义
type NewInt int

//类型别名
type MyInt = int

func main12()  {

	// Go语言中没有“类”的概念，也不支持“类”的继承等面向对象的概念。
	// Go语言中通过结构体的内嵌再配合接口比面向对象具有更高的扩展性和灵活性

	//1.自定义类型
	// 在Go语言中有一些基本的数据类型，如string、整型、浮点型、布尔等数据类型，Go语言中可以使用type关键字来定义自定义类型。
	// 自定义类型是定义了一个全新的类型。我们可以基于内置的基本类型定义，也可以通过struct定义

	// 1.1 将MyInt定义为int类型
	// type MyInt int
	// 通过Type关键字的定义，MyInt就是一种新的类型，它具有int的特性

	// 1.2 类型别名
	// 类型别名规定：TypeAlias只是Type的别名，本质上TypeAlias与Type是同一个类型
	// type TypeAlias = Type
	// rune和byte就是类型别名
	// type byte = uint8
	// type rune = int32

	// 1.3 类型定义和类型别名的区别
	var a NewInt
	var b MyInt

	fmt.Printf("type of a:%T\n", a) //type of a:main.NewInt
	fmt.Printf("type of b:%T\n", b) //type of b:int
	// a的类型是main.NewInt，表示main包下定义的NewInt类型。b的类型是int。MyInt类型只会在代码中存在，编译完成时并不会有MyInt类型
	
	// 结构图定义
	struct_base()

	// 结构体实例化
	// 只有当结构体实例化时，才会真正地分配内存。也就是必须实例化后才能使用结构体的字段。
	// 结构体本身也是一种类型，我们可以像声明内置类型一样使用var关键字声明结构体类型
	struct_instance()

	// 匿名结构体
	struct_hid()

	// 创建指针类型结构体
	struct_pointer()
	
	// 取结构体的地址实例化
	struct_pointer_instance()
	
	// 结构体初始化
	struct_init()
}

func struct_base()  {
	// 使用type和struct关键字来定义结构体，具体代码格式如下：

	//type 类型名 struct {
	//	字段名 字段类型
	//	字段名 字段类型
	//	…
	//}

	//1.类型名：标识自定义结构体的名称，在同一个包内不能重复。
	//2.字段名：表示结构体字段名。结构体中的字段名必须唯一。
	//3.字段类型：表示结构体字段的具体类型。
	// 同样类型的字段也可以写在一行，

	type person1 struct {
		name, city string
		age        int8
	}
	// 结构体是用来描述一组值的。比如一个人有名字、年龄和居住城市等，本质上是一种聚合型的数据类型
}

type person struct {
	name string
	city string
	age  int8
}
func struct_instance()  {
	var p1 person
	p1.name = "pprof.cn"
	p1.city = "北京"
	p1.age = 18
	fmt.Printf("p1=%v\n", p1)  //p1={pprof.cn 北京 18}
	fmt.Printf("p1=%#v\n", p1) //p1=main.person{name:"pprof.cn", city:"北京", age:18}
}

func struct_hid()  {
	var user struct{Name string; Age int}
	user.Name = "pprof.cn"
	user.Age = 18
	fmt.Printf("%#v\n", user)
}

func struct_pointer()  {

	// 使用new关键字对结构体进行实例化，得到的是结构体的地址
	var p2 = new(person)
	p2.name = "测试"
	p2.age = 18
	p2.city = "北京"
	fmt.Printf("p2=%#v\n", p2) //p2=&main.person{name:"测试", city:"北京", age:18}
}

func struct_pointer_instance()  {
	p3 := &person{}
	fmt.Printf("%T\n", p3)     //*main.person
	fmt.Printf("p3=%#v\n", p3) //p3=&main.person{name:"", city:"", age:0}
	p3.name = "博客"
	p3.age = 30
	p3.city = "成都"
	fmt.Printf("p3=%#v\n", p3) //p3=&main.person{name:"博客", city:"成都", age:30}
}

func struct_init()  {

	var p4 person
	fmt.Printf("p4=%#v\n", p4) //p4=main.person{name:"", city:"", age:0}

	// 使用键值对初始化
	p5 := person{
		name: "pprof.cn",
		city: "北京",
		age:  18,
	}
	fmt.Printf("p5=%#v\n", p5) //p5=main.person{name:"pprof.cn", city:"北京", age:18}

	// 结构体指针进行键值对初始化
	p6 := &person{
		name: "pprof.cn",
		city: "北京",
		age:  18,
	}
	fmt.Printf("p6=%#v\n", p6) //p6=&main.person{name:"pprof.cn", city:"北京", age:18}

	//当某些字段没有初始值的时候，该字段可以不写
	p7 := &person{
		city: "北京",
	}
	fmt.Printf("p7=%#v\n", p7) //p7=&main.person{name:"", city:"北京", age:0}

	// 使用值的列表初始化
	// 1.必须初始化结构体的所有字段。
	// 2.初始值的填充顺序必须与字段在结构体中的声明顺序一致。
	// 3.该方式不能和键值初始化方式混用。
	p8 := &person{
		"pprof.cn",
		"北京",
		18,
	}
	fmt.Printf("p8=%#v\n", p8) //p8=&main.person{name:"pprof.cn", city:"北京", age:18}
}