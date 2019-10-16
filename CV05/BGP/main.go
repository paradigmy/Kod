package main

import (
	"fmt"
	"math/rand"
	"time"
)

var (
	N = 4		// pocet generalov
	M = 1		// pocet klamarov
	agents 		[]*Agent
	finish 	    chan Value
)
func dumpSpace() {
	for i := 0; i < len(agents); i++ {
		fmt.Println(agents[i].toString())
	}
}

func main() {
	rand.Seed(time.Now().UTC().UnixNano())
	agents = make([]*Agent, N)
	for i := 0; i < N; i++ {
		agents[i] = newAgent(i, make(chan FMessage,5), make(chan BMessage,5))
	}
	traitors := 0
	for traitors < M {
		i := rand.Intn(N)
		if !agents[i].traitor {
			agents[i].traitor = true;
			traitors++;
		}
	}
	dumpSpace()
	for i := 0; i < N; i++ {
		agents[i].run()
	}
	others := make([]int, N-1)
	for i := 1; i < N; i++ {
		others[i-1] = i
	}
	finish = make(chan Value)
	initOrder := Value(1)//Value(rand.Intn(2))
	go func() {
		agents[0].fchannel <- FMessage{M + 1, initOrder, []int{0}, others}
		result :=  <-finish
		fmt.Printf("Prisla Bsprava main, %v \n", result.toString())
	}()
	time.Sleep(10000000000)
	fmt.Println("Finish")
}
