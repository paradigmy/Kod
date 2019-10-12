package main

import (
	"bufio"
	"fmt"
	"io"
	"net"
)

func main() {
	conn, err := net.Dial("tcp", "google.com:80")
	if err != nil {
		fmt.Println("connection error: " + err.Error())
	} else {
		//fmt.Fprintf(conn, "GET / HTTP/1.0\r\n\r\n")
		// alebo
		fmt.Fprintf(conn, "HEAD / HTTP/1.0\r\n\r\n")
		r := bufio.NewReader(conn)
		for {
			line, _, err := r.ReadLine()
			if err == io.EOF {
				break
			}
			fmt.Printf("%s\n", line)
		}
	}
}
