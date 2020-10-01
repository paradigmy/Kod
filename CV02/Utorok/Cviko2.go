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
	if (b == 0) {
		return 0
	} else {
		return a + mult(a, b-1)
	}
}

func fact(n int) int {
	return 0
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

/////////////////////////////////////////////////////
// súčet dvoch prirodzených čísel s jednou globalnou premennou
func sum2Nat() {
	input("zadaj prve cislo:")
	sum2NatRek()
	fmt.Printf("ich sucet je: %d\n", a)
}

func sum2NatRek(){
	if (a == 0){
		input("zadaj druhe cislo:")
	} else {
		a--
		sum2NatRek()
		a++
	}
}

// súčet dvoch celych čísel s jednou globalnou premennou
func sum2Int() {
	input("zadaj prve cislo:")
	sum2IntRek()
	fmt.Printf("ich sucet je: %d\n", a)
}

func sum2IntRek(){
	if (a == 0){
		input("zadaj druhe cislo:")
	} else {
		if (a < 0){
			a++
			sum2IntRek()
			a--
		} else {
			a--
			sum2IntRek()
			a++
		}
	}
}

// súčet troch celych čísel s jednou globalnou premennou
func sum3Int() {
	input("zadaj prve cislo:")
	sum3IntRek()
	sum3IntRek()
	fmt.Printf("ich sucet je: %d\n", a)
}

func sum3IntRek(){
	if (a == 0){
		input("zadaj dalsie cislo:")
	} else {
		if (a < 0){
			a++
			sum3IntRek()
			a--
		} else {
			a--
			sum3IntRek()
			a++
		}
	}
}

func sum3Nat1() {
	if (a == 0){
		input("druhe")
		sum3Nat2()
	} else {
		a--
		sum3Nat1()
		a++
	}
}

func sum3Nat2(){

}


// maximum dvoch prirodzenych čísel s jednou globalnou premennou

func max2Nat() {
	input("zadaj prve cislo:")
	naA()
	max()
	fmt.Printf("ich sucet je: %d\n", a)
}

func naA(){
	if (a == 0){
		input("zadaj druhe cislo")
		naB()
	} else  {
		a--
		naA()
		a = a * 2
	}
}

func naB(){
	if (a == 0){
		a = 1
	} else  {
		a--
		naB()
		a = a * 3
	}
}

func max(){
	if a == 1 {
		a = 0
	} else if a % 6 == 0{
		a /= 6
		max()
		a++
	} else if a % 2 == 0{
		a /= 2
		max()
		a++
	} else if a % 3 == 0{
		a /= 3
		max()
		a++
	}
}

func main() {
	max2Nat()
}