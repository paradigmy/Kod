package main

import (
	"fmt"
	"strconv"
)

/*
#####################################################################

# GO1 - Napíšte v jazyku Go program na výpočet faktorialu, ktorý
#   - nepoužíva príkaz priradenia,
#   - nepoužíva násobenie,
#   - nepoužíva žiadne číselne konštanty.
*/

func mult(a, b int) int {
	if a == a+b {
		return b
	} else {
		return mult(a, b-(b/b)) + a
	}
}

func fact(n int) int {
	if n == n+n {
		return ^n / ^n
	} else {
		return mult(n, fact(n-(n/n)))
	}
}

/*
###############################################################
#  obmedzené príklady s jedinou globalnou premennou a
###############################################################
*/

// toto je ta globalna premenna
var a int = 0

// toto nemeniť, len použiť
func input(prompt string) {
	var i string
	fmt.Println(prompt)
	fmt.Scan(&i)
	a, _ = strconv.Atoi(i)
}

// súčet dvoch prirodzených čísel s jednou globalnou premennou
func sum2Nat() {
	if a > 0 {
		a--
		sum2Nat()
		a++
	} else {
		input("druhe")
	}
}

// súčet dvoch celych čísel s jednou globalnou premennou
func sum2Int() {
	if a > 0 {
		a--
		sum2Int()
		a++
	} else if a < 0 {
		a++
		sum2Int()
		a--
	} else {
		input("druhe")
	}
}

// súčet troch celych čísel s jednou globalnou premennou
func sum3Int() {
	sum2Int()
	sum2Int()
}

// maximum dvoch prirodzenych čísel s jednou globalnou premennou
func dvaA() {
	if a == 0 {
		input("druhe")
		triB()
	} else {
		a--
		dvaA()
		a*=2
	}
}

func triB() {
	if a == 0 {
		a = 1
	} else {
		a--
		triB()
		a*=3
	}
}

func min() {
	if a % 6 != 0 {
		a = 0
	} else {
		a /= 6
		min()
		a++
	}
}

func main() {
	input("prve")
	dvaA()
	min()
	fmt.Printf("ich min je: %d\n", a)

}


func comb(n, k int64) int64 {
	if k == 0 || n == k {
		return 1
	} else {
		return comb(n-1, k-1) + comb(n-1, k)
	}
}
