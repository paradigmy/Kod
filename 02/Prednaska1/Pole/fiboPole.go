package main
import (
	"fmt"
)

var tabulka []int // array[] of int

func fib(n int) int {
	if tabulka[n] == 0 {
		tabulka[n] = fib(n-2) + fib(n-1)
	}
	return tabulka[n]
}

func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)
	tabulka = make([]int, n) // array[0..n-1] of int
	tabulka[0] = 1
	tabulka[1] = 1
	for j := 0; j < len(tabulka); j++ {
		fmt.Println(fib(j))
	}
}
