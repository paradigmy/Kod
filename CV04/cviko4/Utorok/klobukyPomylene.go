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
	// doprogramuje
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


























// toto je riesenie
//go func() {		// agent je gorutina
//	coVidim := agent.vidim()
//	res := xorPola(coVidim)
//	if (agent.id == 0) {  // prvy v rade
//		// spocitam odpoved a poslem vsetkym nasledujucim agentom
//	} else {
//		coSomPocul := make([]bool,0)  // musim pocet najprv id predoslych agentov
//		for i := 0; i<agent.id; i++ {
//			msg := <- agent.ch
//			coSomPocul = append(coSomPocul, msg)
//		}
//		res = xor(res, xorPola(coSomPocul))
//	}
//	fmt.Printf("agent %v ma klobuk %v a ma pravdu %v\n", agent.id, res, agent.maPravdu(res))
//	for i:=agent.id+1; i < len(agenti); i++ {
//		agenti[i].ch <- res
//	}
//	if (agent.id+1 == len(agenti)) { // som posledny, tak zakricim finish
//		finito <- true
//	}
//} ()
