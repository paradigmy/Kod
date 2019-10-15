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
	r := make(Matica, len(m[0]))	// vytvor maticu, ktora ma tolko riadkov, ako povodna stlpcov
	for i := range m {				// vytvor podpolia vyslednej matice
		r[i] = make(Vektor, len(m))	// ich riadkov novej matice bude rovnaka, ako pocet stlpcov povodnej matice
	}
	for i := range m {				// preloz to tam, cyklus cez riadky povodnej
		for j := range m[i] {		// cyklus cez stlpce povodnej
			r[j][i] = m[i][j]		// hlavne si nepomylit indexy
		}
	}
	return r
}
// podmatica, neobsahuje i ty riadok a jty stlpec - doprogramuj
func (m Matica)podMatica(i int, j int) Matica {
	return m

}

func main() {
	//rand.Seed(time.Now().UTC().UnixNano())  // inicializacia randomu
	m1 := generujMaticu(3)
	m1.Print("m1")
	m2 := generujMaticu(3)
	m2.Print("m2")
	fmt.Print(sucin(m1[0], m2[0]))
	m2.transponujMaticu().Print("trans-m2")
	m2.podMatica(1,1).Print("podmatica")
}



































//r := append(m[0:i], m[i+1:len(m)]...).transponujMaticu()
//return append(r[0:j], r[j+1:len(r)]...).transponujMaticu()
