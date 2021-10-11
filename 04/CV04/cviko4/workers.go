package main

// pocitame malu/velku nasobiku s hodnotami a*b, kde a, b in 1..TASKS=100
// vyrobime si na to workerov, ich pocet je WORKERS, to budu nezavisle go rutiny
// workeri vysledok nasobenia pisu na konzolu, de-facto zahazduju
// kazdy worker je plateny od poctu vykonanych nasobeni a pocetu bitov vysledku, v sucte

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
var SALARY = make([]int, WORKERS)  // pocet vykonanych nasobeni workera
var LOGS = make([]int, WORKERS)    // pocet bitov, ktore worker spracoval

type Task struct {
	a, b int			// vynasob tieto dve cisla
}

func worker(id int, ch <-chan Task, wg *sync.WaitGroup) {
	defer wg.Done()			// na konci pred return, urob wg.Done, znizi muttex o 1
	for {					// worker iniciativne v cykle si berie robotu z poolu
		task, ok := <-ch	// vyber si prvu robotu z frontu taskov
		if !ok {			// ak dosla robota
			return			// worker konci, a od muttexu sa odpocita 1, jeden worker dorobil
		}
		result := task.a*task.b;	// a makaj na tom...
		d := time.Duration(math.Log2(float64(result))) * time.Millisecond
		time.Sleep(d)				// simulacia tazkej prace nasobilkoveho workera
		SALARY[id]++			// fakturacia vysledku, +1 za kazde nasobenie
		LOGS[id] += int(math.Floor(math.Log2(1+float64(result))))   // + pocet bitiov vysledku
		fmt.Printf("worker %d has result %d*%d=%d \t $%d\tBits %d\n",  // vypis ide len na konzolu
			id, task.a, task.b, result, SALARY[id], LOGS[id])
	}
}

func pool(wg *sync.WaitGroup) {
	ch := make(chan Task)
	for i := 0; i < WORKERS; i++ {
		go worker(i, ch, wg)		// tu sa spustia go rutiny workerov, v pocet WORKERS
	}
	for i := 0; i < TASKS; i++ {
		for j := 0; j < TASKS; j++ {
			ch <- Task{i, j}	// do kanalu taskov sa nasypu vsetky dvojice (a,b), ktorych vysledok a*b potrebujeme
		}
	}
	close(ch)
}

func main() {
	var wg sync.WaitGroup
	wg.Add(WORKERS)			// muttex sa nastavi na #workerov,
	go pool(&wg)			// spusti sa simulacia worker poolu
	wg.Wait()				// caka sa, kym kazdy worker dopracuje
	fmt.Println("Podklady pre fakturaciu workerov:")
	for id:=0; id<WORKERS; id++ {
		fmt.Printf("$%d\tBits %d\n", SALARY[id], LOGS[id])
	}
}