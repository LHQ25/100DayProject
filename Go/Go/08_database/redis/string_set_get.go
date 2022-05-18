package main

import (
	"fmt"
	"github.com/garyburd/redigo/redis"
)

func string_set_get() {

	_, err := conn.Do("Set", "abc", 101)
	if err != nil {
		panic(err.Error())
	}

	fmt.Println("")

	res, err := redis.Int(conn.Do("Get", "abc"))
	if err != nil {
		panic(err.Error())
	}

	fmt.Println(res)

}

// string_mulity String批量操作
func string_mulity() {

	_, err := conn.Do("MSet", "abcd", 100, "efg", 300)
	if err != nil {
		fmt.Println(err)
		return
	}

	r, err := redis.Ints(conn.Do("MGet", "abcd", "efg"))
	if err != nil {
		fmt.Println("get abc failed,", err)
		return
	}

	for _, v := range r {
		fmt.Println(v)
	}
}
