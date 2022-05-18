package cookie_session

import (
	"fmt"
	"github.com/gorilla/sessions"
	"net/http"
)

// 初始化一个cookie存储对象
// something-very-secret应该是一个你自己的密匙，只要不被别人知道就行
var store = sessions.NewCookieStore([]byte("something-very-secret"))

func Session() {

	http.HandleFunc("/save", func(w http.ResponseWriter, r *http.Request) {
		session, err := store.Get(r, "session-name")
		if err != nil {
			http.Error(w, err.Error(), http.StatusRequestTimeout)
			return
		}
		// 在session中存储值
		session.Values["foo"] = "bar"
		session.Values[42] = 43
		// 保存更改
		session.Save(r, w)
	})

	http.HandleFunc("/get", func(w http.ResponseWriter, r *http.Request) {
		session, err := store.Get(r, "session-name")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		foo := session.Values["foo"]
		fmt.Println(foo)
	})

	err := http.ListenAndServe(":8000", nil)
	if err != nil {
		panic(err.Error())
	}
}
