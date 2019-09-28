package main

import (
	"fmt"
	"math"
	"math/big"
)

var memoB [][] *big.Int

func pBig(n int, m int) *big.Int {
	if (n <= m + 1) {
		return big.NewInt(1)
	}
	if (memoB[n - 2][m - 2].Cmp(big.NewInt(0)) != 0){
		return memoB[n - 2][m - 2]
	}
	var max int64 = int64(math.Floor(float64(n) / float64(m)));
	if (m == 2){
		return big.NewInt(max)
	};
	var count = big.NewInt(0)
	for ; max > 0; n -= m {
		max--
		memoB[n - 3][m - 3] = pBig(n - 1, m - 1)
		count.Add(count,memoB[n - 3][m - 3]);
	}
	return count;
}

func partitionBig(n int, m int) *big.Int {
	if (m < 2) {
		return big.NewInt(int64(m));
	}
	if (n < m) {
		return big.NewInt(0);
	}
	memoB = make([][]*big.Int, n)
	for i := 0; i < n-1; i++ {
		memoB[i] = make([]*big.Int, m)
		for j := 0; j < m-1; j++ {
			memoB[i][j] = big.NewInt(0)
		}
	}
	return pBig(n, m);
}

func partBig(n int) *big.Int {
	var sum = big.NewInt(0)
	for i := 1; i <= n; i++ {
		sum.Add(sum, partitionBig(n,i))
	}
	return sum;
}

func part2Big(n int) *big.Int {
	memoB = make([][]*big.Int, n)
	for i := 0; i < n-1; i++ {
		memoB[i] = make([]*big.Int, n)
		for j := 0; j < n-1; j++ {
			memoB[i][j] = big.NewInt(0)
		}
	}
	var sum *big.Int = big.NewInt(1)
	for i := 2; i <= n; i++ {
		sum.Add(sum, pBig(n,i))
	}
	return sum;
}


func main() {
	for i:=1; i < 20; i++ {
		fmt.Println(partBig( i))
	}
	fmt.Println(part2Big( 100))
	fmt.Println(part2Big( 1000))
	fmt.Println(part2Big( 10000))
	//fmt.Println(partitionBig(9, 3))
	//fmt.Println(partitionBig(150, 23))
	//fmt.Println(partitionBig(1000, 81))
}
/*
partition 100 = 190569292

*/