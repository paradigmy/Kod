package main

import (
	"fmt"
	"time"

	//	"time"
)

func main() {
	//ch := make(chan int   )
	ch := make(chan int, 4)
	go func () {
		time.Sleep(time.Duration(5 * time.Second))
		fmt.Println("idem citat")
		fmt.Printf("precitane %d \n", <-ch)
	} ()

	fmt.Println("idem zapisat")
	ch <- 1
	fmt.Println("zapisane 1")
	ch <- 2
	fmt.Println("zapisane 2")
	ch <- 3
	fmt.Println("zapisane 3")
	ch <- 4
	fmt.Println("zapisane 4")
	ch <- 5
	fmt.Println("zapisane 5")
	ch <- 6
	fmt.Println("zapisane 6")

	var input string   // toto čaká na input, v opačnom
	fmt.Scanln(&input) // prípade, keď umrie hlavné
	fmt.Println("main stop")
}