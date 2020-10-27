// http://divan.github.io/posts/go_concurrency_visualize/
package main

import (
	"fmt"
	"time"
)

func main() {
	var Ball int
	table := make(chan int)
	go player(1, table)
	go player(2, table)
	go player(3, table)

	table <- Ball
	time.Sleep(5 * time.Second)
	finito := <-table
	fmt.Printf("main chytil %d\n", finito)
}

func player(id int, table chan int) {
	for {
		ball := <-table
		fmt.Printf("player %d chytil %d\n", id, ball)
		ball++
		time.Sleep(100 * time.Millisecond)
		table <- ball
		fmt.Printf("player %d vratil %d\n", id, ball)
	}
}
