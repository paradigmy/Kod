// cvicenie2
package main

import (
	"fmt"
	"math/big"
	"time"
)

// faktorial v int64=long z minuleho cvicenia (int->int64), ziadna zahada
func fact(n int64) int64 {
	if n == 0 {
		return 1
	} else {
		return n * fact(n-1)
	}
}

// super naivna implementacia kombinacneho cisla
func comb(n int64, k int64) int64 {
	return fact(n) / (fact(n-k) * fact(k))
}

//-----------------------------------------------------------------------------------
// ULOHA: prerobte horeuveden funkcie do big.Int aritmetiky

// tato funkcia pocita faktorial pre velke cisla
func factBig(n int64) *big.Int {
	if n < 2 {
		return big.NewInt(1)
	} else {
		x := big.NewInt(n)
		return x.Mul(x, factBig(n-1))
		//x := FactBig(n-1)	// pomale !
		//return x.Mul(x, big.NewInt(int64(n)))
	}
}

// implementuje n nad k ako n!/((n-k)!*k!)
func combBig(n int64, k int64) *big.Int {
	citatel := factBig(n)
	menovatel := factBig(n - k)
	menovatel2 := factBig(k)
	tmp := citatel.Div(citatel, menovatel)
	return tmp.Div(tmp, menovatel2)
}

func combBig1(n int64, k int64) *big.Int {
	tmp := big.NewInt(1)
	return tmp.Div(sucin(n-k+1, n), sucin(1, k))
}

//-----------------------------------------------------------------------------------
// ULOHA: horeuvedena definicia pre comb je zbytocne neefektivna

// definujte funkciu sucin - tato funkcia pocita a.(a+1)....(b)
func sucin(a int64, b int64) *big.Int {
	accumulator := big.NewInt(1)
	for i := a; i <= b; i++ {
		accumulator = accumulator.Mul(accumulator, big.NewInt(i))
	}
	return accumulator
}

func sucin1(a int64, b int64) *big.Int {
	if a == b {
		return big.NewInt(a)
	}

	mid := (a + b) >> 1
	leftMul := sucin1(a, mid)
	rightMul := sucin1(mid+1, b)
	return leftMul.Mul(leftMul, rightMul)
}

// definujte funkciu sucin pomocou delenia intervalu
// tato funkcia pocita a.(a+1)....(b) binarnym delenim intervalu
// func sucinDivide(a int64, b int64) *big.Int {

// tato funkcia pocita a.(a+1)....(b) binarnym delenim intervalu, ale max 4 cisla vynasobi ako int64
//func sucinDivideGranula(a int64, b int64) *big.Int {

//--------------------------------------------------------------

// pomocou sucin... implementuje comb, implementuje n nad k ako n....(n-k+1)/k!
/*
func comb1(n int64, k int64) *big.Int {
	citatel := sucin(n-k+1, n)
	citatel.Div(citatel, factBig(k))
	return citatel
}
*/
// implementuje n nad k ako n!/((n-k)!*k!), sparalelizujte vypocty troch faktorialov
// func combPara(n int64, k int64) *big.Int {

// implementuje n nad k ako n....(n-k+1)/k! s konkurentnym vypoctom
// func comb1Para(n int64, k int64) *big.Int {

// postupne odkomentujte
func main() {
	fmt.Printf("10! = %d\n", fact(10))
	fmt.Printf("Comb(5,2) = %d\n", comb(5, 2))

	fmt.Printf("10! = %d\n", factBig(10))
	fmt.Printf("CombBig(5,2) = %d\n", combBig(5, 2))
	var n int64 = 90000
	fmt.Printf("CombBig(%d,%d) = %d\n", n, n/2, combBig1(n, n/2))

	fmt.Printf("1000! = %d\n", sucin1(1, 1000))
	/*	fmt.Printf("10! = %d\n", sucinDivide(1, 10))
		fmt.Printf("10! = %d\n", sucinDivideGranula(1, 10))
	*/
	// var n int64
	/*
		for n = 1; n <= 1000; n++ {
			f := factBig(n)
			fmt.Printf("Fact(%d) = %d a ma %d cifier\n", n, f, len(f.String()))
		}
		for n = 1; n <= 1000; n++ {
			f := combBig(n, n/2)
			fmt.Printf("comb(%d, %d) = %d a ma %d cifier\n", n, n/2, f, len(f.String()))
		}
	*/
	n = 50000
	start := time.Now()
	//--------
	fmt.Printf("%v\n", time.Since(start))

	start = time.Now()
	fmt.Printf("combBig(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combBig1(n, n/2).String()), time.Since(start))

	/*
	start = time.Now()
	fmt.Printf("combPara(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combPara(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1Para(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1Para(n, n/2).String()), time.Since(start))

	n = 100000
	fmt.Printf("combBig(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combBig(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("combPara(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combPara(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1Para(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1Para(n, n/2).String()), time.Since(start))
    */
}
