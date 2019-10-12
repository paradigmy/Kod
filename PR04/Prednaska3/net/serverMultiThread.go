package main

import (
	"bufio"
	"fmt"
	"io"
	"net"
	"time"
)

var nofclients = 0
func handleConnectionTime1(conn net.Conn) {
	nofclients++
	fmt.Printf("accepted connection from a client %d\n", nofclients)
	w := bufio.NewWriter(conn)
	w.WriteString(time.Now().String() + "\r\n")
	w.Flush()
	//conn.Close()
}

func handleConnection1(conn net.Conn) {
	nofclients++
	fmt.Printf("accepted connection from a client %d\n", nofclients)

	w := bufio.NewWriter(conn)
	w.WriteString(time.Now().String() + "\r\n")
	w.Flush()
	
	r := bufio.NewReader(conn)
	for {
		line, _, err := r.ReadLine()
		if err == io.EOF {
			break
		}
		fmt.Printf("%s\n", line)
	}
}

func main() {
	ln, err := net.Listen("tcp", ":8080")
	fmt.Println("listening on port localhost:8080")
	if err != nil {
		fmt.Println("connection error: " + err.Error())
	} else {
		for {
			conn, err := ln.Accept()
			if err != nil {
				fmt.Println("connection error: " + err.Error())
				continue
			}
			//go handleConnectionTime1(conn)
			go handleConnection1(conn)
		}
	}
}
