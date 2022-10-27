package main

import (
	"bufio"
	"fmt"
	"io"
	"net"
)

func handleConnection(conn net.Conn) {
	fmt.Println("accepted connection from a client")
	r := bufio.NewReader(conn)
	for {
		line, _, err := r.ReadLine()
		fmt.Printf("%s\n", line)
		if err == io.EOF {
			break
		}
	}
}

func main() {
	ln, err := net.Listen("tcp", ":8080")
	fmt.Println("listening on port localhost:8080")
	if err != nil {
		fmt.Println("connection error: " + err.Error())
	} else {
		conn, err := ln.Accept()
		if err != nil {
			fmt.Println("connection error: " + err.Error())
		} else {
			handleConnection(conn)
		}
	}
}
