package main

import (
	"fmt"
	"time"
)

func producer(id int, cs chan int, delay time.Duration) {
	for i := 1; i <= 3; i++ {
		cs <- i
		fmt.Printf("producer %d item %d: \n", id, i)
		time.Sleep(delay)
	}
}

func consumer(cs chan int) {
	for x := range cs {
		fmt.Println("consume: ", x)
		time.Sleep(time.Second)
	}
}

func main() {
	//cs := make(chan int)
	cs := make(chan int, 5)
	go producer(1, cs, 100*time.Microsecond)
	go producer(2, cs, 250*time.Microsecond)
	go producer(3, cs, 350*time.Microsecond)
	go consumer(cs)
	time.Sleep(100000000000)
}
