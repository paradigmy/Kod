// fibBig
package main

import (
	"math/big"
)

func FibBig(n int) *big.Int {
	if n < 2 {
		return big.NewInt(1)
	}
	a := big.NewInt(0)
	b := big.NewInt(1)
	for n > 0 { // pascal-like while
		a.Add(a, b) // a = a+b
		b.Sub(a, b) // b = b-a
		n--
	}
	return a
}
//-----------------------------------
//func main() {
//	var n int
//	fmt.Print("zadaj N: ")
//	_, _ = fmt.Scanf("%d", &n)
//	res :=FibBig(n)
//	fmt.Println(res)
//	fmt.Printf("dlzka: %d\n", len(res.String()))
//}
