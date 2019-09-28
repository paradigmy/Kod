package main

import "fmt"

func FiboCyklus(n int) {
	var (
		a     = 1
		b int = 1
	)
	for ; n > 0; n-- {
		fmt.Println(b)
		//a, b = a+b, a
		a = a + b
		b = a - b
	}
}
func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)

	FiboCyklus(n)
}
