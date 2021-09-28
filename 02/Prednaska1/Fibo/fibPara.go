package main

import (
	"fmt"
)

var channelCounter = 0
var goRoutinesCounter = 0
var trivialCases = 0

func FibPara(n int, ch chan int) {
	if n <= 2 {
		ch <- 1
		trivialCases++
	} else {
		ch1 := make(chan int)
		channelCounter++
		go FibPara(n-2, ch1)
		goRoutinesCounter++
		ch2 := make(chan int)
		channelCounter++
		go FibPara(n-1, ch2)
		goRoutinesCounter++
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
	go FibPara(n, ch)
	goRoutinesCounter++
	res := <- ch
	fmt.Println(res)
	fmt.Printf("#channels: %d\n", channelCounter)
	fmt.Printf("#goRutines: %d\n", goRoutinesCounter)
	fmt.Printf("#trivialCases: %d\n", trivialCases)
}


