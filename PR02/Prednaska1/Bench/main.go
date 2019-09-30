package main

import (
	"fmt"
	"time"
)

func main() {
	list := [12]int{1, 2, 3, 4, 5, 10, 100, 1000, 10000, 100000, 1000000, 10000000}
	//list := [16]int{9, 13, 89, 130, 897, 2301, 8901, 7586, 34231, 98762, 32153,	123452, 959384, 256544,	1428124, 9949890}

	//list := [16]int{1, 2, 3, 4, 5, 10, 100, 1000, 5000, 10000, 50000, 100000, 500000, 1000000, 5000000, 10000000}
	start := time.Now()
	for j := 0; j < len(list); j++ {
		i := list[j]
		f := FibLogBig1(i).String()
		l := len(f)
		if l > 100 {
			fmt.Printf("fib(%v) ma dlzku %v a prefix je \t\"%s\" \n", i, l, f[:100])
		} else {
			fmt.Printf("fib(%v) ma dlzku %v a je to \t\"%s\" \n", i, l, f)
		}
	}
	fmt.Printf("vypocet toho vsetkeho trval %v \n", time.Since(start))

	// return

	var n int
	fmt.Print("zadaj N:")
	_, _ = fmt.Scanf("%d", &n)

	FiboCyklus(n)

	for i := 1; i <= n; i++ {
		fmt.Printf("%v\n", fib(i))
	}

	FibPoleInit(n)

	fmt.Printf("i\t\t\tfib\t\t\tFibPole\t\tFibBig\t\t\tFibLog\t\t\tFibLogBig\t\tFibMatrix\n")
	for i := 1; i <= n; i++ {
		fmt.Printf("%v\t\t\t", i)
		fmt.Printf("%v\t\t\t", fib(i))
		fmt.Printf("%v\t\t\t", FibPole(i-1))
		fmt.Printf("%v\t\t\t", FibBig(i))

		fmt.Printf("%v\t\t\t", FibLog1(i))

		fmt.Printf("%v\t\t\t", FibLogBig1(i))
		fmt.Printf("%v\t\t\t", FibMatrix(i))
		fmt.Println()
	}

	/* * /
	ch := make(chan int)
	go FibPara(20, ch)
	res := <-ch
	fmt.Printf("FibPara(20) = %v\n", res)
	/* */

	fmt.Printf("FibBig(1024) = %v\n", FibBig(1024))

	fmt.Printf("FibLogBig(1024) = %v\n", FibLogBig1(1024))
	fmt.Printf("FibLogBigPara(1024) = %v\n", FibLogBigPara1(1024))
	fmt.Printf("FibMatrixBig(1024) = %v\n", FibMatrixBig(1024))

	fmt.Printf("now = %v\n", time.Now())
	/* */
	MAX := 123456
	start = time.Now()
	fmt.Printf("FibBig(%d) has length %v, time=%v\n", MAX, len(FibBig(MAX).String()), time.Since(start))
	start1 := time.Now()
	fmt.Printf("FibLogBig(%d) has length %v, time=%v\n", MAX, len(FibLogBig1(MAX).String()), time.Since(start1))
	start2 := time.Now()
	fmt.Printf("FibLogBigPara(%d) has length %v, time=%v\n", MAX, len(FibLogBigPara1(MAX).String()), time.Since(start2))
	start3 := time.Now()
	fmt.Printf("FibMatrixBig(%d) has length %v, time=%v\n", MAX, len(FibMatrixBig(MAX).String()), time.Since(start3))

	fmt.Println()
	MAX = 1234567
	//start = time.Now()
	//fmt.Printf("FibBig(%d) has length %v, time=%v\n", MAX,len(FibBig(MAX).String()), time.Since(start))
	start1 = time.Now()
	fmt.Printf("FibLogBig(%d) has length %v, time=%v\n", MAX, len(FibLogBig1(MAX).String()), time.Since(start1))
	start2 = time.Now()
	fmt.Printf("FibLogBigPara(%d) has length %v, time=%v\n", MAX, len(FibLogBigPara1(MAX).String()), time.Since(start2))
	start3 = time.Now()
	fmt.Printf("FibMatrixBig(%d) has length %v, time=%v\n", MAX, len(FibMatrixBig(MAX).String()), time.Since(start3))

	fmt.Println()

	MAX = 12345678
	//start = time.Now()
	//fmt.Printf("FibBig(%d) has length %v, time=%v\n", MAX,len(FibBig(MAX).String()), time.Since(start))
	start1 = time.Now()
	fmt.Printf("FibLogBig(%d) has length %v, time=%v\n", MAX, len(FibLogBig1(MAX).String()), time.Since(start1))
	start2 = time.Now()
	fmt.Printf("FibLogBigPara(%d) has length %v, time=%v\n", MAX, len(FibLogBigPara1(MAX).String()), time.Since(start2))
	start3 = time.Now()
	fmt.Printf("FibMatrixBig(%d) has length %v, time=%v\n", MAX, len(FibMatrixBig(MAX).String()), time.Since(start3))

	fmt.Println()

	MAX = 123456789
	//start = time.Now()
	//fmt.Printf("FibBig(%d) has length %v, time=%v\n", MAX,len(FibBig(MAX).String()), time.Since(start))
	start1 = time.Now()
	fmt.Printf("FibLogBig(%d) has length %v, time=%v\n", MAX, len(FibLogBig1(MAX).String()), time.Since(start1))
	start2 = time.Now()
	fmt.Printf("FibLogBigPara(%d) has length %v, time=%v\n", MAX, len(FibLogBigPara1(MAX).String()), time.Since(start2))
	start3 = time.Now()
	fmt.Printf("FibMatrixBig(%d) has length %v, time=%v\n", MAX, len(FibMatrixBig(MAX).String()), time.Since(start3))

}
