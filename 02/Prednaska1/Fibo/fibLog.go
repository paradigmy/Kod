package main

import (
	"fmt"
)

func FibPair(Fj int, Fj1 int) (int, int) {
	return Fj*Fj + Fj1*Fj1, (Fj + Fj + Fj1) * Fj1
}

func FibLog(n int) (int, int) {
	if n < 2 {
		return 0, 1
	} else if n%2 == 1 {
		fj, fj1 := FibLog(n / 2)
		x, y := FibPair(fj, fj1)
		return y, y + x
	} else {
		//fj, fj1 := FibLog(n / 2)
		//return FibPair(fj, fj1)
		return FibPair(FibLog(n / 2))

	}
}

func FibLog1(n int) int {
	_, y := FibLog(n)
	return y
}

//-------------------------------------

func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)
	res :=FibLog1(n)
	fmt.Println(res)
}