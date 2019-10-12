package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"
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

// transponuj maticu
func transponujMaticu(m Matica) Matica {
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


func main() { // task.exe n port1, port2, ....
	if len(os.Args) < 2 {
		fmt.Println("usage: \n")
		fmt.Println("client.exe velkost port1, port2, ....\t- spusti skalarny server na porte")
	} else { // task.exe velkost port1, port2, ....
		N, _ := strconv.Atoi(os.Args[1]) // velkost matice
		m1 := generujMaticu(N)           // matica 1
		mx2 := generujMaticu(N)          // matica 2
		if N < 4 {                       // vacsie uz aj tak nevieme ciata
			m1.Print("Matica A:")
			mx2.Print("Matica B:")
		}
		m2 := transponujMaticu(mx2) // riadky za stlpce

		res := make(Matica, len(m1)) // vysledna matica
		for i := range res {
			res[i] = make(Vektor, len(m2))
		}
		start := time.Now() // ideme na to...
		chanRes := make(chan Result)
		wp := NewWorkerPool(os.Args[2:])
		for i := 0; i < len(m1); i++ {
			for j := 0; j < len(m2); j++ {
				v1 := m1[i]
				v2 := m2[j]
				//res[i][j] = sucin(v1, v2)
				task := &Task{i, v1, j, v2}
				//go task.doit()
				wp.addTask(task)
			}
		}
		go wp.mainLoop(chanRes)
		for ww := 0; ww < len(m1)*len(m2); ww++ {
			result := <-chanRes
			fmt.Printf("prisiel vysledok %v\n", result)
			res[result.I1][result.I2] = result.Skalar
		}

		fmt.Println(time.Since(start))
		if N < 4 {
			res.Print("Matica A*B:")
		}
	}
}
