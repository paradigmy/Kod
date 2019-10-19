package main

import (
	"fmt"
	"math/rand"
	"time"
)

var (
	//N = 16		// pocet generalov 260
	//M = 5		// pocet klamarov
	//N = 31		// pocet generalov 260
	//M = 10		// pocet klamarov

	N = 13		// pocet generalov 260
	M = 4		// pocet klamarov
	//N = 10		// pocet generalov 260
	//M = 3		// pocet klamarov
	//N = 7		// pocet generalov 260
	//M = 2		// pocet klamarov
	//N = 7		// pocet generalov 1+7 + 7*6 = 50
	//M = 1		// pocet klamarov
	//N = 4		// pocet generalov 1+4 + 4*3 = 17
	//M = 1		// pocet klamarov
	agents 		[]*Agent
	finish 	    chan Value
	Counter	int	// pocet Messages
)
func dumpSpace() {
	for i := 0; i < len(agents); i++ {
		if (agents[i].traitor) {
			fmt.Printf("agent %v je klamar\n", agents[i].id)
		} else {
			fmt.Printf("agent %v je cestny\n", agents[i].id)
		}
	}
}
func dumpDecistions() {
	for i := 0; i < len(agents); i++ {
		if (agents[i].traitor) {
			fmt.Printf("agent %v je klamar\n", agents[i].id)
		} else {
			fmt.Printf("agent %v je cestny a rozhodol sa %v\n", agents[i].id, agents[i].decistion)
		}
	}
}

func main() {
	rand.Seed(time.Now().UTC().UnixNano())
	Counter = 0
	agents = make([]*Agent, N)
	for i := 0; i < N; i++ {
		//agents[i] = newAgent(i, make(chan Message,1115))
		//agents[i] = newAgent(i, make(chan Message,11150))
		agents[i] = newAgent(i, make(chan Message,1115000))
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
		Counter++
		agents[0].channel <- Message{M+1, initOrder, []int{}, others, UNKNOWN}
		result :=  <-finish
		fmt.Printf("Prisla Bsprava main, %v \n", result.toString())
	}()
	time.Sleep(1000000000)
	dumpDecistions()
	fmt.Printf("Finish, #Messages: %v\n", Counter)
	for i := 0; i < len(agents); i++ {
		//fmt.Printf("%v::%v\n", agents[i].id, agents[i].children)
		//agents[i].traverse("0,")
		if (!agents[i].traitor) {
			fmt.Printf("agent %v::%v\n", agents[i].id, agents[i].postorder("0,"))
		}
	}
}
