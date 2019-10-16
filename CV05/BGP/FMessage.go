package main

import (
	"fmt"
)

type FMessage struct {
	level     int
	input     Value
	path 	  []int
	others    []int
}

func (msg *FMessage) toString() string {
	return fmt.Sprintf("(level=%d, input=%d: path %v, others: %v)", msg.level, msg.input, msg.path, msg.others)
}

func (msg *FMessage) getKey() string {
	return getKey(msg.path)
}

//func (msg1 *FMessage)Equal(msg2 *FMessage) bool {
//	//return msg1.path = msg2.path
//	return true
//}

