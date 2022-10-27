package main

import (
	"fmt"
	"strconv"
)
func main() {
	sum2Int()
	//compare2Nat()
	//maximum()
}

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

func factorial(n int) int {
	if n == n+n {
		return ^n / ^n
	} else {
		return mult(n, factorial(n-(n/n)))
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
	// ???
	fmt.Printf("ich sucet je: %d\n", a)
}


// súčet dvoch prirodzených čísel s jednou globalnou premennou
func sum2Int() {
	input("zadaj prve cislo:")
	// ???
	fmt.Printf("ich sucet je: %d\n", a)
}

//#############################################################
//# GO 2- V jazyku Go napíšte program, ktorý načíta zo vstupu pomocou príkazu
//# input("zadaj cislo:")
//# tri CELÉ čísla a pomocou príkazu Printf(a)
//# vypíše ich súčet. V programe môžete použiť iba jednu globálnu celočíselnú
//# premennú "a" a procedúry/funkcie bez argumentov.
//# Program musí fungovať správne aj pre záporné hodnoty.

//    súčet troch celých čísel s jednou globalnou premennou
func sum3Int() {
	input("zadaj prve cele cislo:")
	// ???
	fmt.Printf("ich sucet je: %d", a)
}

// ##########################################################
// # GO3 - Maximum dvoch celých čísel
// # V jazyku Go napíšte program, ktorý zo štandardného vstupu pomocou príkazu
// # input("zadaj cislo:")
// # načíta prirodzené čísla a pomocou príkazu Printf(a)
// # vypíše ich maximum.
// # V programe môžete použiť iba jednu globlnu celoeselnú premennú "a" a
// # procedúry bez argumentov.

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
func max2Nat() {
	input("zadaj prve cele cislo:")
	// ???
	fmt.Printf("ich maximum je: %d", a)
}


// rozdiel dvoch celych čísel s jednou globalnou premennou
func diff2Nat() {
	input("zadaj prve cele cislo:")
	// ???
	fmt.Printf("ich absolutna hodnota rozdielu je: %d\n", a)
}

// porovna dve cele cisla a,b a vrati -1 (a<b), 0 (a==b), 1 (a>b)
func compare2Nat() {
	input("zadaj prve cele cislo:")
	// ??
	fmt.Printf("ich compare je: %d\n", a)
}


