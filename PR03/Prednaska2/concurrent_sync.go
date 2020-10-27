package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func loopForever1(task string, goGroup *sync.WaitGroup) {
	for i := 1; i < 100; i++ {
		fmt.Printf("%s:%d\n", task, i)
		time.Sleep(time.Duration(rand.Intn(500)) * time.Millisecond)
	}
	goGroup.Done()		// mutex--
}

func main() {
	goGroup := new(sync.WaitGroup)  // Mutex
	goGroup.Add(2)		// inicialna hodnota Mutexu
	go loopForever1("prvy", goGroup)
	go loopForever1("druhy", goGroup)
	goGroup.Wait()	// pockaj, kym mutex > 0
}
