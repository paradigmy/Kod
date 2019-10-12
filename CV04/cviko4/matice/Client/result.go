// result
package main

import (
	"fmt"
	"encoding/json"
	"os"
)

type Result struct {
	I1     int   // index 1.vektora
	I2     int   // index 2.vektora
	Skalar Cislo // vysledok
}

func (t *Result)toString() string {
	return string(t.toBuffer()) + "\n"
}

func (t *Result)toBuffer() []byte {
	bytes, err := json.Marshal(*t)
	if err != nil {
		fmt.Printf("json encode error: %v\n", err)
		os.Exit(1)
	}
	return bytes
}

func buffer2Result(buffer []byte) Result {
	var res = Result{}
	err2 := json.Unmarshal(buffer, &res)
	if err2 != nil {
		fmt.Printf("json decode error: %v\n", err2)
		os.Exit(1)
	}
	return res
}