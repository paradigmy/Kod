package main

import (
	"fmt"
	"strconv"
)
func main() {
	maximum()
	//sum2Int()
	//compare2Nat()
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
func sum2Nat1() {
	if a > 0 {
		a--
		sum2Nat1()
		a++
	} else {
		input("zadaj druhe cislo:")
	}
}

// súčet dvoch prirodzených čísel s jednou globalnou premennou
func sum2Nat() {
	input("zadaj prve cislo:")
	sum2Nat1()
	fmt.Printf("ich sucet je: %d\n", a)
}

// súčet dvoch celých čísel s jednou globalnou premennou
func sum2Int1() {
	if a > 0 {
		a--
		sum2Int1()
		a++
	} else {
		if a < 0 {
			a++
			sum2Int1()
			a--
		} else {
			input("zadaj druhe cislo:")
		}
	}
}

// súčet dvoch prirodzených čísel s jednou globalnou premennou
func sum2Int() {
	input("zadaj prve cislo:")
	sum2Int1()
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
func sum3IntX2() {
	if a > 0 {
		a--
		sum3IntX2()
		a++
	} else {
		if a < 0 {
			a++
			sum3IntX2()
			a--
		} else {
			input("zadaj tretie cele cislo:")
		}
	}
}

//    súčet troch celých čísel s jednou globalnou premennou
func sum3IntX1() {
	if a > 0 {
		a--
		sum3IntX1()
		a++
	} else {
		if a < 0 {
			a++
			sum3IntX1()
			a--
		} else {
			input("zadaj druhe cele cislo:")
			sum3IntX2()
		}
	}
}

//    súčet troch celých čísel s jednou globalnou premennou
func sum3Int() {
	input("zadaj prve cele cislo:")
	sum3IntX1()
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
func max2NatX2() {
	if a > 0 {
		a--
		max2NatX2()
		a = 3 * a
	} else {
		a = 1
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
func max2NatX1() {
	if a > 0 {
		a--
		max2NatX1()
		a = 2 * a
	} else {
		input("zadaj druhe cele cislo:")
		max2NatX2()
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
func log2() {
	if a > 1 {
		a = a / 2
		log2()
		a++
	} else {
		a = 0
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
func log3() {
	if a > 1 {
		a = a / 3
		log3()
		a++
	} else {
		a = 0
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
func log6() {
	if a%6 == 0 {
		a = a / 6
		log6()
		a++
	} else {
		if a%2 == 0 {
			log2()
		} else {
			if a%3 == 0 {
				log3()
			}
		}
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
func max2Nat() {
	input("zadaj prve cele cislo:")
	max2NatX1()
	// v premennej a je 2^prve*3^druhe
	// ... ideme logaritmovat
	// fmt.Printf((a)
	log6()
	fmt.Printf("ich maximum je: %d", a)
}


// rozdiel dvoch celych čísel s jednou globalnou premennou
func diff2Nat() {
	input("zadaj prve cele cislo:")
	a=-a
	sum2Int1()
	if (a < 0) {
		a = -a
	}
	fmt.Printf("ich absolutna hodnota rozdielu je: %d\n", a)
}

// porovna dve cele cisla a,b a vrati -1 (a<b), 0 (a==b), 1 (a>b)
func compare2Nat() {
	input("zadaj prve cele cislo:")
	a=-a
	sum2Int1()  // -M+N
	if (a > 0) {
		a = -1
	} else if (a < 0) {
		a = 1
	}
	fmt.Printf("ich compare je: %d\n", a)
}


func dveNaNtu() {
	if (a == 0) {
		input("zadaj druhe cislo:")
		triNaNtu()
	} else {
		a--
		dveNaNtu()
		a=a+a
	}
}

func triNaNtu() {
	if (a == 0) {
		a = 1
	} else {
		a--
		triNaNtu()
		a=a+a+a
	}
}

func logaritmus6() {
	if (a % 6 == 0) {
		a = a / 6
		logaritmus6()
		a++
	} else if (a % 3 == 0) {
		a = a / 3
		logaritmus6()
		a++
	} else if (a % 2 == 0) {
		a = a / 2
		logaritmus6()
		a++
	} else {
		a = 0
	}
}
func maximum() {
	input("zadaj prve cislo:")
	dveNaNtu()
	logaritmus6()
	fmt.Printf("ich maximum je: %d\n", a)
}