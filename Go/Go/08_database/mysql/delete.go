package main

import "fmt"

func del() {

	r, err := db.Exec("delete from person where user_id=?", 2)
	if err != nil {
		panic(err.Error())
	}

	row, errr := r.RowsAffected()
	if errr != nil {
		panic(err.Error())
	}
	fmt.Println("delete succ: ", row)
}
