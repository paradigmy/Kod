package main

import (
	"fmt"
	"time"
)

var number = 1000000

func main() {
	start := time.Now()
	prev := make(chan int)
	first := prev
	for i := 0; i < number; i++ {
		next := make(chan int)
		go func(from, to chan int) {
			for {
				to <- 1 + <-from
			}
		}(prev, next)
		prev = next
	}
	//go func() {
	//}()
	//elapsed := time.Since(start)
	elapsed := time.Since(start)
	first <- 0
	fmt.Println(<-prev)
	fmt.Println(elapsed)
}
