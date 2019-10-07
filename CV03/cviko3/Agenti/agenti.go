package main

import (
	"fmt"
	"time"
)

var (
	gen     = 0 // pocet volani generatora
	odde    = 0 // pocet volani agenta odd
	multi   = 0 //    -- " --
	mapp    = 0
	fib     = 0
	newfib  = 0
	split   = 0
	without = 0
	erato   = 0
	join    = 0
)

// agent generator, vrati kanal, do ktoreho sype prirodzene cisla
func generator() chan int {
	ch := make(chan int)
	gen++
	go func() {
		for i := 1; ; i++ {
			ch <- i
		}
	}()
	return ch
}

// agent odd - cita z kanalu, a pusti do vystupu len neparne
func odd(in chan int) chan int {
	ch := make(chan int)
	odde++
	go func() {
		for msg := range in {
			if msg%2 > 0 {
				ch <- msg
			}
		}
	}()
	return ch
}

// agent multiply - cita z kanalu, do vystup pusta vsetko ale vynasobene konstantou
func multiply(k int, in chan int) chan int {
	ch := make(chan int)
	multi++
	go func() {
		for msg := range in {
			ch <- msg * k
		}
	}()
	return ch
}

// agent mapper - cita z kanalu, do vystup pusta vsetko aplikovane funkciou
func mapper(in chan int, f func(int) int) chan int {
	ch := make(chan int)
	mapp++
	go func() {
		for msg := range in {
			ch <- f(msg)
		}
	}()
	return ch
}

// agent withoutFirst - cita z kanalu, do vystup pusta vsetko okrem prveho
func withoutFirst(in chan int) chan int {
	ch := make(chan int)
	<-in
	without++
	go func() {
		for {
			// ch <- <-in :-)
			val := <-in
			ch <- val
		}
	}()
	return ch
}

// agent eratosten - cita z kanalu, prvy si zapamata (a vypise), a do kanalu pusta len tie, ktore nie su delitelne prvym
func eratosten(in chan int) chan int {
	ch := make(chan int)
	prvo := <-in
	fmt.Printf("%v,", prvo)
	time.Sleep(time.Duration(100) * time.Millisecond)
	erato++
	go func() {
		for {
			// ch <- <-in :-)
			val := <-in
			if val%prvo != 0 {
				ch <- val
			}
		}
	}()
	return ch
}

// agent prvocisla - vytvori nekonecnu radu agentov erato, ktori filtruju prvocisla a vypisuju
// de facto, tento agent nepise nic do kanalu
func prvocisla(in chan int) chan int {
	return prvocisla(eratosten(in))
}

// agent, ktory spaja hodnoty z ch1 a ch2 pomocou funkcie f
func joinerf(ch1, ch2 chan int, f func(int, int) int) chan int {
	ch := make(chan int)
	join++
	go func() {
		for {
			f1 := <-ch1
			f2 := <-ch2
			ch <- f(f1, f2)
		}
	}()
	return ch
}

// agent Printer - cita z kanalu, jemne sleepne, a tlaci na koznolu
func printer(prName string, delay int, ch chan int) {
	for msg := range ch {
		fmt.Printf("%s%d\t[gen=%d\t odde=%d\t multi=%d\t mapp=%d\t fib=%d\t newfib=%d\t split=%d\t without=%d\t join=%d\t erato=%d]\n",
			prName, msg,
			gen, odde, multi, mapp, fib, newfib, split, without, join, erato)
		time.Sleep(time.Duration(delay) * time.Millisecond)
	}
}

// fibonacciho agent najivne
func fiber() chan int {
	ch := make(chan int)
	fib++
	go func() {
		ch <- 1
		ch <- 1
		for val := range joinerf(fiber(), withoutFirst(fiber()), func(x, y int) int { return x + y }) {
			ch <- val
		}
	}()
	return ch
}

// agent rozdvojovac, co pride z ch, posle do ch1, ch2
func splitter(ch chan int) (ch1 chan int, ch2 chan int) {
	ch1 = make(chan int)
	ch2 = make(chan int)
	split++
	go func() {
		for {
			val := <-ch
			// ch1 <- val  deadlock! why ?
			// ch2 <- val
			go func() { ch1 <- val }()
			go func() { ch2 <- val }()
		}
	}()
	return ch1, ch2
}

func splitteralaBrcko(ch chan int) (ch1 chan int, ch2 chan int) {
	ch1 = make(chan int)
	ch2 = make(chan int)
	go func() {
		for {
			val := <-ch
			select {
			case ch1 <- val:
			case ch2 <- val:
			}
		}
	}()
	return ch1, ch2
}

// vylepseny fibonacciho agent
func newfiber() chan int {
	ch := make(chan int)
	newfib++
	go func() {
		ch <- 1
		ch <- 1
		ch1, ch2 := splitter(newfiber())
		for val := range joinerf(ch1, withoutFirst(ch2), func(x, y int) int { return x + y }) {
			ch <- val
		}
	}()
	return ch
}

func main() {
	//printer(100, generator())
	ch1, ch2 := splitteralaBrcko(generator())
	go func() { printer("A:", 100, ch1) }()
	go func() { printer("B:", 10, ch2) }()
	for {
	}
	//printer(100, odd(generator()))
	//printer(100,multiply(2, odd(generator())))
	//printer(100,withoutFirst(multiply(2, odd(generator()))))
	//printer(100,mapper(generator(), func(x int) int { return x * x }))
	//printer(100,eratosten(withoutFirst(multiply(2, odd(generator())))))
	//printer(100,withoutFirst(generator()))
	// prvocisla(withoutFirst(generator()))
	//////////////////////////////////////// pozor !!!
	//printer(1000, fiber())
	//printer(100, newfiber())
	// printer(0, newfiber()) // bez timeoutu
}
