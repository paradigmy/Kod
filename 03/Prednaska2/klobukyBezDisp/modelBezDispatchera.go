package main

import (
	"fmt"
	"math/rand"
	"time"
)

var (
	numb = 3
	max	= 100
	)

type Message  struct { 
	who int 
	what int
	}
	
func (msg *Message) toString() string {
	return fmt.Sprintf("%d: povedal %d", msg.who, msg.what)
}	

func runAgent(agent int, channels []chan Message) {
	go func() {
		i := 1
		for {
			timeout := time.After(time.Duration(rand.Intn(3)) * time.Second) 
			select {
				case msg := <- channels[agent]:
					fmt.Printf("agentovi %d: prisla sprava:\"%s\"\n", agent, msg.toString())
				case <-timeout:
					msg := Message{who:agent, what:i}
					fmt.Println(msg.toString())
					i++
					for index, ch := range channels { // povedz kazdemu
						if index != agent {		// okrem seba
							//go func(cha chan Message) { // po
							go func() { // pozor, tu musi byt premenna cyklu ako explicitny argument
								ch <- msg
							}()
						}
					}
			}
		}
	}()
}

func makeChannels(n int) []chan Message {
	chArray := make([]chan Message, n)
	for i:= 0; i < n; i++ {
		chArray[i] = make(chan Message)  // kanal, na ktorom pocuva i-ty agent
	}
	return chArray
}

func main() { 
	chArray := makeChannels(numb)
	for a:= 0; a<numb; a++ {
		runAgent(a, chArray)
	}
	time.Sleep(100000000000)
}
