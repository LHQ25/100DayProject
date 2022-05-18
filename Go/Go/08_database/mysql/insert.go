package main

import "fmt"

type Person struct {
	UserId   int    `db:"user_id"`
	Username string `db:"username"`
	Sex      string `db:"sex"`
	Email    string `db:"email"`
}

type Place struct {
	Country string `db:"country"`
	City    string `db:"city"`
	TelCode int    `db:"telcode"`
}

func insert() {

	r, err := db.Exec("insert into person(username,sex,email) values (?,?,?)", "stu1", "1", "stu1@163.com")
	if err != nil {
		panic(err.Error())
	}
	id, err := r.LastInsertId()
	if err != nil {
		fmt.Println("exec failed, ", err)
		return
	}

	fmt.Println("insert succ:", id)
}
