package main

import "fmt"

func main15()  {

	// select 语句
	//
	//select 语句类似于 switch 语句，但是select会随机执行一个可运行的case。如果没有case可运行，它将阻塞，直到有case可运行。
	//
	//select 是Go中的一个控制结构，类似于用于通信的switch语句。每个case必须是一个通信操作，要么是发送要么是接收。
	//select 随机执行一个可运行的case。如果没有case可运行，它将阻塞，直到有case可运行。一个默认的子句应该总是可运行的
	/*
	select {
	    case communication clause  :
	       statement(s);
	    case communication clause  :
	       statement(s);
	    /* 你可以定义任意数量的 case /
		default : /* 可选
			statement(s);
		}
	 */

	// 每个case都必须是一个通信
	//    所有channel表达式都会被求值
	//    所有被发送的表达式都会被求值
	//    如果任意某个通信可以进行，它就执行；其他被忽略。
	//    如果有多个case都可以运行，Select会随机公平地选出一个执行。其他不会执行。
	//    否则：
	//    如果有default子句，则执行该语句。
	//    如果没有default字句，select将阻塞，直到某个通信可以运行；Go不会重新对channel或值进行求值。

	var c1, c2, c3 chan int
	var i1, i2 int
	select {
	case i1 = <-c1:
		fmt.Printf("received ", i1, " from c1\n")
	case c2 <- i2:
		fmt.Printf("sent ", i2, " to c2\n")
	case i3, ok := (<-c3):  // same as: i3, ok := <-c3
		if ok {
			fmt.Printf("received ", i3, " from c3\n")
		} else {
			fmt.Printf("c3 is closed\n")
		}
	default:
		fmt.Printf("no communication\n")
	}

	// select可以监听channel的数据流动
	//
	//select的用法与switch语法非常类似，由select开始的一个新的选择块，每个选择条件由case语句来描述
	//
	//与switch语句可以选择任何使用相等比较的条件相比，select由比较多的限制，其中最大的一条限制就是每个case语句里必须是一个IO操作

	/*
	select { //不停的在这里检测
	    case <-chanl : //检测有没有数据可以读
	    //如果chanl成功读取到数据，则进行该case处理语句
	    case chan2 <- 1 : //检测有没有可以写
	    //如果成功向chan2写入数据，则进行该case处理语句


	    //假如没有default，那么在以上两个条件都不成立的情况下，就会在此阻塞//一般default会不写在里面，select中的default子句总是可运行的，因为会很消耗CPU资源
	    default:
	    //如果以上都没有符合条件，那么则进行default处理流程
	    }
	 */

	// 在一个select语句中，Go会按顺序从头到尾评估每一个发送和接收的语句。
	//
	//如果其中的任意一个语句可以继续执行（即没有被阻塞），那么就从那些可以执行的语句中任意选择一条来使用。
	//如果没有任意一条语句可以执行（即所有的通道都被阻塞），
	//那么有两种可能的情况：
	//①如果给出了default语句，那么就会执行default的流程，同时程序的执行会从select语句后的语句中恢复。
	//②如果没有default语句，那么select语句将被阻塞，直到至少有一个case可以进行下去。


	// select中的default子句总是可运行的。
	//
	//如果有多个case都可以运行，select会随机公平地选出一个执行，其他不会执行。
	//
	//如果没有可运行的case语句，且有default语句，那么就会执行default的动作。
	//
	//如果没有可运行的case语句，且没有default语句，select将阻塞，直到某个case通信可以运行
}
