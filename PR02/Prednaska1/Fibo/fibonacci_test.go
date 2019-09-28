package main

import (
	"testing"
)

func TestFib1(t *testing.T) {
	n := 40
	FibPoleInit(n)
	for i := 1; i < n; i++ {
		if FibPole(i-1) == FibLog1(i) {
			// if fib(i) == FibPole(i-1) && fib(i) == FibLog1(i) {
			t.Logf("fib(%d) ok", i)
		} else {
			//t.Errorf("fib(%d)=%v error\n", i, fib(i))
			t.Errorf("fibLog(%d)=%v error\n", i, FibPole(i-1))
			t.Errorf("fibLog(%d)=%v error\n", i, FibLog1(i-1))
			t.Errorf("fib(%d) error\n", i)
		}
	}
}

func TestFib2(t *testing.T) {
	for i := 1; i < 100; i++ {
		if FibBig(i).Cmp(FibLogBig1(i)) == 0 {
			t.Logf("fib(%d) ok", i)
		} else {
			t.Errorf("fib(%d)=%v error\n", i, FibBig(i))
			t.Errorf("fibLog(%d)=%v error\n", i, FibLog1(i))
			t.Errorf("fib(%d) error\n", i)
		}
	}
}
