package main

import (
	"fmt"
	"math/big"
)

type MatrixBig struct {
	a11, a12, a21, a22 *big.Int
}

func (m *MatrixBig) multiply(n *MatrixBig) *MatrixBig {
	tmp1 := new(big.Int)
	tmp2 := new(big.Int)
	tmp11 := new(big.Int)
	tmp12 := new(big.Int)
	tmp21 := new(big.Int)
	tmp22 := new(big.Int)
	var c = &MatrixBig{
		tmp11.Add(tmp1.Mul(m.a11, n.a11), tmp2.Mul(m.a12, n.a21)),
		tmp12.Add(tmp1.Mul(m.a11, n.a12), tmp2.Mul(m.a12, n.a22)),
		tmp21.Add(tmp1.Mul(m.a21, n.a11), tmp2.Mul(m.a22, n.a21)),
		tmp22.Add(tmp1.Mul(m.a21, n.a12), tmp2.Mul(m.a22, n.a22))}
	return c
}

func (m *MatrixBig) power(n int) *MatrixBig {
	if n == 1 {
		return m
	} else if n%2 == 0 {
		m2 := m.power(n / 2)
		return m2.multiply(m2)
	} else {
		return m.power(n - 1).multiply(m)
	}
}

func FibMatrixBig(n int) *big.Int {
	m := &MatrixBig{big.NewInt(1), big.NewInt(1), big.NewInt(1), big.NewInt(0)}
	p := m.power(n)
	return p.a12
}

func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)
	res :=FibMatrixBig(n)
	fmt.Println(res)
	str := res.String()
	fmt.Printf("prvych 10 cifier je: %s\n",str[0:10])
	fmt.Printf("dlzka: %d\n", len(str))
}