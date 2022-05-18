package main

import (
	"github.com/gorilla/mux"
	"net/http"
)

func main() {

	router := mux.NewRouter()
	go h.run()
	router.HandleFunc("/ws", myws)

	err := http.ListenAndServe(":8000", router)
	if err != nil {
		panic(err.Error())
	}
}
