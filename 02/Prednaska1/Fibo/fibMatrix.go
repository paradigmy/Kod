package main

import "fmt"

type Matrix struct {
	a11, a12, a21, a22 int
}

func (m *Matrix) multiply(n *Matrix) *Matrix {
	var c = &Matrix{
		m.a11*n.a11 + m.a12*n.a21,
		m.a11*n.a12 + m.a12*n.a22,
		m.a21*n.a11 + m.a22*n.a21,
		m.a21*n.a12 + m.a22*n.a22}
	return c
}

func (m *Matrix) power(n int) *Matrix {
	if n == 1 {
		return m
	} else if n%2 == 0 {
		m2 := m.power(n / 2)
		return m2.multiply(m2)
	} else {
		return m.power(n - 1).multiply(m)
	}
}

func FibMatrix(n int) int {
	m := &Matrix{a11: 1, a12: 1, a21: 1, a22: 0}
	p := m.power(n)
	return p.a12
}

func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)
	res :=FibMatrix(n)
	fmt.Println(res)
}