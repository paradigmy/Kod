
package main

import (
	"fmt"
	"math/rand"
	"time"
)

//type Cislo float64 // toto si nechame na realne testovanie, zataz
type Cislo int		// cele cisla su fajn, aby sme vedeli skontrolovat vysledok
type Matica [][]Cislo
type Vektor []Cislo

// vygeneruj nahodnu maticu rozmeru n x n, nic len dvojity cyklus...
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

// vygeneruj nahodnu maticu rozmeru n x n, nic len dvojity cyklus...
func generujMaticuObdlznikovu(rows int, cols int) Matica {
	m := make(Matica, rows)
	for i := range m {
		m[i] = make(Vektor, cols)
		for j := range m[i] {
			//m[i][j] = Cislo(rand.Float64())
			m[i][j] = Cislo(rand.Int31n(5))
		}
	}
	return m
}

// vytlac maticu, dvojity cyklus
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

// A . trans(B)  .. [i,j]

// sucin vektorov - doprogramuj
func sucin(a Vektor, b Vektor) (s Cislo) {
	if (len(a) != len(b) ) {
		s = 0
	} else {
		s = 0
		for i := 0; i < len(a); i++ {
			s += a[i]*b[i]
		}
	}
	return s
}

// transponuj maticu - najdi chybu
func (m Matica)transponujMaticu() Matica {
	r := make(Matica, len(m[0]))	// vytvor maticu, ktora ma tolko riadkov, ako povodna stlpcov
	//for i := 0; i < len(m[0]); i++ {				// vytvor podpolia vyslednej matice
	for i := range m[0] {				// vytvor podpolia vyslednej matice
		r[i] = make(Vektor, len(m))	// ich riadkov novej matice bude rovnaka, ako pocet stlpcov povodnej matice
	}
	for i := range m {				// preloz to tam, cyklus cez riadky povodnej
		for j := range m[i] {		// cyklus cez stlpce povodnej
			r[j][i] = m[i][j]		// hlavne si nepomylit indexy
		}
	}
	return r
}
/*

1 2 3
4 5 6
7 8 9

podmatica, co neobsahuje riadok s indexom 1, a stlpec s indexom 1
1 3
7 9
*/


// podmatica, neobsahuje i ty riadok a jty stlpec - doprogramuj
func (m Matica)podMatica(i int, j int) Matica {
	r := append(m[0:i], m[i+1:len(m)]...).transponujMaticu()
	q := append(r[0:j], r[j+1: len(r)]...).transponujMaticu()
	return q
	// drevorubacske riesenie - toto zahod a prepogramuj
	//res := generujMaticuObdlznikovu(len(m)-1, len(m[0])-1)
	//aa := 0
	//for a := range m {
	//	if (a == i) {
	//		continue
	//	}
	//	bb := 0
	//	for b := range m[a] {
	//		if (b == j) {
	//			continue
	//		}
	//		res[aa][bb] = m[a][b]
	//		bb++
	//	}
	//	aa++
	//}
	//return res
}

func main() {
	rand.Seed(time.Now().UTC().UnixNano())  // inicializacia randomu
	m1 := generujMaticu(3)
	m1.Print("m1")
	m2 := generujMaticu(3)
	m2.Print("m2")
	fmt.Println(sucin(m1[0], m2[0]))
	//m2.transponujMaticu().Print("trans-m2")
	m2.podMatica(1,1).Print("podmatica")
	//
	//
	mx := generujMaticuObdlznikovu(2,7)
	mx.Print("mx")
	mx.transponujMaticu().Print("mx-trans")
}



































