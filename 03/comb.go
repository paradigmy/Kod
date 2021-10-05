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
	citatel := fact(n)
	menovatel := fact(k) * fact(n-k)
	return citatel / menovatel
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
	citatel.Div(citatel, factBig(k))
	citatel.Div(citatel, factBig(n-k))
	return citatel
}

//-----------------------------------------------------------------------------------
// ULOHA: horeuvedena definicia pre comb je zbytocne neefektivna

// definujte funkciu sucin - tato funkcia pocita a.(a+1)....(b)
func sucin(a int64, b int64) *big.Int {
	if a == b {
		return big.NewInt(a)
	} else {
		x := big.NewInt(a)
		return x.Mul(x, sucin(a+1, b))
	}
}

// definujte funkciu sucin pomocou delenia intervalu
// tato funkcia pocita a.(a+1)....(b) binarnym delenim intervalu
func sucinDivide(a int64, b int64) *big.Int {
	if a > b {
		return big.NewInt(1)
	} else if a == b {
		return big.NewInt(a)
	} else {
		c := (a + b) / 2
		x := sucinDivide(a, c)
		y := sucinDivide(c+1, b)
		return x.Mul(x, y)
	}
}

// tato funkcia pocita a.(a+1)....(b) binarnym delenim intervalu, ale max 4 cisla vynasobi ako int64
func sucinDivideGranula(a int64, b int64) *big.Int {
	if a > b {
		return big.NewInt(1)
	} else if a == b {
		return big.NewInt(a)
	} else if a+1 == b {
		return big.NewInt(a * (a + 1))
	} else if a+2 == b {
		return big.NewInt(a * (a + 1) * (a + 2))
	} else if a+3 == b {
		return big.NewInt(a * (a + 1) * (a + 2) * (a + 3))
	} else {
		c := (a + b) / 2
		x := sucinDivideGranula(a, c)
		y := sucinDivideGranula(c+1, b)
		return x.Mul(x, y)
	}
}

// tato funkcia pocita a.(a+1)....(b) zavola MulRange z big
func sucinMulRange(a int64, b int64) *big.Int {
	var x = big.NewInt(1)
	x.MulRange(a, b)
	return x
}

//--------------------------------------------------------------

// pomocou sucin... implementuje comb, implementuje n nad k ako n....(n-k+1)/k!
func comb1(n int64, k int64) *big.Int {
	citatel := sucin(n-k+1, n)
	citatel.Div(citatel, factBig(k))
	return citatel
}

// implementuje n nad k ako n!/((n-k)!*k!), sparalelizujte vypocty troch faktorialov
func combPara(n int64, k int64) *big.Int {
	citatelch := make(chan *big.Int)
	go Factorial(n, citatelch) // go rutina s menom Factorial

	menovatel1ch := make(chan *big.Int)
	go Factorial(k, menovatel1ch)

	delenie1ch := make(chan *big.Int)
	go func() { // anonymna go-rutina
		citatel := <-citatelch           // caka na citatel
		menovatel1 := <-menovatel1ch     // caka na menovatela
		citatel.Div(citatel, menovatel1) // ked ma oboch, tak pocita
		delenie1ch <- citatel            // zapise vysledok
	}() // tu musi mat prazdne() alebo argumenty

	delenie2ch := make(chan *big.Int)
	go func() {
		fn_k := factBig(n - k)
		menovatel := <-delenie1ch
		menovatel.Div(menovatel, fn_k)
		delenie2ch <- menovatel
	}()
	return <-delenie2ch
}

// implementuje n nad k ako n....(n-k+1)/k! s konkurentnym vypoctom
func comb1Para(n int64, k int64) *big.Int {
	citatelch := make(chan *big.Int)
	go func() {
		citatelch <- sucinMulRange(n-k+1, n)
	}()

	menovatelch := make(chan *big.Int)
	go func() {
		menovatelch <- sucinMulRange(1, k)
	}()

	citatel := <-citatelch
	citatel.Div(citatel, <-menovatelch)
	return citatel
}

func Factorial(n int64, ch chan *big.Int) {
	f := factBig(n)
	ch <- f
}

// postupne odkomentujte
func main() {
	fmt.Printf("10! = %d\n", fact(10))
	fmt.Printf("Comb(5,2) = %d\n", comb(5, 2))
	fmt.Printf("10! = %d\n", factBig(10))
	fmt.Printf("Comb(5,2) = %d\n", combBig(5, 2))

	fmt.Printf("10! = %d\n", sucin(1, 10))
	fmt.Printf("10! = %d\n", sucinDivide(1, 10))
	fmt.Printf("10! = %d\n", sucinDivideGranula(1, 10))

	var n int64

	for n = 1; n <= 1000; n++ {
		f := factBig(n)
		fmt.Printf("Fact(%d) = %d a ma %d cifier\n", n, f, len(f.String()))
	}
	for n = 1; n <= 1000; n++ {
		f := combBig(n, n/2)
		fmt.Printf("comb(%d, %d) = %d a ma %d cifier\n", n, n/2, f, len(f.String()))
	}
	n = 50000
	start := time.Now()
	//--------
	fmt.Printf("%v\n", time.Since(start))
	/* */
	start = time.Now()
	fmt.Printf("combBig(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combBig(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("combPara(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combPara(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1Para(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1Para(n, n/2).String()), time.Since(start))
	/* */
	n = 100000
	fmt.Printf("combBig(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combBig(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("combPara(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(combPara(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1(n, n/2).String()), time.Since(start))
	start = time.Now()
	fmt.Printf("comb1Para(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1Para(n, n/2).String()), time.Since(start))

	n = 1000000
	start = time.Now()
	fmt.Printf("comb1Para(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1Para(n, n/2).String()), time.Since(start))

	n = 10000000
	start = time.Now()
	fmt.Printf("comb1Para(%d, %d) ma %d cifier, time=%v\n", n, n/2, len(comb1Para(n, n/2).String()), time.Since(start))

}
