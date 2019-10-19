package main

import (
	"bufio"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net"

	"github.com/davecgh/go-spew/spew" // pretty printer
	//"net"
	"os"
	"strconv"
	"time"
	//"github.com/gorilla/mux"          // webserver
	"github.com/joho/godotenv" // ini file reader
)

type Block struct {
	Index     int    // poradové číslo bloku v reťazci, začína 0
	Timestamp string // čas vytvorenia
	Data      int    // data blockchainu (v originali BPM)
	Hash      string // SHA256 haš hodnôt (Index, Timestamp, )
	PrevHash  string // SHA256 haš predošlého bloku
}

var Blockchain []Block	// celý blockchain

// vypočíta SHA 256 haš pre blok
func calculateHash(block Block) string {
	h := sha256.New()
	h.Write([]byte(string(block.Index) + block.Timestamp + string(block.Data) + block.PrevHash))
	hashed := h.Sum(nil)
	return hex.EncodeToString(hashed)
}

// vygeneruje novy blok s hodnotou Data, ale musíme poznat haš predošlého bloku
func generateBlock(oldBlock Block, Data int) (Block, error) {
	newBlock := Block{oldBlock.Index + 1, time.Now().String(), Data, "", oldBlock.Hash}
	newBlock.Hash = calculateHash(newBlock)
	return newBlock, nil
}

// skontroluje index a haš v bloku oproti predošlému bloku
func isBlockValid(newBlock, oldBlock Block) bool {
	return	(oldBlock.Index+1 == newBlock.Index) &&
		(oldBlock.Hash == newBlock.PrevHash) &&
		(calculateHash(newBlock) == newBlock.Hash)
}

// dlhsi block chain prebija kratsi
func replaceChain(newBlocks []Block) {
	if len(newBlocks) > len(Blockchain) {
		Blockchain = newBlocks
	}
}
//------------------------------------------------------------
// bcServer handles incoming concurrent Blocks
var bcServer chan []Block		// kanal, na ktorom počúvam prichádzajúce blockchain

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal(err)
	}
	// vytvor genesis block
	genesisBlock := Block{0, time.Now().String(), 0, "", ""}
	genesisBlock.Hash = calculateHash(genesisBlock)	// jeho hash
	spew.Dump(genesisBlock)
	Blockchain = append(Blockchain, genesisBlock)

	bcServer = make(chan []Block)		// prázdny blockchain

	port := 1
	var server  net.Listener
	for ; port < 6; port++ {
		// start TCP and serve TCP server
		ports := os.Getenv("SERVERSOCKETPORT"+strconv.Itoa(port))
		server, err = net.Listen("tcp", ":"+ports) // otvor Server socket na 9000
		if err != nil {
			if port < 5 {
				// asi je ten port obsadeny, skusme port+1
				continue
			} else {
				log.Fatal(err)
				fmt.Println("unable to open server socket")
			}
		} else {
			fmt.Println("listeninig on port localhost:" + ports)
			break;
		}
	}
	defer server.Close()		// final
	for {
		conn, err := server.Accept()
		if err != nil {
			log.Fatal(err)
		}
		go handleConn(conn)		// handler pre každého, čo urobí connect na 9000
	}
}
var nofclients = 0
func handleConn(conn net.Conn) {	// handler pre každého, čo urobí connect na 9000
	defer conn.Close()
	nofclients++
	fmt.Println("accepted connection, #clients: %d\n", nofclients)
	io.WriteString(conn, "Enter a new Data:")		// na konzolu vypise prompt
	scanner := bufio.NewScanner(conn)
	// take in Data from stdin and add it to blockchain after conducting necessary validation
	go func() {
		for scanner.Scan() {
			data, err := strconv.Atoi(scanner.Text())
			if err != nil {
				log.Printf("%v not a number: %v", scanner.Text(), err)
				continue
			}
			newBlock, err := generateBlock(Blockchain[len(Blockchain)-1], data)
			if err != nil {
				log.Println(err)
				continue
			}
			if isBlockValid(newBlock, Blockchain[len(Blockchain)-1]) {
				newBlockchain := append(Blockchain, newBlock)
				replaceChain(newBlockchain)
			}
			bcServer <- Blockchain		// pošle nový blockchain do kanálu
			io.WriteString(conn, "\nEnter a new Data:")
		}
	}()

	// broadcastuje cely blockchain do output ako json
	go func() {
		for {
			time.Sleep(30 * time.Second)
			output, err := json.Marshal(Blockchain)
			if err != nil {
				log.Fatal(err)
			}
			io.WriteString(conn, string(output))
		}
	}()
	// dump na konzolu
	for _ = range bcServer {
		spew.Dump(Blockchain)
	}
}
