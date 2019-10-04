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
	
func makeChannels(n int) []chan Message {
	chArray := make([]chan Message, n)
	for i:= 0; i < n; i++ {
		chArray[i] = make(chan Message)  // kanal, na ktorom pocuva i-ty agent
	}
	return chArray
}

func runDispatcher(channels []chan Message) chan Message {
	dispch := make(chan Message)		// kanal na komunikaciu s dispatcherom
	go func() {
		for {
			msg := <- dispch			// ak prisla sprava
			fmt.Println("dispecer sa dozvedel: " + msg.toString())
			for _,ch := range channels  {
				go func(x chan Message) {	// pozor, toto nefunguje, aj x neprenesieme ako argument do gorutiny
					x <- msg				// ak by miesto x bolo ch, tak to je premenna cyklu, a nefunguje, bug
				}(ch)
			}
		}	
	}()	
	return dispch
}
	
func runAgentCommunicatingWithDispatcher(agent int, dispch chan Message, input chan Message) {
	go func() {
		i := 0	// interne pocitadlo agenta
		for {
			timeout := time.After(time.Duration(rand.Intn(3)) * time.Second) // nahodny delay
			select {
				case msg := <- input:		// ak prisla sprava agentovi, tak tlacime
					fmt.Printf("agentovi %d: prisla sprava:\"%s\"\n", agent, msg.toString())
				case <-timeout:
					msg := Message{who:agent, what:i}	// po timeout, vytvorime spravu
					fmt.Println(msg.toString())			// vypiseme na konzolu
					dispch <- msg						// posleme dispecerovi
					i++									// agent si zvysi lokalny counter
			}
		}
	}()
}

func main() { 
	chArray := makeChannels(numb)		// pole komunikacnych kanalov
	dispch := runDispatcher(chArray)	// centralna komunikacna goroutina
	for a:= 0; a<numb; a++ {			// nastartujeme agentov
		runAgentCommunicatingWithDispatcher(a, dispch, chArray[a])
	}
	time.Sleep(100000000000)			// nedoriesene ukoncenie
}	

