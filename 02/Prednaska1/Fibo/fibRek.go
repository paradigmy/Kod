package main

import "fmt"

func fib(n int) int {
	if n <= 2 {
		return 1
	} else {
		return fib(n-2) + fib(n-1)
	}
}

func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n) 	// čítanie do n
	for j:=1; j <= n; j++ {
		fmt.Println(fib(j))
	}
}
