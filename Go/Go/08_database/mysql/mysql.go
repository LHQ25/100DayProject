package main

import (
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

var db *sqlx.DB

func main() {

	database, err := sqlx.Open("mysql", "root:12345678@tcp(127.0.0.1:3306)/test")
	//database, err := sqlx.Open("数据库类型", "用户名:密码@tcp(地址:端口)/数据库名")
	if err != nil {
		panic(err.Error())
	}

	db = database
	defer db.Close()

	db.Begin()
	//insert()
	//db_select()
	//update()
	//del()
}
