package main

import (
	"fmt"
)

func combRec(n int64, k int64) int64 {
	if n == k || k == 0 {
		return 1
	} else {
		return combRec(n-1, k-1) + combRec(n-1, k)
	}
}
func sucin2(a int64, b int64) int64 {
	if a > b {
		return 1
	} else if a == b {
		return a
	} else {
		mid := (a+b)/2
		return sucin2(a,mid) * sucin2(mid+1,b)
	}
}

func main() {
	fmt.Println(combRec(6,2))
	fmt.Println(sucin2(1,10))
}