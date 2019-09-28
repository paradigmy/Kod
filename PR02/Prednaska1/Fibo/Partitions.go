package main

import (
	"fmt"
	"math"
)

var memo [][]int64 //= make([]int64, 1000)

func p(n int, m int) int64 {
	if (n <= m + 1) {
		return 1
	}
	if (memo[n - 2][m - 2] != 0){
		return memo[n - 2][m - 2]
	}
	var max int64 = int64(math.Floor(float64(n) / float64(m)));
	if (m == 2){
		return max
	};
	var count int64 = 0
	for ; max > 0; n -= m {
		max--
		memo[n - 3][m - 3] = p(n - 1, m - 1)
		count +=  memo[n - 3][m - 3];
	}
	return count;
}

func partition(n int, m int) int64 {
	if (m < 2) {
		return int64(m);
	}
	if (n < m) {
		return 0;
	}
	memo = make([][]int64, n)
	for i := 0; i < n-1; i++ {
		memo[i] = make([]int64, m)
	}
	return p(n, m);
}

func part(n int) int64 {
	var sum int64 = 0
	for i := 1; i <= n; i++ {
		sum += partition(n,i)
	}
	return sum;
}

func part2(n int) int64 {
		memo = make([][]int64, n)
		for i := 0; i < n-1; i++ {
			memo[i] = make([]int64, n)
		}
	var sum int64 = 1
	for i := 2; i <= n; i++ {
		sum += p(n,i)
	}
	return sum;
}


func main() {
	for i:=1; i < 20; i++ {
		fmt.Println(part( i))
	}
	fmt.Println(part2( 100))
	fmt.Println(partition(9, 3))
	fmt.Println(partition(150, 23))
	fmt.Println(partition(1000, 81))
}
/*
partition 100 = 190569292

 */