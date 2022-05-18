package main

import (
	"fmt"
	"github.com/garyburd/redigo/redis"
)

var conn redis.Conn

func main() {

	con, err := redis.Dial("tcp", ":6379")
	if err != nil {
		panic(err)
	}
	fmt.Println("redis conn success")

	conn = con
	defer con.Close()

	// String Set Get操作
	//string_set_get()

	// String批量操作
	//string_mulity()

	// 过期时间
	//Expiration()

	//list()

	hash()
}
