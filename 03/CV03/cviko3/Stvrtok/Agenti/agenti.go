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
			time.Sleep(1000 * time.Millisecond)
			ret_chan <- x
			x++
		}
	}()
	return ret_chan
}

func generator2() chan int {
	ret_chan := make(chan int)
	go func() {
		x := 1
		for {
			time.Sleep(2000 * time.Millisecond)
			ret_chan <- x
			x++
		}
	}()
	return ret_chan
}

// agent Printer - cita z kanalu, jemne sleepne, a tlaci na koznolu
func printer(delay int, ch chan int) {
	for msg := range ch {
		fmt.Print(msg, " ")
		time.Sleep(time.Duration(delay) * time.Millisecond)
	}
}

// agent multiply - cita z kanalu, do vystup pusta vsetko ale vynasobene konstantou
func multiply(k int, in chan int) chan int {
	out := make(chan int)
	go func() {
		for i := range in {
			out <- k * i
		}
	}()
	return out
}

// agent withoutFirst - cita z kanalu, do vystup pusta vsetko okrem prveho
func withoutFirst(in chan int) chan int {
	out := make(chan int)
	go func() {
		<-in
		for i := range in {
			out <- i
		}
	}()
	return out
}

// agent eratosten - cita z kanalu, prvy si zapamata (a vypise), a do kanalu pusta len tie,
// ktore nie su delitelne prvym
func eratosten(in chan int) chan int {
	out := make(chan int)
	go func() {
		a := <-in
		fmt.Print(a, ", ")
		for i := range in {
			if (i % a) != 0 {
				out <- i
			}
		}
	}()
	return out
}

// agent prvocisla - vytvori nekonecnu radu agentov erato, ktori filtruju prvocisla a vypisuju
// de facto, tento agent nepise nic do kanalu
func prvocisla(in chan int) {
	prvocisla(eratosten(in))
}

// agent, ktory spaja hodnoty z ch1 a ch2 pomocou funkcie f
func joinerf(ch1, ch2 chan int, f func(int, int) int) chan int {
	res := make(chan int)

	go func() {
		for {
			res <- f(<-ch1, <-ch2)
		}
	}()

	return res
}

// agent, ktory dava hodnoty z ch1 a ch2 do jedneho vystupneho kanalu(ch1 a ch2 nemusia produkovat hodnoty rovnako rychlo)
func demultiplexer(ch1, ch2 chan int) chan int {
	res := make(chan int)

	go func() {
		for {
			select {
			case val := <-ch1:
				res <- val
			case val := <-ch2:
				res <- val
			}
		}
	}()

	return res
}

// agent rozdvojovac, co pride z ch, posle do ch1, ch2
func splitter(ch chan int) (ch1 chan int, ch2 chan int) {
	return nil, nil
}

func main() {
	//printer(100, generator())
	//printer(100, odd(generator()))
	// printer(100, multiply(2, generator()))
	//printer(100, withoutFirst(multiply(2, generator())))
	//printer(100, mapper(generator(), func(x int) int { return x * x }))
	//printer(100, eratosten(withoutFirst(multiply(2, generator()))))
	//printer(100,eratosten(withoutFirst(generator())))
	//prvocisla(withoutFirst(generator()))
	//printer(100, joinerf(generator(), generator(), func(x, y int) int { return x + y }))
	//////////////////////////////////////// pozor !!!
	//prvocisla(withoutFirst(generator()))
	//printer(1000, fiber())
	//printer(100, newfiber())

	printer(1000, demultiplexer(generator(), generator2()))
}
