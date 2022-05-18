package main

import (
	"fmt"
	"github.com/garyburd/redigo/redis"
)

// list List队列操作
func list() {

	//Redis lists 入门
	//LPUSH 命令可向list的左边（头部）添加一个新元素，而RPUSH命令可向list的右边（尾部）添加一个新元素。最后LRANGE 命令可从list中取出一定范围的元素

	_, err := conn.Do("del", "book_list")
	if err != nil {
		panic(err.Error())
	}

	_, err = conn.Do("lpush", "book_list", 123, 234, 345)
	if err != nil {
		panic(err.Error())
	}

	_, err = conn.Do("rpush", "book_list", 456)
	if err != nil {
		panic(err.Error())
	}

	r, err := redis.Int(conn.Do("lpop", "book_list"))
	if err != nil {
		panic(err.Error())
	}

	fmt.Print(" r2: ", r)

}
