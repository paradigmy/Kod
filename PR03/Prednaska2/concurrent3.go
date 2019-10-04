package main

import (
	"fmt"
	"math/rand"
	"time"
)

func loopToChannel(task string, delay int) chan string {
	ch := make(chan string)
	go func() {
		for i := 1; i < 30; i++ {
			ch <- fmt.Sprintf("%s:%d\n", task, i)
			time.Sleep(time.Duration(rand.Intn(delay)) * time.Millisecond)
			//time.Sleep(1000 * time.Millisecond)
		}
	}()
	return ch
}

func multiplexor(ch1, ch2 chan string) chan string {
	ch := make(chan string)
	go func() {
		for {
			ch <- <-ch1
		}
	}()
	go func() {
		for {
			ch <- <-ch2
		}
	}()
	return ch
}

func multiplexorSelect(ch1, ch2 chan string) chan string {
	ch := make(chan string)
	go func() {
		gameOver := time.After(2 * time.Second)
		/*
			gameOver := make(chan bool)
			go func(seconds int) {
				time.Sleep(time.Duration(seconds) * time.Second)
				gameOver <- true
			}(2)
		*/
		for {
			select {
			//case ch <- <-ch1:
			case val := <-ch1:
				ch <- val
			case val := <-ch2:
				ch <- val
			case <-gameOver:
				ch <- "GAME OVER\n"
				close(ch)
			}
		}
	}()
	return ch
}

func main() {
	ch1 := loopToChannel("prvy", 2400)  // 23500
	ch2 := loopToChannel("druhy", 1000) // 20000

	for {
		fmt.Print(<-ch1)
		fmt.Print(<-ch2)
	}

	var input string   // toto čaká na input, v opačnom
	fmt.Scanln(&input) // prípade, keď umrie hlavné
	fmt.Println("main stop")


/*		//for {
		go func() {
			for {
				fmt.Print(<-ch1)
			}
		}()
		go func() {
			for {
				fmt.Print(<-ch2)
			}
		}()

		var input string   // toto čaká na input, v opačnom
		fmt.Scanln(&input) // prípade, keď umrie hlavné
		fmt.Println("main stop")
		//}
*/


/*		ch := multiplexor(ch1, ch2)
		for {
			fmt.Print(<-ch)
		}
*/

/*	ch := multiplexorSelect(ch1, ch2)
	for {
		fmt.Print(<-ch)
	}
*/


/*		ch := multiplexorSelect(ch1, ch2)
		for {
			val, opened := <-ch
			if !opened {
				break
			}
			fmt.Print(val)
		}

*/
	/* */
	fmt.Println("main stop")
}
