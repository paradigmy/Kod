package main

import (
	"fmt"
	"strconv"
)

type BMessage struct {  // backward message
	path      []int
    source	  int
	output    Value
}

func (msg *BMessage) toString() string {
	return fmt.Sprintf("(output=%v: path %v, source: %v)", msg.output, msg.path, msg.source)
}
func (msg *BMessage) getKey() string {
	return getKey(msg.path)
}

func getKey(path []int) string {
	res := ""
	for x := range path {
		res = res + strconv.Itoa(x) + ","
	}
	return res
}
