package main

import (
	"testing"
)

func Benchmark_Fib1(b *testing.B) {
	for i := 1; i < b.N; i++ {
		FibLogBig1(1024)
	}
}

func Benchmark_TimeConsumingFunction(b *testing.B) {
	b.StopTimer()
	b.StartTimer() //restart timer
	for i := 1; i < b.N; i++ {
		FibLogBig1(1024)
	}
}
