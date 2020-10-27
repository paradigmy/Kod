package main

import (
	"fmt"
	"sync"
	"time"
)

var goroutinesCount2 = 0;
var goroutinesMax2 = 0;
var mutex2 = &sync.Mutex{}

func timer2(d time.Duration, ch chan int) {
	go func() {
		//mutex2.Lock()
		goroutinesCount2++;
		if goroutinesCount2 > goroutinesMax2 {
			goroutinesMax2 = goroutinesCount2
		}
		//mutex2.Unlock()
		time.Sleep( d)   // 0
		ch <- 1
		//mutex2.Lock()
		goroutinesCount2--;
		//mutex2.Lock()
	}()
}

func main() {
	ch := make(chan int)
	for i := 0; i < 24; i++ {
		timer2(time.Duration(3+i) * time.Second, ch)
	}
	for x := range ch {
		fmt.Println(x,  ", maxGoroutines=", goroutinesMax2)
	}
}