//http://divan.github.io/posts/go_concurrency_visualize/
package main

import (
	"fmt"
	"time"
)

var goroutinesCount = 0;
var goroutinesMax = 0;

func timer(d time.Duration) (ch chan int) {
	ch = make(chan int)
	go func() {
		goroutinesCount++;
		if goroutinesCount > goroutinesMax {
			goroutinesMax = goroutinesCount
		}
		time.Sleep(d)
		ch <- 1
		goroutinesCount--;
	}()
	return
}

func main() {
	for i := 0; i < 24; i++ {
		c := timer(1 * time.Second)
		fmt.Println(<-c, ", maxGoroutines=", goroutinesMax)
	}
}