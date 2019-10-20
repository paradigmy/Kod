package main
import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"sync"
	"time"
)
var (
	 //N = 16; M = 5	// pocet generalov, pocet klamarov, 3999676 sprav
	 //N = 13; M = 4	// pocet generalov, pocet klamarov, 108385 sprav
	 //N = 10; M = 3	// pocet generalov, pocet klamarov, 3610 sprav
	 N = 7; M = 2		// pocet generalov, pocet klamarov, 157 sprav
	 //N = 4; M = 1		// pocet generalov, pocet klamarov, 10 sprav
	agents 		[]*Agent
	Counter	    int		// celkovy pocet sprav Messages
	DEBUG		= false
	//DEBUG		= true
	BUFFERSIZE  = 1000000
	MUTEX 		= &sync.Mutex{}  // lock/unlock kvoli globalnemu Counter
)
//---------------------------------------- MESSAGE
type Message struct {
	level     int		// starting with level M+1 downto 0
	input     int		// propagating int
	path 	  []int		// path of the message, e.g. {0,1,3}
	others    []int		// list of nodes this message shold be forwarded to
}

func (msg *Message) toString() string {
	return fmt.Sprintf("(level=%d, input=%d: path %v, others: %v)", msg.level, msg.input, msg.path, msg.others)
}

func getKey(path []int) string { // auxiliary function, vector to string, used as a key for map
	res := ""		// return strings.Join(path, ",")
	for _,x := range path {
		res = res + strconv.Itoa(x) + ","
	}
	return res
}
//---------------------------------------- AGENT
type Agent struct {
	id int
	cheating bool  			// true klamar
	channel chan Message	// kanal na ktorom pocuva
	children map[string] []Message	// strom pijatych sprav
	received  int       			// celkovy pocet prijatych sprav
}

func newAgent(id int, channel chan Message) *Agent {
	return &Agent{id, false, channel,make(map[string] []Message),0}
}

var TABS =  "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" // takto programujte az ako senior :)
func (agent *Agent)traverse(path string) {
	messages := agent.children[path]
	for index, msg := range messages {
		if index > 0 { 	// first message is the original message received by agent, skip it
			fmt.Printf("%v %v:%v\n", TABS[:len(path)], getKey(msg.path), msg)
			agent.traverse(getKey(msg.path))
		}
	}
}
// [1 bod]
// vypočíta vyslednú voľbu agenta, dostojnika
// musí preliezť strom definovan cez children, podobne ako to robí traversovacia rutina kúsok vyššie
// ak treba, sú k tomu slajdy v prednáške
func (agent *Agent)postorder(path string) int {
	// toto mate doprogramovat
	return 999999 // toto sa asi zmeni...
}
// [1 bod]
// asi budete potrebovat trivialnu funkciu majority, ktora zisti vacsinu v subore values
// ak je remiza, tak sa rozhodnite pre nieco, napr. 0, ale všetci agenti rovnak :)
func majority(values []int) int {
	// toto mate doprogramovat
	return 999999 // toto sa asi zmeni...
}

func (agent *Agent)run() {			// agent lifecycle
	go func() {
		for {
			msg := <-agent.channel // prisla message
			agent.received++
			agent.children[getKey(msg.path)] = []Message{msg}
			if msg.level == 0 {
				if DEBUG {
					fmt.Printf("%v::<- %v, final\n", agent.id, msg.toString())
				}
			} else {
				if DEBUG {
					fmt.Printf("%v::<- %v, forward to: %v \n", agent.id, msg.toString(), msg.others)
				}
				for indx, next := range msg.others {
					others1 := append(append([]int{},msg.others[:indx]...), msg.others[(indx+1):]...)  // others okrem indexu indx
					newInput := msg.input
					if agent.cheating {
						newInput = int(rand.Intn(2))
					}
					MUTEX.Lock()   // ak vsetky go rutiny pristupuju do globalnej premennej, tak to zle dopadne
					Counter++
					MUTEX.Unlock()
					fm := Message{msg.level-1, newInput, append(msg.path, agent.id), others1} // vytvor novu spravu
					agents[next].channel <- fm		// posli agentovi next
				}
			}
			if len(msg.path) > 0 {
				msgkey := getKey(msg.path[:len(msg.path)-1])
				agent.children[msgkey] = append(agent.children[msgkey], msg)
			}

		}
		fmt.Printf("%v::end agent\n", agent.id)
	}()
}

//-------------------------------------------- MAIN
func main() {
	rand.Seed(time.Now().UTC().UnixNano())
	Counter = 0
	agents = make([]*Agent, N)
	others := []int{}
	for i, _ := range agents { // i := 0; i < N; i++
		agents[i] = newAgent(i, make(chan Message, BUFFERSIZE))
		others = append(others, i)
	}
	cheatings := 0
	for cheatings < M { // generate M cheatering agents
		i := rand.Intn(N)
		if !agents[i].cheating {
			agents[i].cheating = true;
			cheatings++;
		}
	}
	for _, a := range agents { // i := 0; i < N; i++
		a.run()
	}
	initOrder := int(rand.Intn(2))
	go func() {
		Counter++
		agents[0].channel <- Message{M + 1, initOrder, []int{}, others[1:]}
	}()
	time.Sleep(1000000000)
	decisions := ""
	totalMessages := 0
	for i := 0; i < len(agents); i++ {
		totalMessages += agents[i].received
		if i == 0 {
			if (agents[i].cheating) {
				fmt.Printf("general mal povodny rozkaz %v ale je to klamar\n", initOrder)
			} else {
				fmt.Printf("general mal povodny rozkaz %v\n", initOrder)
				decisions = decisions + strconv.Itoa(initOrder)
			}
		} else {
			if (agents[i].cheating) {
				fmt.Printf("agent %v je klamar\n", agents[i].id)
			} else {
				agents[i].traverse("0,")  // tu najdete rekuzivne preliazanie stromu bez vyhodnotenia vyslednej volby
				decistion := agents[i].postorder("0,") // a podobne mate naprogramovat metodu postorder, ktora vypocita vysledne rozhodnutie agenta
				decisions = decisions + strconv.Itoa(decistion)
				fmt.Printf("agent %v sa rozhodol %v\n", agents[i].id, decistion)
			}
		}
	}
	if (strings.Contains(decisions, "0") && strings.Contains(decisions, "1")) {
		fmt.Print("-------------------------------------------------- PROBLEM: ")
	} else {
		fmt.Print("-------------------------------------------------- OK: ")
	}
	sum, prod := 1, 1         // initial message to agent[0]
	for i := 0; i <= M; i++ { // M+1 times
		prod *= (N - i - 1)
		sum += prod
	}
	fmt.Printf("#Messages: global counter:%v, theoretical:%v, receivedByAllAgents:%v\n", Counter, sum, totalMessages)

}