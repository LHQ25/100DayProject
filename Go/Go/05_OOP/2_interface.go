package main

import "fmt"

// 接口（interface）定义了一个对象的行为规范，只定义规范不实现，由具体的对象来实现规范的细节

// 在Go语言中接口（interface）是一种类型，一种抽象的类型。
// interface是一组method的集合，是duck-type programming的一种体现。
// 接口做的事情就像是定义一个协议（规则），只要一台机器有洗衣服和甩干的功能，我就称它为洗衣机。不关心属性（数据），只关心行为（方法）。
// 为了保护你的Go语言职业生涯，请牢记接口（interface）是一种类型

// 接口是一个或多个方法签名的集合。
// 任何类型的方法集中只要拥有该接口'对应的全部方法'签名。
// 就表示它 "实现" 了该接口，无须在该类型上显式声明实现了哪个接口。
// 这称为Structural Typing。
// 所谓对应方法，是指有相同名称、参数列表 (不包括参数名) 以及返回值。
// 当然，该类型还可以有其他方法。
//
// 接口只有方法声明，没有实现，没有数据字段。
// 接口可以匿名嵌入其他接口，或嵌入到结构中。
// 对象赋值给接口时，会发生拷贝，而接口内部存储的是指向这个复制品的指针，既无法修改复制品的状态，也无法获取指针。
// 只有当接口存储的类型和对象都为nil时，接口才等于nil。
// 接口调用不会做receiver的自动转换。
// 接口同样支持匿名字段方法。
// 接口也可实现类似OOP中的多态。
// 空接口可以作为任何类型数据的容器。
// 一个类型可实现多个接口。
// 接口命名习惯以 er 结尾。

// 定义
// type 接口类型名 interface{
//	 方法名1( 参数列表1 ) 返回值列表1
//	 方法名2( 参数列表2 ) 返回值列表2
// 	 …
// }

//1.接口名：使用type将接口定义为自定义的类型名。Go语言的接口在命名时，一般会在单词后面添加er，如有写操作的接口叫Writer，有字符串功能的接口叫Stringer等。接口名最好要能突出该接口的类型含义。
//2.方法名：当方法名首字母是大写且这个接口类型名首字母也是大写时，这个方法可以被接口所在的包（package）之外的代码访问。
//3.参数列表、返回值列表：参数列表和返回值列表中的参数变量名可以省略

// Sayer 接口
type Sayer interface {
	say()
}

// Mover 接口
type Mover interface {
	move()
}

// 接口嵌套
type animal interface {
	Sayer
	Mover
}

// Eater 接口
type Eater interface {
	eat()
}

type dog struct{}

type cat struct{}

type car struct {
	brand string
}

// dog实现了Sayer接口
func (dog) say() {
	fmt.Println("汪汪汪")
}

// dog实现了Moveer接口
func (dog) move() {
	fmt.Println("狗会动")
}

// dog实现了Eater接口
func (*dog) eat() {
	fmt.Println("狗吃东西")
}

// cat实现了Sayer接口
func (cat) say() {
	fmt.Println("喵喵喵")
}

func (c car) move() {
	fmt.Println(c.brand, "会动")
}

func main() {

	// 实现接口的条件
	// 一个对象只要全部实现了接口中的方法，那么就实现了这个接口。换句话说，接口就是一个需要实现的方法列表
	cat := cat{}
	cat.say()

	// 接口类型变量
	// 接口类型变量能够存储所有实现了该接口的实例。 例如上面的示例中，Sayer类型的变量能够存储dog和cat类型的变量
	var x Sayer // 声明一个Sayer类型的变量x
	x = dog{}   // 实例化一个dog
	x.say()     // 汪汪汪

	// 值接收者和指针接收者实现接口的区别
	// 使用值接收者实现接口之后，不管是dog结构体还是结构体指针*dog类型的变量都可以赋值给该接口变量。
	// 因为Go语言中有对指针类型变量求值的语法糖，dog指针fugui内部会自动求值*fugui。
	var x1 Mover
	var wangcai = dog{} // 旺财是dog类型
	x1 = wangcai        // x可以接收dog类型
	var fugui = &dog{}  // 富贵是*dog类型
	x1 = fugui          // x可以接收*dog类型
	x1.move()

	// 指针接收者实现接口
	var x2 Eater
	var wangcai2 = dog{} // 旺财是dog类型
	wangcai2.eat()
	// x2 = wangcai2         // x不可以接收dog类型
	var fugui2 = &dog{} // 富贵是*dog类型
	x2 = fugui2         // x可以接收*dog类型
	x2.eat()

	// 类型与接口的关系
	// 一个类型可以同时实现多个接口，而接口间彼此独立，不知道对方的实现。
	// 例如，狗可以叫，也可以动。我们就分别定义Sayer接口和Mover接口，如下： Mover接口
	var x3 Sayer
	var y Mover

	var a = dog{}
	x3 = a
	y = a
	x3.say()
	y.move()

	// 多个类型实现同一接口
	// Go语言中不同的类型还可以实现同一接口 首先我们定义一个Mover接口，它要求必须由一个move方法
	var x4 Mover
	var a4 = dog{}
	var b4 = car{brand: "保时捷"}
	x4 = a4
	x4.move()
	x4 = b4
	x4.move()

	// 一个接口的方法，不一定需要由一个类型完全实现，
	// 接口的方法可以通过在类型中嵌入其他类型或者结构体来实现
	// dryer实现接口的 dry()
	// haier实现接口的 wash（）
	ws := haier{}
	ws.dry()
	ws.wash()

	//  接口嵌套
	// 接口与接口间可以通过嵌套创造出新的接口
	var x5 animal
	x5 = dog{}
	x5.move()
	x5.say()

	// 空接口
	// 空接口是指没有定义任何方法的接口。因此任何类型都实现了空接口。
	// 空接口类型的变量可以存储任意类型的变量。
	// 定义一个空接口x6
	var x6 interface{}
	s := "pprof.cn"
	x6 = s
	fmt.Printf("type:%T value:%v\n", x6, x6)
	i := 100
	x6 = i
	fmt.Printf("type:%T value:%v\n", x6, x6)
	b6 := true
	x6 = b6
	fmt.Printf("type:%T value:%v\n", x6, x6)

	// 空接口作为函数的参数
	// 使用空接口实现可以接收任意类型的函数参数
	var studentInfo = make(map[string]interface{})
	studentInfo["name"] = "李白"
	studentInfo["age"] = 18
	studentInfo["married"] = false
	fmt.Println(studentInfo)

	// 类型断言
	// 空接口可以存储任意类型的值，那我们如何获取其存储的具体数据呢？
	// 接口值
	// 一个接口的值（简称接口值）是由一个具体类型和具体类型的值两部分组成的。这两部分分别称为接口的动态类型和动态值。
	// 想要判断空接口中的值这个时候就可以使用类型断言，其语法格式：
	// x.(T)
	// 其中：
	// x：表示类型为interface{}的变量
	// T：表示断言x可能是的类型。
	// 该语法返回两个参数，第一个参数是x转化为T类型后的变量，第二个值是一个布尔值，若为true则表示断言成功，为false则表示断言失败。
	var x7 interface{}
	x7 = "pprof.cn"
	v, ok := x7.(string)
	if ok {
		fmt.Println(v)
	} else {
		fmt.Println("类型断言失败")
	}
	// switch语句实现
	justifyType(x7)
}

// WashingMachine 洗衣机
type WashingMachine interface {
	wash()
	dry()
}

// 甩干器
type dryer struct{}

// 实现WashingMachine接口的dry()方法
func (d dryer) dry() {
	fmt.Println("甩一甩")
}

// 海尔洗衣机
type haier struct {
	dryer //嵌入甩干器
}

// 实现WashingMachine接口的wash()方法
func (h haier) wash() {
	fmt.Println("洗刷刷")
}

// 空接口作为函数参数
func show(a interface{}) {
	fmt.Printf("type:%T value:%v\n", a, a)
}

func justifyType(x interface{}) {
	switch v := x.(type) {
	case string:
		fmt.Printf("x is a string，value is %v\n", v)
	case int:
		fmt.Printf("x is a int is %v\n", v)
	case bool:
		fmt.Printf("x is a bool is %v\n", v)
	default:
		fmt.Println("unsupport type！")
	}
}
