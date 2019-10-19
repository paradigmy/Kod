package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"github.com/davecgh/go-spew/spew" // pretty printer
	"github.com/gorilla/mux"          // webserver
	"github.com/joho/godotenv"        // ini file reader
	"io"
	"log"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"
)


const difficulty =
	// 1
	// 2
	 3
	// 4
	// 5
	//6
	// 7 // toto je tvoja voľba !

type Block struct {
	Index     int    // poradové číslo bloku v reťazci, začína 0
	Timestamp string // čas vytvorenia
	Data      int    // data blockchainu (v originali BPM)
	Hash      string // SHA256 haš hodnôt (Index, Timestamp, )
	PrevHash  string // SHA256 haš predošlého bloku
	Difficulty int
	Nonce      string
}

var Blockchain []Block	// celý blockchain

type Message struct {
	Data int
}

var mutex = &sync.Mutex{}

func run() error {
	muxRouter := mux.NewRouter()
	muxRouter.HandleFunc("/", handleGET).Methods("GET")
	muxRouter.HandleFunc("/", handlePOST).Methods("POST")

	port := os.Getenv("ADDR")		// port: 8080
	log.Println("Listening on ", port)
	s := &http.Server{
		Addr:           ":" + port,
		Handler:        muxRouter,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	if err := s.ListenAndServe(); err != nil {
		return err
	}
	return nil
}

func handleGET(w http.ResponseWriter, r *http.Request) {
	bytes, err := json.MarshalIndent(Blockchain, "", "  ")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	io.WriteString(w, string(bytes))
}

func respondWithJSON(w http.ResponseWriter, r *http.Request, code int, payload interface{}) {
	w.Header().Set("Content-Type", "application/json")
	response, err := json.MarshalIndent(payload, "", "  ")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("HTTP 500: Internal Server Error"))
		return
	}
	w.WriteHeader(code)
	w.Write(response)
}
func handlePOST(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var m Message

	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&m); err != nil {
		respondWithJSON(w, r, http.StatusBadRequest, r.Body)
		return
	}
	defer r.Body.Close()

	//ensure atomicity when creating new block
	mutex.Lock()
	newBlock := generateNewBlock(Blockchain[len(Blockchain)-1], m.Data)
	mutex.Unlock()

	if isBlockValid(newBlock, Blockchain[len(Blockchain)-1]) {
		Blockchain = append(Blockchain, newBlock)
		spew.Dump(Blockchain)
	}
	respondWithJSON(w, r, http.StatusCreated, newBlock)
}

// skontroluje index a haš v bloku oproti predošlému bloku
func isBlockValid(newBlock, oldBlock Block) bool {
	return	(oldBlock.Index+1 == newBlock.Index) &&
		(oldBlock.Hash == newBlock.PrevHash) &&
		(calculateHash(newBlock) == newBlock.Hash)
}

// vypočíta SHA 256 haš pre blok
func calculateHash(block Block) string {
	h := sha256.New()
	h.Write([]byte(string(block.Index) + block.Timestamp + string(block.Data) + block.PrevHash + block.Nonce))
	hashed := h.Sum(nil)
	return hex.EncodeToString(hashed)
}

// vygeneruje novy blok s hodnotou Data, ale musíme poznat haš predošlého bloku
func generateNewBlock(oldBlock Block, Data int) (Block) {
	newBlock := Block{oldBlock.Index + 1, time.Now().String(), Data, "", oldBlock.Hash, difficulty, ""}
	newBlock.Hash = calculateHash(newBlock)

	startTime := time.Now()

	for nonce := 0; ; nonce++ {
		newBlock.Nonce = fmt.Sprintf("%x", nonce)
		// if !isHashValid(calculateHash(newBlock), newBlock.Difficulty) {
		if !strings.HasPrefix(calculateHash(newBlock), strings.Repeat("0", difficulty)) {
			fmt.Println(calculateHash(newBlock), " do more work!")
			// toto hodne pomoze, ked zakomentujete...
			time.Sleep(time.Second)
			continue
		} else {
			endTime := time.Now()
			fmt.Println(calculateHash(newBlock), " work done!")
			fmt.Printf("Hash/s: %f10.5\n", 1000000000*float64(nonce)/float64(endTime.Sub(startTime).Nanoseconds()))
			newBlock.Hash = calculateHash(newBlock)
			break
		}

	}
	return newBlock
}

// haš začína difficulty x 0
func isHashValid(hash string, difficulty int) bool {
	return strings.HasPrefix(hash, strings.Repeat("0", difficulty))
}

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal(err)
	}
	go func() {
		t := time.Now()
		genesisBlock := Block{}
		genesisBlock = Block{0, t.String(), 0, calculateHash(genesisBlock), "", difficulty, ""}
		spew.Dump(genesisBlock)

		mutex.Lock()
		Blockchain = append(Blockchain, genesisBlock)
		mutex.Unlock()
	}()
	log.Fatal(run())
}