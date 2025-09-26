package main

import (
	"fmt"
	"strconv"
)

func main() {
	var xx int = 1
	var yy float64 = float64(xx)
	fmt.Println(float64(xx)+yy)
	var hello string = "Hello"
	i := 9
	world := "world" + strconv.Itoa(i)
	var n = 0
	fmt.Println(n)
	var count = 0
	fmt.Println(count)
	const dots = `...`
	fmt.Println(hello + dots + world + strconv.Itoa(123))
	fmt.Println(hello + string(dots[0]) + world)
	str, _ := strconv.Atoi("3.4")   // skus 34
	//if  == nil {
		fmt.Println(str)
	//} else {
	//	fmt.Println("neviem preformatovat: " + err.Error())
	//}
}
