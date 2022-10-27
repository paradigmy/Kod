package main

import (
	"fmt"
	"time"
)

// agent generator, vrati kanal, do ktoreho sype prirodzene cisla
func generator() chan int {
	ret_chan := make(chan int)
	go func() {
		x := 1
		for {
			ret_chan <- x
			x++
		}
	}()
	return ret_chan
}

// agent odd - cita z kanalu, a pusti do vystupu len neparne
func odd(in chan int) chan int {
	out := make(chan int)
	go func() {
		for i:= range in {
			if i%2 == 1 {
				out <- i
			}
		}
	}()

	return out
}

// agent multiply - cita z kanalu, do vystup pusta vsetko ale vynasobene konstantou
func multiply(k int, in chan int) chan int {
	out := make(chan int)
	go func() {
		for i:= range in {
			out <- k*i
		}
	}()
	return out
}

// agent mapper - cita z kanalu, do vystup pusta vsetko aplikovane funkciou
func mapper(in chan int, f func(int) int) chan int {
	out := make(chan int)
	go func() {
		for i := range in {
			out <- f(i)
		}
	}()
	return out
}

// agent withoutFirst - cita z kanalu, do vystup pusta vsetko okrem prveho
func withoutFirst(in chan int) chan int {
	out := make(chan int)
	<- in
	go func() {
		for {
			out <- <- in
		}
	}()
	return out
}

// agent eratosten - cita z kanalu, prvy si zapamata (a vypise), a do kanalu pusta len tie,
// ktore nie su delitelne prvym
func eratosten(in chan int) chan int {
	out := make(chan int)
	a := <- in
	fmt.Print(a," ")
	go func() {
		for {
			b := <-in
			if b%a != 0 {
				out <- b
			}
		}
	}()
	return out
}

// agent prvocisla - vytvori nekonecnu radu agentov erato, ktori filtruju prvocisla a vypisuju
// de facto, tento agent nepise nic do kanalu
func prvocisla(in chan int) {
	for {
		in = eratosten(in)
	}
}

func eratosten1(in chan int, primes chan int) chan int {
	return nil
}

func prvocisla1(in chan int) chan int {
	return nil  // dorobit
}

// agent, ktory spaja hodnoty z ch1 a ch2 pomocou funkcie f
func joinerf(ch1, ch2 chan int, f func(int, int) int) chan int {
	return make(chan int)
}

// agent Printer - cita z kanalu, jemne sleepne, a tlaci na koznolu
func printer(delay int, ch chan int) {
	for msg := range ch {
		fmt.Print(msg, " ")
		time.Sleep(time.Duration(delay) * time.Millisecond)
	}
}

// agent rozdvojovac, co pride z ch, posle do ch1, ch2
func splitter(ch chan int) (ch1 chan int, ch2 chan int) {
	ch1 = make(chan int)
	ch2 = make(chan int)


	return ch1, ch2
}


func main() {
	//printer(100, generator())
	//printer(100, odd(generator()))
	//printer(100, multiply(2, odd(generator())))
	//printer(100, withoutFirst(multiply(2, odd(generator()))))
	//printer(100, mapper(generator(), func(x int) int { return x * x }))
	//printer(100,eratosten(withoutFirst(multiply(2, odd(generator())))))
	//printer(100,eratosten(withoutFirst(generator())))
	prvocisla(withoutFirst(generator()))
	//printer(100, joinerf(generator(), generator(), func(x, y int) int { return x + y }))
	//////////////////////////////////////// pozor !!!
	//prvocisla(withoutFirst(generator()))
	//printer(1000, fiber())
	//printer(100, newfiber())
}
