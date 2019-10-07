package main

import (
	"fmt"
	"math/rand"
	"time"
)

func loopAndSend(task string, ch chan string) {
	for i := 1; i < 30; i++ {
		ch <- fmt.Sprintf("%s:%d\n", task, i)
		time.Sleep(time.Duration(rand.Intn(500)) * time.Millisecond)
	}
}

func main() {
	ch := make(chan string)
	go loopAndSend("prvy", ch)
	go loopAndSend("druhy", ch)

	for {
		//msg := <-ch
		fmt.Print(<-ch)
	}

	//for msg := range ch {
	//	fmt.Print(msg)
	//}

	fmt.Println("main stop")
}
