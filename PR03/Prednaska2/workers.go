package main

import (
	"fmt"
	"math"
	"runtime"
	"sync"
	"time"
)
//var WORKERS	=  10  					// optimista...
var WORKERS	=  runtime.NumCPU();  	// pocet jadier
var TASKS = 100;
var SALARY = make([]int, WORKERS)
var LOGS = make([]int, WORKERS)

type Task struct {
	a, b int			// vynasob tieto dve cisla
}

func worker(id int, ch <-chan Task, wg *sync.WaitGroup) {
	defer wg.Done()
	for {
		task, ok := <-ch
		if !ok {			// ak dosla robota
			return
		}
		result := task.a*task.b;
		d := time.Duration(math.Log2(float64(result))) * time.Millisecond
		time.Sleep(d)
		SALARY[id]++
		LOGS[id] += int(math.Floor(math.Log2(1+float64(result))))
		fmt.Printf("worker %d has result %d*%d=%d \t $%d\tBits %d\n", id, task.a, task.b, result, SALARY[id], LOGS[id])
	}
}

func pool(wg *sync.WaitGroup) {
	ch := make(chan Task)
	for i := 0; i < WORKERS; i++ {
		go worker(i, ch, wg)
	}
	for i := 0; i < TASKS; i++ {
		for j := 0; j < TASKS; j++ {
			ch <- Task{i, j}
		}
	}
	close(ch)
}

func main() {
	var wg sync.WaitGroup
	wg.Add(WORKERS)
	go pool(&wg)
	wg.Wait()
	for id:=0; id<WORKERS; id++ {
		fmt.Printf("$%d\tBits %d\n", SALARY[id], LOGS[id])
	}
}