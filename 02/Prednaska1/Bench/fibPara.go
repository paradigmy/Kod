package main

var channelCounter = 0

func FibPara(n int, ch chan int) {
	if n <= 2 {
		ch <- 1
	} else {
		ch1 := make(chan int)
		channelCounter++
		go FibPara(n-2, ch1)
		ch2 := make(chan int)
		channelCounter++
		go FibPara(n-1, ch2)
		n1 := <-ch1
		n2 := <-ch2
		ch <- n1 + n2
	}
}

//---------------------------------------------------------
//func main() {
//	var n int
//	fmt.Print("zadaj N: ")
//	_, _ = fmt.Scanf("%d", &n)
//	ch := make(chan int)
//	go FibPara(n, ch)
//	res := <- ch
//	fmt.Println(res)
//	fmt.Println(channelCounter)
//}
//

