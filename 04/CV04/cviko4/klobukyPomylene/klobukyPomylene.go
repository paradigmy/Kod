package main

import (
	"fmt"
	"math/rand"
	"time"
)

var agenti	[]*Agent // pole vsetych agentov )
var finito  = make(chan bool) // kanal sluzi len na ukoncenie

type Agent struct {	 // agent definovany ako objekt
	id int			 // id agenta
	klobuk bool		 // farba jeho klobuka
	ch chan bool	 // kanal, na ktorom pocuva, hovorit sa mozu len farby, true/false
}
func newAgent(id int) *Agent { // nahodne vygeneruje farbu klobuka a pripoji agenta k existujucim
    agent := &Agent{len(agenti), rand.Intn(2) > 0, make(chan bool)}
	agenti = append(agenti, agent)
	return agent
}
func (agent Agent)toString() string {
	return fmt.Sprintf("agent %v ma klobuk %v ", agent.id, agent.klobuk)
}
// agenti stoja v rade, a kazdy agent i vidi len klobuky nasledujucich agentov
// aby sme nepodvadzali, tak toto je jedina funkcia, ktorou agenti pristupuju k polu klobukov
func (agent Agent)vidim() []bool {
	k := make([]bool, len(agenti)-agent.id-1)  // trochu 'matiky'
	for i := agent.id+1; i < len(agenti); i++ {
		k[i-agent.id-1] = agenti[i].klobuk
	}
	return k
}
// a este tato, ta nam overi, ci sa mylime
func (agent Agent)maPravdu(b bool) bool {
	return agent.klobuk == b
}
//------------------------------------------------------------------------
func xor(a bool, b bool) bool {		// pomocny stuff, xor dvoch booleanov
	return a!=b
}
func xorPola(pole []bool) bool {   // pomocny stuff, xor prvkov pola, resp. pocet true v poli, pre tych, co nemaju radi xor
	x := false
	for i := 0; i<len(pole); i++ {
		x = xor(x,pole[i])
	}
	return x
}
//-------------------------------------------------------------------------------
// zivot agenta
func (agent Agent)run()  {
	go func() {				// agent je gorutina
		x := false
		coSomPocul := make([]bool,0)
		coVidim := agent.vidim()
		if (agent.id == 0) {  // som prvy, asi musim nieco povedat, urcite necakam na ziadnu spravu
			x = xorPola(coVidim)
		} else {	 // nie som prvy, som dalsi v rade, preto cakam na spravy, od vsetkych predomnou
		    for {
				coSomPocul = append(coSomPocul, <- agent.ch)
		    	if len(coSomPocul) == agent.id {	// pocitam, kolko sprav som dostal, ak uz dost koncim
		    		break
				}
			}
			x = xor(xorPola(coSomPocul), xorPola(coVidim))
		}
		verdict := "MYLI SA"
		if (agent.maPravdu(x)) {
			verdict = "NE" + verdict
		}
		fmt.Printf("agent %v tvrdi, ze ma farbu %v \t a %v  \tlebo vidi %v a pocul %v\n", agent.id, x, verdict, agent.vidim(), coSomPocul)
		if (agent.id+1 < len(agenti)) { // ak nie je posledny v rade, tak musi vyslat vsetkym svoju farbu
			for i := agent.id+1; i<len(agenti); i++ {
				agenti[i].ch <- x // vsetkym agentom davam na znamost moju farbu
			}
		} else {
			finito <- true
		}
	}()
}
//----------------------------------------------------------------------------------------------------
func main() {
	rand.Seed(time.Now().UTC().UnixNano())  // inicializacia randomu
	N := 3+rand.Intn(8)			// pocet klobukov v hre random 3, ...11
	agenti = make([]*Agent, 0)
	for i := 0; i<N; i++ {
		agent := newAgent(i)
		fmt.Println(agent.toString())
	}
	for i := 0; i<N; i++ {
		agenti[i].run()
	}
	//time.Sleep(3000)
	<-finito
}
