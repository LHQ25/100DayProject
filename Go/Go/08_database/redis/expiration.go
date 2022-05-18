package main

func Expiration() {

	// expire: 过期
	// 10秒 后过期
	_, err := conn.Do("expire", "abc", 10)
	if err != nil {
		panic(err.Error())
	}

}
