package main

import (
	"fmt"
	"math/rand"
	"runtime"
	"time"
)

var (
	size        = 50000000
	granularity = 50000
)

func pivot(pole []int) int {
	i, j, x := 1, len(pole)-1, pole[0]
	for i <= j {
		for i <= j && pole[i] <= x {
			i++
		}
		for j >= i && pole[j] >= x {
			j--
		}
		if i < j {
			pole[i], pole[j] = pole[j], pole[i]
		}
	}
	pole[0], pole[j] = pole[j], pole[0]
	return i
}

func quickSort(pole []int) {
	if len(pole) > granularity {
		done := make(chan bool)
		go cquickSort(pole, done)
		<-done
	} else {
		squickSort(pole)
	}
}

func cquickSort(pole []int, done chan bool) {
	if len(pole) <= 1 {
		done <- true
	} else if len(pole) < granularity {
		quickSort(pole)
		done <- true
	} else {
		index := pivot(pole)
		left, right := make(chan bool), make(chan bool)
		go cquickSort(pole[:(index-1)], left)
		go cquickSort(pole[index:], right)
		done <- (<-left && <-right)
	}
}

func squickSort(pole []int) {
	if len(pole) > 1 {
		index := pivot(pole)
		squickSort(pole[:(index - 1)])
		squickSort(pole[index:])
	}
}

func main() {
	//runtime.GOMAXPROCS(8)
	runtime.GOMAXPROCS(runtime.NumCPU())
	fmt.Println(runtime.NumCPU())
	array := make([]int, size)
	rand.Seed(time.Now().UnixNano())
	for i, _ := range array {
		array[i] = rand.Int()
	}
	/*
		for _, val := range array {
			fmt.Println(val)
		}
	*/
	t0 := time.Now()
	quickSort(array)
	t1 := time.Now()

	fmt.Println("Sorted in", t1.Sub(t0).Nanoseconds()/1000000, "milliseconds.")

}
