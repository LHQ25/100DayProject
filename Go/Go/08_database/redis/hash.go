package main

import (
	"fmt"
	"github.com/garyburd/redigo/redis"
)

func hash() {

	//hash  也就是对象。可以映射
	_, err := conn.Do("hmset", "book_hash：1000", "k1", "v1", "k2", "v2")
	if err != nil {
		panic(err.Error())
	}

	r, err := redis.String(conn.Do("hget", "book_hash：1000", "k1"))
	if err != nil {
		panic(err.Error())
	}
	fmt.Print(" r: ", r)

	rr, err := redis.StringMap(conn.Do("hgetall", "book_hash：1000"))
	if err != nil {
		panic(err.Error())
	}

	fmt.Print(" r2: ", rr)

}
