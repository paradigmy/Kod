package main

import (
	"fmt"
	"math/rand"
	"time"
)

func loopForever(task string) {
	for i := 1; ; i++ {
		fmt.Printf("%s:%d\n", task, i)
		time.Sleep(time.Duration(rand.Intn(500)) * time.Millisecond)
	}
}

func main() {
	go loopForever("prvy")
	go loopForever("druhy")
	var input string   // toto čaká na input, v opačnom
	fmt.Scanln(&input) // prípade, keď umrie hlavné
	fmt.Println("main stop")
}
