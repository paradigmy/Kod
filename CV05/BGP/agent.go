package main

import (
	"fmt"
	"math/rand"
)

type Agent struct {
	id int
	traitor bool  // true klamar
	channel chan Message
	children map[string] []Message
	//children map[string] Node
	//children map[string] []Value
	//inputs map[string] Value
	decistion Value	 // final decistion
}
/*
type Node struct {
	output Value
	sons   map[string] Node
}
*/
func newAgent(id int, channel chan Message) *Agent {
	return &Agent{id, false, channel,make(map[string] []Message), Value(-99)}
}
func (agent Agent)toString() string {
	return fmt.Sprintf("agent: %d (%v)", agent.id, agent.traitor)
}

func (agent *Agent)traverse(path string) {
	messages := agent.children[path]
	for index, msg := range messages {
		if index > 0 { // prva je vlastna
			fmt.Printf("%v %v:%v\n", "\t\t\t\t\t\t\t\t\t\t"[:len(path)], getKey(msg.path), msg)
			agent.traverse(getKey(msg.path))
		}
	}
}

func (agent *Agent)postorder(path string) Value {
	messages := agent.children[path]
	indent := "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"[:len(path)]
	values := []Value{}
	for index, msg := range messages {
		if index > 0 { // prva je vlastna
		   if agent.children[getKey(msg.path)] != nil {
				//fmt.Printf("%v %v:%v\n", indent, getKey(msg.path), msg)
				values = append(values, agent.postorder(getKey(msg.path)))
			}
		} else {
			values = append(values, msg.input)
		}
	}
	return majority1(indent, values)
}


func (agent *Agent)run() {
	go func() {
		for {
			msg := <-agent.channel // prisla message
			if msg.level == 0 {
				fmt.Printf("%v::<- %v, final\n", agent.id, msg.toString())
				msg.output = msg.input
				agent.children[getKey(msg.path)] = []Message{msg}
			} else {
				fmt.Printf("%v::<- %v, forward to: %v \n", agent.id, msg.toString(), msg.others)
				msg.output = msg.input
				agent.children[getKey(msg.path)] = []Message{msg}
				for indx, next := range msg.others {
					others1 := append(append([]int{},msg.others[:indx]...), msg.others[(indx+1):]...)  // others okrem indexu indx
					newInput := msg.input
					if agent.traitor {
						newInput = Value(rand.Intn(2))
					}
					Counter++
					fm := Message{msg.level-1, newInput, append(msg.path, agent.id), others1, UNKNOWN} // vytvor novu spravu
					//fmt.Printf("%v::posielam Message pre %v %s\n", agent.id, next, fm.toString())
					agents[next].channel <- fm		// posli agentovi next
				}
			}
			if len(msg.path) > 0 {
				//msgkey := msg.getKey()
				msgkey := getKey(msg.path[:len(msg.path)-1])
				//if agent.children[msgkey] == nil {
				//	agent.children[msgkey] = make([]Value, 0)
				//}
				//agent.children[msgkey].sons[getKey(msg.path)] = agent.children[getKey(msg.path)]
				agent.children[msgkey] = append(agent.children[msgkey], msg)
			}

		}
		fmt.Printf("%v::end agent\n", agent.id)
	}()
}

func majority(id int, responses []*Message, originalInput Value) Value {
	one := 0
	zero := 0
	ressting := ""
	if originalInput == 1 {
		one++
		ressting =  ressting +"1"
	} else {
		zero++
		ressting =  ressting +"0"
	}

	for _,resp := range responses {
		if resp.output == 1 {
			one++
			ressting =  ressting +"1"
		} else {
			zero++
			ressting =  ressting +"0"
		}
	}
	result := 0
	if (one > zero) {
		result = 1
	} else {
		result = 0
	}
	fmt.Printf("%v::majority(%v), #1:%v, #0:%v, result:%v\n", id, ressting, one, zero, result)
	return Value(result)
}


func majority1(indent string, values []Value) Value {
	one := 0
	zero := 0
	ressting := ""
	for _,value := range values {
		if value == 1 {
			one++
			ressting =  ressting +"1"
		} else {
			zero++
			ressting =  ressting +"0"
		}
	}
	result := 0
	if (one > zero) {
		result = 1
	} else {
		result = 0
	}
	//fmt.Printf("%vmajority(%v), #1:%v, #0:%v, result:%v\n", indent, ressting, one, zero, result)
	return Value(result)
}
