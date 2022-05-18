package main

import "fmt"

func update() {

	r, err := db.Exec("update person set username=? where user_id=?", "stud", 2)
	if err != nil {
		panic(err.Error())
	}

	row, err := r.RowsAffected()
	if err != nil {
		panic(err.Error())
	}
	fmt.Println("update succ:", row)
}
