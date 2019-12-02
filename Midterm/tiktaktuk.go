package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main1() {
	fmt.Print(time.Now().UTC()); fmt.Println("\tStart")
	go func () {
		fmt.Print(time.Now().UTC()); fmt.Println("\tbegin")
		time.Sleep(1000)
		fmt.Print(time.Now().UTC()); fmt.Println("\tend")
	}()
	fmt.Print(time.Now().UTC()); fmt.Println("\tStop")
	//2019-11-30 16:38:13.4108078 +0000 UTC	Start
	//2019-11-30 16:38:13.4108078 +0000 UTC	Stop
}

func main2() {
	fmt.Print(time.Now().UTC()); fmt.Println("\tStart")
	go func () {
		fmt.Print(time.Now().UTC()); fmt.Println("\tbegin1")
		time.Sleep(1*time.Second)
		fmt.Print(time.Now().UTC()); fmt.Println("\tend1")
	}()
	go func () {
		fmt.Print(time.Now().UTC()); fmt.Println("\tbegin2")
		time.Sleep(2*time.Second)
		fmt.Print(time.Now().UTC()); fmt.Println("\tend2")
	}()
	time.Sleep(3*time.Second)
	fmt.Print(time.Now().UTC()); fmt.Println("\tStop")
	//2019-11-30 16:42:47.1938141 +0000 UTC	Start
	//2019-11-30 16:42:47.1948117 +0000 UTC	begin1
	//2019-11-30 16:42:47.1948117 +0000 UTC	begin2
	//2019-11-30 16:42:48.1953353 +0000 UTC	end1
	//2019-11-30 16:42:49.1954734 +0000 UTC	end2
	//2019-11-30 16:42:50.1957898 +0000 UTC	Stop
}

func main3() {
	fmt.Print(time.Now().UTC()); fmt.Println("\tStart")
	go func () {
		for i := 1; i < 30; i++ {
			time.Sleep(1*time.Second)
			fmt.Print(time.Now().UTC()); fmt.Printf("\ttick%v\n",i)
		}
	}()
	time.Sleep(10*time.Second)
	fmt.Print(time.Now().UTC()); fmt.Println("\tStop")
	//2019-11-30 16:46:17.3556481 +0000 UTC	Start
	//2019-11-30 16:46:18.3570394 +0000 UTC	tick1
	//2019-11-30 16:46:19.3577435 +0000 UTC	tick2
	//2019-11-30 16:46:20.358005 +0000 UTC	tick3
	//2019-11-30 16:46:21.3582181 +0000 UTC	tick4
	//2019-11-30 16:46:22.358258 +0000 UTC	tick5
	//2019-11-30 16:46:23.3585865 +0000 UTC	tick6
	//2019-11-30 16:46:24.3588828 +0000 UTC	tick7
	//2019-11-30 16:46:25.3590411 +0000 UTC	tick8
	//2019-11-30 16:46:26.3595375 +0000 UTC	tick9
	//2019-11-30 16:46:27.3566966 +0000 UTC	Stop
}


func main4() {
	rand.Seed(time.Now().UnixNano())
	fmt.Print(time.Now().UTC()); fmt.Println("\tStart")
	ch := make(chan bool)
	go func () {
		for _ = range ch {
			fmt.Print("tick")
			ch <- true
			time.Sleep(time.Duration(rand.Intn(5))*time.Millisecond)
		}
	}()
	go func () {
		for _ = range ch {
			fmt.Print("tack")
			ch <- false
			time.Sleep(time.Duration(rand.Intn(5))*time.Millisecond)
		}

	}()
	ch <- true
	time.Sleep(30*time.Second)
	fmt.Print(time.Now().UTC()); fmt.Println("\tStop")
	// striedaju sa, netraba nic, lebo ak jeden urobi ch <- false, tak je to blokujuca operaca, obblokovat ho msui iny
}

func main() {
	rand.Seed(time.Now().UnixNano())
	fmt.Print(time.Now().UTC()); fmt.Println("\tStart")
	ch := make(chan bool)
	go func () {
		for _ = range ch {
			fmt.Print("tick")
			ch <- true
			time.Sleep(time.Duration(rand.Intn(5))*time.Millisecond)
		}
	}()
	go func () {
		for _ = range ch {
			fmt.Print("tack")
			ch <- false
			time.Sleep(time.Duration(rand.Intn(5))*time.Millisecond)
		}

	}()
	go func () {
		for _ = range ch {
			fmt.Print("tuck")
			ch <- false
			time.Sleep(time.Duration(rand.Intn(5))*time.Millisecond)
		}

	}()
	ch <- true
	time.Sleep(30*time.Second)
	fmt.Print(time.Now().UTC()); fmt.Println("\tStop")
	// tuckticktacktucktackticktuckticktucktackticktacktuckticktackticktucktackticktuckticktuckticktacktucktackticktacktuckticktacktuckticktuck
    //                         ^^^^^^^^^^^^                                        ^^^^^^^^^^^^                                    ^^^^^^^^^^^^
}
