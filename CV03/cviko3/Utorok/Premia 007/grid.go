package main

import (
	"fmt"
	//"time"
)

type Agent007 struct {
	i, j     int      // Agent's coordinates in the grid
	row, col chan int // inputs for Agent007
}

type Grid [][]*Agent007

func main() {
	N := 10
	fmt.Println(N)
	grid := make(Grid, N)
	for i := range grid {
		grid[i] = make([]*Agent007, N)
		for j := range grid[i] {
			grid[i][j] = new(Agent007)
			grid[i][j].i = i
			grid[i][j].j = j
			grid[i][j].row = make(chan int)
			grid[i][j].col = make(chan int)
		}
	}
	for i := 0; i < N; i++ {
		for j := 0; j < N; j++ {
			go func(i, j int) {
				val1 := <-grid[i][j].row
				val2 := <-grid[i][j].col
				val := val1 + val2
				fmt.Println(i+1+j+1, j+1, val)
				if i+1 < N {
					go func() { grid[i+1][j].col <- val }()
				}
				if j+1 < N {
					go func() { grid[i][j+1].row <- val }()
				}
			}(i, j)
		}
	}
	for i := 0; i < N; i++ {
		go func(i int) {
			grid[i][0].row <- 1
		}(i)
	}
	for j := 0; j < N; j++ {
		go func(j int) {
			grid[0][j].col <- 1
		}(j)
	}
	//time.Sleep(10000000000000)
	for {
	}
}
