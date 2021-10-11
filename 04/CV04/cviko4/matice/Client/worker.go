package main

import (
	"bufio"
	"fmt"
	"net"
)

type Worker struct {
	host   string
	port   string
	conn   net.Conn
	busy   bool
	reader *bufio.Reader
	writer *bufio.Writer
}

func NewWorker(host string, port string) *Worker {
	conn, err := net.Dial("tcp", host+":"+ port)
	if err != nil {
		fmt.Printf("worker %d zlyhal\n", port)
	}
	return &Worker{host, port, conn, false,
		bufio.NewReader(conn), bufio.NewWriter(conn)}
}

func (w *Worker) doit(t *Task, chainRes chan Result) {
	w.writer.WriteString(t.toString())
	w.writer.Flush()		
	fmt.Printf("worker %v pracuje\n", w.port)
	resbytes, _, _ := w.reader.ReadLine()
	res := buffer2Result(resbytes)
	w.busy = false
	chainRes <- res
}
