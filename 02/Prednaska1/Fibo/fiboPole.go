package main

import "fmt"

var tabulka []int // array[] of int

func FibPole(n int) int {
	if tabulka[n] == 0 {
		tabulka[n] = FibPole(n-2) + FibPole(n-1)
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
		fmt.Println(FibPole(j))
	}
}
