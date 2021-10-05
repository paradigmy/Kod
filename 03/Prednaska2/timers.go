//http://divan.github.io/posts/go_concurrency_visualize/
package main

import (
	"fmt"
	"sync"
	"time"
)

var goroutinesCount = 0;
var goroutinesMax = 0;
var mutex = &sync.Mutex{}

func timer(d time.Duration) (ch chan int) {
	ch = make(chan int)
	go func() {
		mutex.Lock(); goroutinesCount++
		if goroutinesCount > goroutinesMax {
			goroutinesMax = goroutinesCount
		}
		mutex.Unlock()
		time.Sleep(d)
		ch <- 1
		mutex.Lock(); goroutinesCount--; mutex.Unlock()
	}()
	return
}

func main() {
	for i := 0; i < 24; i++ {
		c := timer(1 * time.Second)
		fmt.Println(<-c, ", maxGoroutines=", goroutinesMax)
	}
}