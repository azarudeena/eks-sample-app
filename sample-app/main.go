package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"sort"
	"strings"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		f := fibonacci()

		res := &response{Message: "Hello World"}

		for _, e := range os.Environ() {
			pair := strings.Split(e, "=")
			res.EnvVars = append(res.EnvVars, pair[0]+"="+pair[1])
		}
		sort.Strings(res.EnvVars)

		for i := 1; i <= 90; i++ {
			res.Fib = append(res.Fib, f())
		}

		out, _ := json.MarshalIndent(res, "", "  ")

		w.Header().Set("Content-Type", "text/plain")

		io.WriteString(w, string(out))

		fmt.Println("Hello world - the log message")
	})
	http.ListenAndServe(":8080", nil)
}

type response struct {
	Message string   `json:"message"`
	EnvVars []string `json:"env"`
	Fib     []int    `json:"fib"`
}

func fibonacci() func() int {
	a, b := 0, 1
	return func() int {
		a, b = b, a+b
		return a
	}
}
