package main

import (
	"bufio"
	"fmt"
	"net"
	"time"
)

func main() {
	conn, err :=
		net.Dial("udp", "0.sk.pool.ntp.org:123")
		//net.Dial("udp", "time.windows.com:123")
		//net.Dial("udp", "2.sk.pool.ntp.org:123")
		// net.Dial("udp", "3.sk.pool.ntp.org:123")
		//net.Dial("udp", "3.europe.pool.ntp.org:123")
	if err != nil {
		return
	}
	r := bufio.NewReader(conn)
	w := bufio.NewWriter(conn)
	data := make([]byte, 48)
	data[0] = 3<<3 | 3
	// fmt.Printf("%v", data[0])  // char 27
	conn.SetDeadline(time.Now().Add(5 * time.Second))
	defer conn.Close()
	w.Write(data) // send request
	w.Flush()
	data, _, err = r.ReadLine() // read response
	if err != nil {
		return
	}
	fmt.Println(data) // received response
	var sec, frac uint64
	// transmit time secs/ frac
	sec = uint64(data[43]) | uint64(data[42])<<8 | uint64(data[41])<<16 | uint64(data[40])<<24
	frac = uint64(data[47]) | uint64(data[46])<<8 | uint64(data[45])<<16 | uint64(data[44])<<24
	// received time secs/ frac
	//sec = uint64(data[36]) | uint64(data[34])<<8 | uint64(data[33])<<16 | uint64(data[32])<<24
	//frac = uint64(data[39]) | uint64(data[38])<<8 | uint64(data[37])<<16 | uint64(data[36])<<24
	nsec := sec * 1e9
	nsec += (frac * 1e9) >> 32
	t := time.Date(1900, 1, 1, 0, 0, 0, 0, time.UTC).Add(time.Duration(nsec)).Local()
	fmt.Printf("Network time: %v\n", t)
	fmt.Printf("System time: %v\n", time.Now())
}
