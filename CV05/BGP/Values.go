package main

import "strconv"

type Value int
const (
	ZA Value = 1
	PROTI Value = 0
	KLAMAR = -1
)
func (v Value) toString() string {
	return strconv.Itoa(int(v))
}
