package main

import (
	"fmt"
	"math/rand"
	"runtime"
	"sync"
	"time"
)

// ideme triedit pole cisel pomocu MergeSortu
type Pole []int

var (
	numbers Pole
	temp    Pole //pomocne pole pre mergesort, kedze merge in situ je tazky
)

func SeqMergesort(values Pole) Pole {
	numbers = values
	temp = make(Pole, len(values))
	mergesort(0, len(values)-1)
	return numbers
}

func mergesort(low, high int) {
	if low < high {
		middle := low + (high-low)/2
		mergesort(low, middle)
		mergesort(middle+1, high)
		merge(low, middle, high)
	}
}

func merge(low, middle, high int) { // zlepi dve casti pola low..middle, middle..high cez pole temp
	for i := low; i <= high; i++ {
		temp[i] = numbers[i]
	}
	i := low
	j := middle + 1
	k := low
	for i <= middle && j <= high {
		if temp[i] <= temp[j] {
			numbers[k] = temp[i]
			i++
		} else {
			numbers[k] = temp[j]
			j++
		}
		k++
	}
	for i <= middle {
		numbers[k] = temp[i]
		k++
		i++
	}
}

//------------------------------------- konkurentna verzia

var (
	granularity = 0 // toto je parameter urcujuci, ake pole uz triedime sekvencne
	goroutines  = 0 // pocet vytvorenych gorutin
)

func cmergesort(low, high int, wg *sync.WaitGroup) {
	if low < high {
		middle := low + (high-low)/2
		if high-low < granularity { // granularita
			mergesort(low, middle)
			mergesort(middle+1, high)
			merge(low, middle, high)
		} else {
			wg := new(sync.WaitGroup)
			wg.Add(2)
			goroutines++
			go cmergesort(low, middle, wg)
			goroutines++
			go cmergesort(middle+1, high, wg)
			wg.Wait() // cakaj, kym obaja dokoncia
			merge(low, middle, high)
		}
	}
	wg.Done()
}

func ConcMergesort(values Pole) Pole {
	numbers = values
	goroutines = 0
	temp = make(Pole, len(values))
	wg := new(sync.WaitGroup)
	wg.Add(1) // toto treba, lebo inak padne wg.Done na negative counter
	goroutines++

	cmergesort(0, len(values)-1, wg)

	// alebo:
	//go cmergesort(0, len(values)-1, wg)
	//wg.Wait() // toto asi netreba...
	return numbers
}

//----------------------------------------------------

func main() {
	// maly testik, ci to vobec triedi...
	s := Pole{4, 3, 5, 6, 4, 33, 2, 1, 2, 3, 4, 44, 5, 3, 2, 3, 4, 5, 6, 7, 8, 9, 0}
	fmt.Printf("%v\n", s)
	fmt.Printf("%v\n", SeqMergesort(s))

	runtime.GOMAXPROCS(2) //
	//runtime.NumCPU())
	fmt.Println(runtime.NumCPU())
	rand.Seed(time.Now().UnixNano())

	N := 10000000 // velkost triedeneho pola

	for granularity = N; granularity > 0; granularity = granularity / 2 {
		ss := make(Pole, N)
		for idx := range ss {
			ss[idx] = rand.Intn(N)
		}
		start := time.Now()
		//_ = SeqMergesort(ss) // sekvencna verzia
		//
		_ = ConcMergesort(ss) // konkurentna verzia
		elapsed := time.Since(start)
		fmt.Printf("MERGESORT: size=%v, granula=%d\tgoroutines=%d\telapsed time %v\n",
			N, granularity, goroutines, elapsed)
		if goroutines > 10000 {
			break // too much
		}
	}
}
