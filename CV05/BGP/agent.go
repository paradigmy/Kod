package main

import (
	"fmt"
	"math/rand"
)

// agent caka na spravu. Ked pride sprava FMessage (input, path, rest)
// ak |path| = M+2, tak nastava faza 2, to co dostal si mysli, ak nie si klamar tak output = input inak output = X;  posli spravu BMessage agentovi last(path)
// ak |path| < M+2, tak pre vsetych a in rest, posli spravu FMessage (input, path+x, rest-x), ak si klamar, tak FMessage (X, path+x, rest-x)

// ak pride BMessage (path, source, output), zapise si hodnotu do tabulku (path+source , output).
// Ak uz prisli vsetky odpovede, tak vyhodnoti majoritu, a posle BMessage agentovi last(path).

type Agent struct {
	id int
	traitor bool  // true klamar
	fchannel chan FMessage
	bchannel chan BMessage
	children map[string] []*BMessage
}

func newAgent(id int, fchannel chan FMessage, bchannel chan BMessage) *Agent {
	return &Agent{id, false, fchannel, bchannel, make(map[string] []*BMessage)}
}
func (agent Agent)toString() string {
	return fmt.Sprintf("agent: %d (%v)", agent.id, agent.traitor)
}
func (agent Agent)run() {
	go func() {
		for {
			fmt.Printf("%v::select-case-loop\n", agent.id)
			select {
			case bmsg := <-agent.bchannel:
				fmt.Printf("%v::Prisla Bsprava %v\n", agent.id, bmsg.toString())
				key := getKey(bmsg.path[:len(bmsg.path)-1])
				reponses := agent.children[key]
				count := 0
				for i :=0; i<len(reponses); i++ {
					if reponses[i] != nil {
						count++
					}
				}
				fmt.Printf("%v::caka odpovedi: len %v/%v s klucom %v \n" , agent.id, count, len(reponses),key)
				for i:=0; ; i++ {
					if reponses[i] == nil {
						reponses[i] = &bmsg
						fmt.Printf("%v::Bsprava %v ulozena %v\n", agent.id, i, bmsg.toString())
						if i == len(agent.children[key])-1 { // je to posledna
							if len(bmsg.path) < 3 {
								fmt.Printf("%v::posledna, finish\n", agent.id)
								finish <- majority(agent.id,reponses)
							} else {
								fmt.Printf("%v::posledna, vyhodnot majority %v\n", agent.id, majority(agent.id,reponses))
								last := bmsg.path[len(bmsg.path)-3]
								output := majority(agent.id,reponses)
								nbmsg := BMessage{bmsg.path, agent.id, Value(output)}
								fmt.Printf("%v::posielam Bspravu pre %v %s\n", agent.id, last, nbmsg.toString())
								agents[last].bchannel <- nbmsg
							}
						}
						break
					}
				}
			case fmsg := <-agent.fchannel:
				fmt.Printf("%v::Prisla Fsprava %v\n", agent.id, fmsg.toString())
				if fmsg.level == 0 {
					fmt.Printf("%v::is final\n", agent.id)
					output := fmsg.input
					if agent.traitor {
						output = Value(rand.Intn(2))
					}
					last := fmsg.path[len(fmsg.path)-2]
					bmsg := BMessage{fmsg.path, agent.id, output}
					fmt.Printf("%v::posielam Bspravu pre %v %s\n", agent.id, last, bmsg.toString())
					agents[last].bchannel <- bmsg
				} else {
					fmt.Printf("%v::forward to %v\n", agent.id, fmsg.others)
					agent.children[fmsg.getKey()] = make([]*BMessage, len(fmsg.others))
					fmt.Printf("%v::caka %v odpovedi s klucom %v\n", agent.id, len(agent.children[fmsg.getKey()]),fmsg.getKey())
					for indx, next := range fmsg.others {
						others1 := append(append(make([]int, 0), fmsg.others[:indx]...), fmsg.others[(indx+1):]...)
						fm := FMessage{fmsg.level - 1, fmsg.input, append(fmsg.path, next), others1}
						fmt.Printf("%v::posielam Fspravu pre %v %s\n", agent.id, next, fm.toString())
						agents[next].fchannel <- fm
					}
				}
			}
		}
		fmt.Printf("%v::end agent\n", agent.id)
	}()
}

func majority(id int, responses []*BMessage) Value {
	one := 0
	zero := 0
	for _,resp := range responses {
		if resp.output == 1 {
			one++
		} else {
			zero++
		}
	}
	fmt.Printf("%v::%v:%v\n", id, one, zero)
	if (one > zero) {
		return 1
	} else {
		return 0
	}
}