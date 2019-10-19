package main

import (
	"fmt"
	"strconv"
)

type Message struct {	// forward message
	level     int		// starting with level M+1 downto 0
	input     Value		// propagating value
	path 	  []int		// path of the message, e.g. {0,1,3}
	others    []int		// list of nodes this message shold be forwarded to
	output	  Value		// vysledna hodnota
}

func (msg *Message) toString() string {
	return fmt.Sprintf("(level=%d, input=%d: path %v, others: %v)", msg.level, msg.input, msg.path, msg.others)
}

func (msg *Message) getKey() string {
	return getKey(msg.path)
}
// auxiliary function, vector to string, used as a map key
func getKey(path []int) string {
	res := ""
	for _,x := range path {
		res = res + strconv.Itoa(x) + ","
	}
	return res
}
