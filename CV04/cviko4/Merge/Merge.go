package main

import (
	"fmt"
	"math/rand"
	"runtime"
	"time"
)

// ideme triedit pole cisel pomocu MergeSortu
type Pole []int

var (
	numbers Pole // globalna premenna ako triedene pole
	temp    Pole //pomocne pole pre mergesort, kedze merge in-situ je tazky
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

func merge(low, middle, high int) { // zlepi dve casti pola low..middle, middle+1..high cez pole temp
	for i := low; i <= high; i++ {
		temp[i] = numbers[i] // prekopiruje do pomocneho pola
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

func cmergesort(low, high int, ch chan bool) {
	if low < high {
		middle := low + (high-low)/2
		if high-low < granularity { // granularita, utried sekvencne
			mergesort(low, middle)
			mergesort(middle+1, high)
			merge(low, middle, high)
		} else {
			ch1 := make(chan bool)
			goroutines++
			go cmergesort(low, middle, ch1)
			ch2 := make(chan bool)
			goroutines++
			go cmergesort(middle+1, high, ch2)
			<-ch1
			<-ch2
			merge(low, middle, high)
		}
	}
	ch <- true
}

func ConcMergesort(values Pole) Pole {
	numbers = values
	goroutines = 0
	temp = make(Pole, len(values))
	ch := make(chan bool)
	go cmergesort(0, len(values)-1, ch)
	goroutines++
	<-ch
	return numbers
}

//----------------------------------------------------

func main() {
	// maly testik, ci to vobec triedi...
	s := Pole{4, 3, 5, 6, 4, 33, 2, 1, 2, 3, 4, 44, 5, 3, 2, 3, 4, 5, 6, 7, 8, 9, 0}
	fmt.Printf("%v\n", s)
	fmt.Printf("%v\n", SeqMergesort(s))

	runtime.GOMAXPROCS(runtime.NumCPU())
	fmt.Println(runtime.NumCPU())
	rand.Seed(time.Now().UnixNano())

	N := 50000000 // velkost triedeneho pola
	//N := 100000000 // velkost triedeneho pola

	for granularity = N; granularity > 0; granularity = granularity / 2 {
		ss := make(Pole, N)
		for idx := range ss {
			ss[idx] = rand.Intn(N)
		}
		start := time.Now()
		// _ = SeqMergesort(ss) // sekvencna verzia
		_ = ConcMergesort(ss) // konkurentna verzia
		elapsed := time.Since(start)
		fmt.Printf("MERGESORT: size=%v, granula=%d\tgoroutines=%d\telapsed time %v\n",
			N, granularity, goroutines, elapsed)
		if goroutines > 10000 {
			break // too much
		}
	}
}
