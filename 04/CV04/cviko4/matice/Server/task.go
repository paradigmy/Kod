// task
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Task struct {
	I1 int    // index 1.vektora
	V1 Vektor // vektor
	I2 int    // index 2.vektora
	V2 Vektor // vektor
}

func (t *Task) toString() string {
	return string(t.toBuffer()) + "\n"
}

func (t *Task) toBuffer() []byte {
	bytes, err := json.Marshal(*t)
	if err != nil {
		fmt.Printf("json encode error: %v\n", err)
		os.Exit(1)
	}
	return bytes
}

func buffer2Task(buffer []byte) Task {
	var tsk = Task{}
	//fmt.Println("%s", buffer)
	err2 := json.Unmarshal(buffer, &tsk)
	if err2 != nil {
		fmt.Printf("json decode error: %v\n", err2)
		os.Exit(1)
	}
	return tsk
}

/*
func (t *Task) doit() {
	t.rs <- &Result{I1: t.I1, I2: t.I2, Skalar: sucin(t.V1, t.V2)}
}

func (t *Task) sucin(a, b Vektor) Cislo {
	return sucin(t.V1, t.V2)
}
*/
