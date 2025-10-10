package main

import (
	"fmt"
	"strconv"
)

func main() {
	input("zadaj prve.. ")
	dveNa()
	div6()

	//sum3Int_1()
	//compare2Nat()
	//maximum()
	fmt.Printf("vysledok je: %d\n", a)
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
	if a == 0 {
		input("druhe ")
	} else {
		a--
		sum2Nat()
		a++
	}
}

// súčet dvoch prirodzených čísel s jednou globalnou premennou
func sum2Int() {
	if a == 0 {
		input("druhe ")
	} else {
		if a > 0 {
			a--
			sum2Int()
			a++
		} else {
			a++
			sum2Int()
			a--
		}
	}
}

//#############################################################
//# GO 2- V jazyku Go napíšte program, ktorý načíta zo vstupu pomocou príkazu
//# input("zadaj cislo:")
//# tri CELÉ čísla a pomocou príkazu Printf(a)
//# vypíše ich súčet. V programe môžete použiť iba jednu globálnu celočíselnú
//# premennú "a" a procedúry/funkcie bez argumentov.
//# Program musí fungovať správne aj pre záporné hodnoty.

func sum3Int_1() {
	if a == 0 {
		input("druhe ")
		sum3Int_2()
	} else {
		if a > 0 {
			a--
			sum3Int_1()
			a++
		} else {
			a++
			sum3Int_1()
			a--
		}
	}
}

func sum3Int_2() {
	if a == 0 {
		input("tretie ")
	} else {
		if a > 0 {
			a--
			sum3Int_2()
			a++
		} else {
			a++
			sum3Int_2()
			a--
		}
	}
}

// súčet troch celých čísel s jednou globalnou premennou
func sum3Int() {
	sum2Int()
	sum2Int()
}

// ##########################################################
// # GO3 - Maximum dvoch celých čísel
// # V jazyku Go napíšte program, ktorý zo štandardného vstupu pomocou príkazu
// # input("zadaj cislo:")
// # načíta prirodzené čísla a pomocou príkazu Printf(a)
// # vypíše ich maximum.
// # V programe môžete použiť iba jednu globlnu celoeselnú premennú "a" a
// # procedúry bez argumentov.

// maximum dvoch prirodzených čísel s jednou globálnou premennou
func max2Nat() {
	if a == 0 {
		input("druhe")
	} else {
		a--
		max2Nat()
		a--
	}
}

func dveNa() {
	if a == 0 {
		input("druhe")
		triNa()
	} else {
		a--
		dveNa()
		a *= 2
	}
}

func triNa() {
	if a == 0 {
		a = 1
	} else {
		a--
		triNa()
		a *= 3
	}
}

func div6() {
	if a%6 == 0 {
		a /= 6
		div6()
		a++
	} else if a%3 == 0 {
		a /= 3
		div6()
		a++
	} else if a%2 == 0 {
		a /= 2
		div6()
		a++
	} else { // a==1
		a = 0
	}
}

// rozdiel dvoch celych čísel s jednou globalnou premennou
func diff2Nat() {

}

// porovna dve cele cisla a,b a vrati -1 (a<b), 0 (a==b), 1 (a>b)
func compare2Nat() {

}
