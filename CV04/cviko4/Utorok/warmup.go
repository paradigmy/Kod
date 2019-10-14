package main

import (
	"fmt"
	"math/rand"
)

//type Cislo float64 // toto si nechame na realne testovanie, zataz
type Cislo int
type Matica [][]Cislo
type Vektor []Cislo

// vytlac maticu
func (m Matica) Print(headline string) {
	fmt.Println(headline)
	for i := range m {
		for j := range m[i] {
			fmt.Printf("%v ", m[i][j])
		}
		fmt.Println()
	}
	fmt.Println()
}

// vygeneruj nahodnu maticu rozmeru n x n
func generujMaticu(n int) Matica {
	m := make(Matica, n)
	for i := range m {
		m[i] = make(Vektor, n)
		for j := range m[i] {
			//m[i][j] = Cislo(rand.Float64())
			m[i][j] = Cislo(rand.Int31n(5))
		}
	}
	return m
}

// sucin vektorov - doprogramuj
func sucin(a Vektor, b Vektor) (s Cislo) {
	return 0
}

// transponuj maticu - najdi chybu
func (m Matica)transponujMaticu() Matica {
	r := make(Matica, len(m[0]))
	for i := range m {
		r[i] = make(Vektor, len(m))
	}
	for i := range m {
		for j := range m[i] {
			r[j][i] = m[i][j]
		}
	}
	return r
}
// podmatica, neobsahuje i ty riadok a jty stlpec
func (m Matica)podMatica(i int, j int) Matica {
	r := append(m[0:i], m[i+1:len(m)]...).transponujMaticu()
	return append(r[0:j], r[j+1:len(r)]...).transponujMaticu()
}

func main() {
	m1 := generujMaticu(3)
	m1.Print("m1")
	m2 := generujMaticu(3)
	m2.Print("m2")
	fmt.Print(sucin(m1[0], m2[0]))
	m2.transponujMaticu().Print("trans-m2")
	m2.podMatica(1,1).Print("podmatica")
}
