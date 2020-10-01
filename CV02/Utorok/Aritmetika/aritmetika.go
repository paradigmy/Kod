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
	input("zadaj prve cislo:")
	fmt.Printf("ich sucet je: %d\n", a)
}

// súčet dvoch celych čísel s jednou globalnou premennou
func sum2Int() {
	input("zadaj prve cislo:")
	fmt.Printf("ich sucet je: %d\n", a)
}

// súčet troch celych čísel s jednou globalnou premennou
func sum3Int() {
	input("zadaj prve cislo:")
	fmt.Printf("ich sucet je: %d\n", a)
}

// maximum dvoch prirodzenych čísel s jednou globalnou premennou
func max2Int() {
	input("zadaj prve cislo:")
	fmt.Printf("ich sucet je: %d\n", a)
}

func main() {
  sum2Nat()
}