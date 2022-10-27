package main

import (
	"bufio"
	"fmt"
	"io"
	"net"
	"os"
	"time"
)

//type Cislo float64 // toto si nechame na realne testovanie, zataz
type Cislo int
type Vektor []Cislo

//------------------------------------------

// sucin vektorov
func sucin(a Vektor, b Vektor) (s Cislo) {
	if len(a) != len(b) {
		return 0
	} else {
		s = 0
		for i := 0; i < len(a); i++ {
			s += a[i] * b[i]
		}
		return s
	}
}

func handleConnection(conn net.Conn) {
	r := bufio.NewReader(conn)
	w := bufio.NewWriter(conn)
	for {
		inbytes, _, err := r.ReadLine()
		if err == io.EOF || len(inbytes) < 3 {
			break
		}
		task := buffer2Task(inbytes)  // dekodovanie z json
		fmt.Printf("prisla robota: %v\n", task)
		time.Sleep(time.Second)
		time.Sleep(time.Second)
		time.Sleep(time.Second)
		res := Result{task.I1, task.I2, sucin(task.V1, task.V2)}
		fmt.Printf("vysledok: %v\n", res)
		w.WriteString(res.toString())
		w.Flush()
	}
}

// skalarnyServer.exe :port
func main() { 
	if len(os.Args) < 2 {
		fmt.Println("usage: \n")
		fmt.Println("server.exe port\t- spusti skalarny server na porte")
	} else {
		port := os.Args[1]
		fmt.Println("pocuvam " + port)
		ln, err := net.Listen("tcp", "localhost:"+port)
		if err != nil {
			fmt.Println("nepodarilo sa posadit Listenera na " + "localhost" + port)
		} else {
			for {
				conn, errc := ln.Accept()
				if errc != nil {
					fmt.Println("nepodarilo sa otvorit konekciu")
					return
				}
				go handleConnection(conn)
			}
		}
	}
}
