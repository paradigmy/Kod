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
	sum2Int1()
	fmt.Printf("ich sucet je: %d\n", a)
}

func sum2Nat1(){
	if a > 0 {
		a--
		sum2Nat1()
		a++
	} else {
			input("Zadaj druhe cislo: ")
	}
}

func sum2Int1(){
	if a > 0 {
		a--
		sum2Int1()
		a++
	} else if a<0 {
		a++
		sum2Int1()
		a--
	} else {
		input("Zadaj druhe cislo: ")
		sum3Int1()
	}
}

func sum3Int() {
	input("zadaj prve cislo:")
	sum2Int1()
	fmt.Printf("ich sucet je: %d\n", a)
}

func sum3Int1(){
	if a > 0 {
		a--
		sum3Int1()
		a++
	} else if a<0 {
		a++
		sum3Int1()
		a--
	} else {
		input("Zadaj tretie cislo: ")
	}
}

func main() {
	//sum2Nat()
	sum3Int()
}
