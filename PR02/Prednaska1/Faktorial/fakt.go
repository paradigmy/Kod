package main

import "fmt"

func times(m int) func(int) int {
	return func(x int) int { return x * m }
}

func main() {
	n := 10
	poleFunkcii := make([]func(int) int, n)
	for i := 0; i < len(poleFunkcii); i++ {
		m := i + 1
		poleFunkcii[i] = func(x int) int { return x * m }
		//poleFunkcii[i] = times(m)

	}
	f := 1
	fmt.Println(f)
	for i := 0; i < len(poleFunkcii); i++ {
		f = poleFunkcii[i](f)
		fmt.Println(f)
	}

	poleKonstant := make([]func() int, n)
	poleKonstant[0] = func() int { return 1 }
	for i := 1; i < len(poleKonstant); i++ {
		m := i + 1
		k := i - 1
		poleKonstant[i] = func() int { return poleKonstant[k]() * m }

	}
	fmt.Println(poleKonstant[len(poleKonstant)-1]())
}
