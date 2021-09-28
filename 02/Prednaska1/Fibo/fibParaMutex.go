package main

import (
	"fmt"
	"sync"
)

var channelCount = 0
var goRoutinesCount = 0
var trivialCount = 0

var mutex = &sync.Mutex{}

func FibParaMutex(n int, ch chan int) {
	if n <= 2 {
		ch <- 1
		mutex.Lock(); trivialCount++; mutex.Unlock()
	} else {
		ch1 := make(chan int)
		mutex.Lock(); channelCount++; mutex.Unlock()
		go FibParaMutex(n-2, ch1)
		mutex.Lock(); goRoutinesCount++; mutex.Unlock()
		ch2 := make(chan int)
		mutex.Lock();channelCount++; mutex.Unlock()
		go FibParaMutex(n-1, ch2)
		mutex.Lock(); goRoutinesCount++; mutex.Unlock()
		n1 := <-ch1
		n2 := <-ch2
		ch <- n1 + n2
	}
}

//---------------------------------------------------------
func main() {
	var n int
	fmt.Print("zadaj N: ")
	_, _ = fmt.Scanf("%d", &n)
	ch := make(chan int)
	go FibParaMutex(n, ch)
	mutex.Lock(); goRoutinesCount++; mutex.Unlock()
	res := <- ch
	fmt.Println(res)
	fmt.Printf("#channels: %d\n", channelCount)
	fmt.Printf("#goRutines: %d\n", goRoutinesCount)
	fmt.Printf("#trivialCases: %d\n", trivialCount)
}


