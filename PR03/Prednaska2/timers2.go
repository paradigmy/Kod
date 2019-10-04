package main

import (
	"fmt"
	"time"
)

var goroutinesCount2 = 0;
var goroutinesMax2 = 0;

func timer2(d time.Duration, ch chan int) {
	go func() {
		goroutinesCount2++;
		if goroutinesCount2 > goroutinesMax2 {
			goroutinesMax2 = goroutinesCount2
		}
		time.Sleep( d)   // 0
		ch <- 1
		goroutinesCount2--;
	}()
}

func main() {
	ch := make(chan int)
	for i := 0; i < 24; i++ {
		timer2(time.Duration(i) * time.Second, ch)
	}
	for x := range ch {
		fmt.Println(x,  ", maxGoroutines=", goroutinesMax2)
	}
}