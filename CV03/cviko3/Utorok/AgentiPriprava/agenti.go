package main

import (
	"fmt"
	"time"
)

// agent generator, vrati kanal, do ktoreho sype prirodzene cisla, 1, ...
func generator() chan int {
	ch := make(chan int)
	go func() {
		i:=1
		for  {
			ch <- i
			i++
			//fmt.Print(".")
			time.Sleep(time.Duration(10) * time.Millisecond)
		}
	}()
	return ch
}

// agent odd - cita z kanalu, a pusti do vystupu len neparne
func odd(in chan int) chan int {
	ch := make(chan int)
	go func() {
		for  {
			x := <- in
			if (x % 2 > 0) {
				ch <- x
			}
		}
	}()
	return ch
}

// agent multiply - cita z kanalu, do vystup pusta vsetko ale vynasobene konstantou
func multiply(k int, in chan int) chan int {
	ch := make(chan int)
	go func() {
		for  {
			x := <- in
			ch <- x * k
		}
	}()
	return ch
}

// agent mapper - cita z kanalu, do vystup pusta vsetko aplikovane funkciou
func mapper(in chan int, f func(int) int) chan int {
	ch := make(chan int)
	go func() {
		for  {
			x := <- in
			ch <- f(x)
		}
	}()
	return ch
}

// agent withoutFirst - cita z kanalu, do vystup pusta vsetko okrem prveho
func withoutFirst(in chan int) chan int {
	ch := make(chan int)
	go func() {
		<-in
		for  {
			x := <- in
			ch <- x
		}
	}()
	return ch
}

// agent eratosten - cita z kanalu, prvy si zapamata (a vypise), a do kanalu pusta len tie,
// ktore nie su delitelne prvym
func eratosten(in chan int) chan int {
	ch := make(chan int)
	go func() {
		prime := <-in
		fmt.Print(prime)
		for {
			x := <-in
			if (x % prime > 0) {
				ch <- x
			}
		}
	}()
	return ch
}
func eratostenCH(in chan int) (prime int, ch chan int) {
	ch = make(chan int)
	prime = <-in
	go func() {
		for {
			x := <-in
			if (x % prime > 0) {
				ch <- x
			}
		}
	}()
	return prime,ch
}

// agent prvocisla - vytvori nekonecnu radu agentov eratosten, ktori filtruju prvocisla a vypisuju
// de facto, tento agent nepise nic do kanalu
func prvocisla(in chan int)  {
	prvocisla(eratosten(in))
}

func prvocislaCH(in chan int) chan int {
	pch := make(chan int)
	go func() {
		for {
			prvo, next := eratostenCH(in)
			pch <- prvo
			in = next
		}
	}()
	return pch
}

// agent, ktory spaja hodnoty z ch1 a ch2 pomocou funkcie f
func joinerf(ch1, ch2 chan int, f func(int, int) int) chan int {
	return make(chan int)
}

// agent Printer - cita z kanalu, jemne sleepne, a tlaci na koznolu
func printer(delay int, ch chan int) {
	for msg := range ch {
		fmt.Printf("%v," , msg)
		time.Sleep(time.Duration(delay) * time.Millisecond)
	}
}

// agent rozdvojovac, co pride z ch, posle do ch1, ch2
func splitter(ch chan int) (ch1 chan int, ch2 chan int) {
	ch1 = make(chan int)
	ch2 = make(chan int)
	go func() {
		for {
			val := <-ch
			// ch1 <- val  deadlock! why ?
			// ch2 <- val
			go func() { ch1 <- val }()
			go func() { ch2 <- val }()
		}
	}()
	//go func() {
	//	for {
	//		val := <-ch
	//		select {
	//			case ch1 <- val:
	//			case ch2 <- val:
	//		}
	//	}
	//}()
	return ch1, ch2
}

func main() {
	//printer(100, generator())
	//printer(100, odd(generator()))
	// printer(100, multiply(2, odd(generator())))
	//printer(100, withoutFirst(multiply(2, odd(generator()))))
	//printer(100, mapper(generator(), func(x int) int { return x * x }))
	//printer(100, eratosten(withoutFirst(odd(generator()))))
	//printer(100,withoutFirst(generator()))
	//prvocisla(withoutFirst(generator()))
	//printer(100, prvocislaCH(withoutFirst(generator())))
	//printer(100, joinerf(generator(), generator(), func(x, y int) int { return x + y }))
	//////////////////////////////////////// pozor !!!
	ch1, ch2 := splitter(generator())
	//go printer12(100, true, ch1)
	//go printer12(200, false, ch2)
	go verify(100, true, ch1)
	go verify(20, false, ch2)

	time.Sleep(100000000000)
	//printer(100, newfiber())
}

// agent Printer - cita z kanalu, jemne sleepne, a tlaci na koznolu
func printer12(delay int, flag bool, ch chan int) {
	for msg := range ch {
		if (flag) {
			fmt.Printf("[%v],", msg)
		} else {
			fmt.Printf("(%v),", msg)
		}
		time.Sleep(time.Duration(delay) * time.Millisecond)
	}
}

// agent Printer - cita z kanalu, jemne sleepne, a tlaci na koznolu
func verify(delay int, flag bool, ch chan int) {
	last := 0
	for msg := range ch {
		if (msg != last+1) {
			if (flag) {
				fmt.Printf("[%v-%v],\n", last, msg)
			} else {
				fmt.Printf("(%v-%v),\n", last, msg)
			}
		}
		last = msg
		time.Sleep(time.Duration(delay) * time.Millisecond)
	}
}
