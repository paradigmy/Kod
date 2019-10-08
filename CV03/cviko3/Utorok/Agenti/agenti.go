package main

import (
	"fmt"
	"time"
)

// agent generator, vrati kanal, do ktoreho sype prirodzene cisla
func generator() chan int {
	ch := make(chan int)
	go func(){
		i := 1
		for{
			ch <- i
			i++
		}
	}()
	return ch
}

// agent odd - cita z kanalu, a pusti do vystupu len neparne
func odd(in chan int) chan int {
	ch := make(chan int)
	go func(){
		for{
			x := <- in
			if x % 2 == 1{
				ch <- x
			}
		}
	}()
	return ch
}

// agent multiply - cita z kanalu, do vystup pusta vsetko ale vynasobene konstantou
func multiply(k int, in chan int) chan int {
	ch := make(chan int)
	go func(){
		for{
			x := <- in
			ch <- x * k
		}
	}()
	return ch
}

// agent mapper - cita z kanalu, do vystup pusta vsetko aplikovane funkciou
func mapper(in chan int, f func(int) int) chan int {
	ch := make(chan int)
	go func(){
		for{
			x := <- in
			ch <- f(x)
		}
	}()
	return ch
}

// agent withoutFirst - cita z kanalu, do vystup pusta vsetko okrem prveho
func withoutFirst(in chan int) chan int {
	ch := make(chan int)
	go func(){
		<- in
		for{
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
	go func(){
		x := <- in
		fmt.Print(x)
		for{
			i := <- in
			if i % x != 0{
				ch <- i
			}
		}
	}()
	return ch
}

// agent prvocisla - vytvori nekonecnu radu agentov erato, ktori filtruju prvocisla a vypisuju
// de facto, tento agent nepise nic do kanalu
func prvocisla(in chan int) {
	prvocisla(eratosten(in))
	//for {
	//	next := eratosten(in)
    //    in = next
	//	time.Sleep(time.Duration(100) * time.Millisecond)
	//}
}

func eratosten1(in chan int, primes chan int) chan int {
	ch := make(chan int)
	go func(){
		x := <- in
		//fmt.Print(x)
		primes <- x
		for{
			i := <- in
			if i % x != 0{
				ch <- i
			}
		}
	}()
	return ch
}

func prvocisla1(in chan int) chan int {
	primes := make(chan int)
	for i := 0;  i<1000; i++ {
		next := eratosten1(in, primes)
		in = next
	}
	return primes
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

// vylepseny fibonacciho agent
func newfiber() chan int {
	return make(chan int) // dorobit
}

func main() {
	//printer(100, generator())
	//printer(100, odd(generator()))
	//printer(100, multiply(2, odd(generator())))
	//printer(100, withoutFirst(multiply(2, odd(generator()))))
	//printer(100, mapper(generator(), func(x int) int { return x * x }))
	//printer(100,eratosten(withoutFirst(multiply(2, odd(generator())))))
	//printer(100,withoutFirst(generator()))
	printer(100, prvocisla1(withoutFirst(generator())))
	//printer(100, joinerf(generator(), generator(), func(x, y int) int { return x + y }))
	//////////////////////////////////////// pozor !!!
	//prvocisla(withoutFirst(generator()))
	//printer(1000, fiber())
	//printer(100, newfiber())
}
