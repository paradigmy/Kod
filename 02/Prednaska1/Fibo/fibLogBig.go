package main

import (
	"fmt"
	"math/big"
)

func FibPairBig(Fj *big.Int, Fj1 *big.Int) (*big.Int, *big.Int) {
	tmp := new(big.Int)
	F2j1 := new(big.Int)
	F2j1.Mul(tmp.Add(tmp.Add(Fj, Fj), Fj1), Fj1)
	F2j := new(big.Int)
	F2j.Add(Fj.Mul(Fj, Fj), Fj1.Mul(Fj1, Fj1))
	return F2j, F2j1
}

func FibLogBig(n int) (*big.Int, *big.Int) {
	if n < 2 {
		return big.NewInt(0), big.NewInt(1)
	} else if n%2 == 1 {
		x, y := FibPairBig(FibLogBig(n / 2))
		return y, x.Add(y, x)
	} else {
		return FibPairBig(FibLogBig(n / 2))
	}
}

func FibLogBig1(n int) *big.Int {
	_, y := FibLogBig(n)
	return y
}

//---------------------------------------------------------
func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)
	res :=FibLogBig1(n)
	fmt.Println(res)
	str := res.String()
	fmt.Printf("prvych 10 cifier je: %s\n",str[0:10])
	fmt.Printf("dlzka: %d\n", len(str))
}
