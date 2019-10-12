package main

import (
	"bufio"
	"fmt"
	"io"
	"net"
)

type Person struct {
	Name  Name
	Email []Email
}

type Name struct {
	First string
	Last  string
}

type Email struct {
	Kind    string
	Address string
}

func (p Person) String() string {
	s := p.Name.First + " " + p.Name.Last
	for _, v := range p.Email {
		s += "\n" + v.Kind + ": " + v.Address
	}
	return s
}

func main() {
	conn, err := net.Dial("tcp", "google.com:80")
	if err != nil {
		fmt.Println("connection error: " + err.Error())
	} else {
		//fmt.Fprintf(conn, "GET / HTTP/1.0\r\n\r\n")
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
