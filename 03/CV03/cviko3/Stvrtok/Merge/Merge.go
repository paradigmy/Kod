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
	//fmt.Print("i AM HERE: ", low, " ", high)
	if low == high {
		return
	}
	mid := (low + high) / 2
	mergesort(low, mid)
	mergesort(mid+1, high)
	merge(low, mid, high)
}

func merge(low, mid, high int) {
	p1 := low
	p2 := mid + 1
	i := low
	for p1 < mid+1 && p2 < high+1 {
		if numbers[p1] < numbers[p2] {
			temp[i] = numbers[p1]
			p1++
			i++
		} else {
			temp[i] = numbers[p2]
			p2++
			i++
		}
	}
	for p1 < mid+1 {
		temp[i] = numbers[p1]
		p1++
		i++
	}
	for p2 < high+1 {
		temp[i] = numbers[p2]
		p2++
		i++
	}
	i = low
	for i < high+1 {
		numbers[i] = temp[i]
		i++
	}
}

//------------------------------------- konkurentna verzia

var (
	granularity = 0 // toto je parameter urcujuci, ake pole uz triedime sekvencne
	goroutines  = 0 // pocet vytvorenych gorutin
)

// synchronizacia pomocou mutexu
// wg := new(sync.WaitGroup)
// wg.Add(1)
// wg.Done()
// wg.Wait()
func cmergesort(low, high int) {
	if low == high {
		return
	}

	size := high - low
	mid := (low + high) / 2

	if size < granularity {
		mergesort(low, mid)
		mergesort(mid+1, high)
	} else {
		wg := new(sync.WaitGroup)
		wg.Add(2)
		go func() {
			cmergesort(low, mid)
			wg.Done()
		}()
		go func() {
			cmergesort(mid+1, high)
			wg.Done()
		}()

		goroutines += 2
		wg.Wait()
	}

	merge(low, mid, high)
}

func ConcMergesort(values Pole) Pole {
	numbers = values
	goroutines = 0
	temp = make(Pole, len(values))
	goroutines++
	cmergesort(0, len(values)-1)

	return numbers
}

//----------------------------------------------------

func main() {
	// maly testik, ci to vobec triedi...
	s := Pole{4, 3, 5, 6, 4, 33, 2, 1, 2, 3, 4, 44, 5, 3, 2, 3, 4, 5, 6, 7, 8, 9, 0}
	fmt.Printf("%v\n", s)
	fmt.Printf("%v\n", ConcMergesort(s))

	runtime.GOMAXPROCS(runtime.NumCPU())
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
		_ = ConcMergesort(ss) // konkurentna verzia
		elapsed := time.Since(start)
		fmt.Printf("MERGESORT: size=%v, granula=%d\tgoroutines=%d\telapsed time %v\n",
			N, granularity, goroutines, elapsed)
		if goroutines > 10000 {
			break // too much
		}
	}
}
