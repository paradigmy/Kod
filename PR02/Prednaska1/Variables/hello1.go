package main

import (
	"fmt"
	"strconv"
)

func main() {
	var hello string = "Hello"
	i := 9
	world := "world" + strconv.Itoa(i)
	const dots = `...`
	fmt.Println(hello + dots + world + strconv.Itoa(123))
	fmt.Println(hello + string(dots[0]) + world)
	str, err := strconv.Atoi("3,4")   // skus 34
	if err == nil {
		fmt.Println(str)
	} else {
		fmt.Println("neviem preformatovat: " + err.Error())
	}
}
