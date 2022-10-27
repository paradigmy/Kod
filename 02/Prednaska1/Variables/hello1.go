package main

import (
	"fmt"
	"strconv"
)

func main() {
	//var xx int32 = 1
	//var yy float64 = float64(xx)
	//fmt.Println(float64(xx)+yy)
	var hello string = "Hello"
	i := 9
	world := "world" + strconv.Itoa(i)
	var count = 0
	fmt.Println(count)
	const dots = `...`
	fmt.Println(hello + dots + world + strconv.Itoa(123))
	fmt.Println(hello + string(dots[0]) + world)
	str, err := strconv.Atoi("34")   // skus 34
	if err == nil {
		fmt.Println(str)
	} else {
		fmt.Println("neviem preformatovat: " + err.Error())
	}
}
