package main

import (
	"fmt"
	"time"
)

var limit = 15000

func main() {
	start := time.Now()
	prev := make(chan int)
	primes := make(chan int, limit)
	first := prev
	go func() {
		for i := 2; ; i++ {
			first <- i
		}
	}()
	//go func() {
		for i := 0; i < limit; i++ {
			prime := <-prev
			//fmt.Printf("%d, ", prime)
			////////////
			primes <- prime
			next := make(chan int)
			go func(prime int, from, to chan int) {
				for {
					val := <-from
					if val%prime > 0 {
						to <- val
					}
				}
			}(prime, prev, next)
			prev = next
		}
	//}()
	//for res := range prev {
	//	fmt.Print(res)
	//}
	for res := range primes {
		fmt.Printf("%d, ", res)
	}

	fmt.Println(time.Since(start))
}

func main5() {
	start := time.Now()
	primes(limit)
	elapsed := time.Since(start)
	fmt.Println()
	fmt.Println(elapsed)
}

func primes(n int) {
	pole := make([]int, n)
	i := 0
	for j := 3; i < n; j++ {
		if isPrime(j) {
			pole[i] = j
			i++
		}
	}
	fmt.Println(pole)
}
func isPrime(n int) bool {
	if n == 1 {
		return false
	}
	if n == 2 {
		return false
	}
	if n%2 == 0 {
		return false
	}
	for i := 3; i*i <= n; i++ {
		if n%i == 0 {
			return false
		}
	}
	return true
}
