package main

import "fmt"

func db_select() {

	var persons []Person
	err := db.Select(&persons, "select * from person")
	if err != nil {
		panic(err.Error())
	}
	fmt.Print(persons)

}
