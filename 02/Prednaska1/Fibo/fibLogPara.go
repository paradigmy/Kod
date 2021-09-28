package main

import (
	"fmt"
	"math/big"
)

func multipicator(a *big.Int, b *big.Int, ch chan *big.Int) {
	tmp := new(big.Int)
	ch <- tmp.Mul(a, b)
}

func FibPairBigPara(Fj *big.Int, Fj1 *big.Int) (*big.Int, *big.Int) {
	tmp := new(big.Int)
	tmp.Add(tmp.Add(Fj, Fj), Fj1)
	ch1 := make(chan *big.Int)
	go multipicator(tmp, Fj1, ch1)
	F2j := new(big.Int)

	ch2 := make(chan *big.Int)
	go multipicator(Fj, Fj, ch2)

	ch3 := make(chan *big.Int)
	go multipicator(Fj1, Fj1, ch3)

	F2j.Add(<-ch2, <-ch3)
	return F2j, <-ch1
}

func FibLogBigPara(n int) (*big.Int, *big.Int) {
	if n < 2 {
		return big.NewInt(0), big.NewInt(1)
	} else if n%2 == 1 {
		x, y := FibPairBigPara(FibLogBigPara(n / 2))
		return y, x.Add(y, x)
	} else {
		return FibPairBigPara(FibLogBigPara(n / 2))
	}
}

func FibLogBigPara1(n int) *big.Int {
	_, y := FibLogBigPara(n)
	return y
}

func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)
	res :=FibLogBigPara1(n)
	fmt.Println(res)
	fmt.Printf("dlzka: %d\n", len(res.String()))
}



