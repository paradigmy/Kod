package main

import (
	"bufio"
	"fmt"
	"io"
	"net/http"
	"net/http/httputil"
	"os"
	"regexp"
)

func main() {
	url := "http://google.com"
	//url := "http://dai.fmph.uniba.sk/courses/PARA/"
	response, err := http.Head(url)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(2)
	}
	fmt.Println(response.Status)
	fmt.Println("\nheader:")
	for k, v := range response.Header {
		fmt.Println(k+":", v)
	}
	if response.Status != "200 OK" {
		fmt.Println(response.Status)
		os.Exit(2)
	}
	response, err = http.Get(url)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(2)
	}
	b, _ := httputil.DumpResponse(response, false)
	fmt.Println("\nresponse:")
	fmt.Print(string(b))

	fmt.Println("\nbody:")
	reader := bufio.NewReader(response.Body)
	for {
		line, _, err := reader.ReadLine()
		if err == io.EOF {
			break
		}
		strline := string(line)
		var httpRef = regexp.MustCompile(`\s*(?i)href\s*=\s*(\"([^"]*\")|'[^']*'|([^'">\s]+))`)
		matches := httpRef.FindAllString(strline, -1)
		for _, match := range matches {
			fmt.Println(match)
		}
	}
}
