package main

import (
	"fmt"
	"math/rand"
	"time"
)

func f(n int) {
	for i := 5; i > 0; i-- {
		fmt.Println("#", n, ":", i)
		time.Sleep(time.Duration(rand.Intn(500)) * time.Millisecond)
	}
}
func main() {
	for i := 0; i < 5; i++ {
		go f(i)
	}
	var input string
	fmt.Scanln(&input)
	fmt.Println("main stop")
}
