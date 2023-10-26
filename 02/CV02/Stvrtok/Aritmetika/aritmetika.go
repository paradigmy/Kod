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
	//fmt.Println(a)
}

// súčet dvoch prirodzených čísel s jednou globalnou premennou
func sum2Nat() {
	if a==0 {
		input("druhe")
	}else{
		a--
		sum2Nat()
		a++
	}
}

// súčet dvoch celych čísel s jednou globalnou premennou
func sum2Int() {
}

// súčet troch celych čísel s jednou globalnou premennou
func sum3Int() {
}

// maximum dvoch prirodzenych čísel s jednou globalnou premennou
func max() {
}

func main() {
	input("prve.. ")
	sum2Nat()
	fmt.Println("Ich sucet je: %d\n", a)
}
