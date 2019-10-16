// zdroj: https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc
// refaktorovany
package main

import (
	"crypto/sha256" // cropto
	"encoding/hex"
	"encoding/json"                   // Mashall UnMashall
	"github.com/davecgh/go-spew/spew" // pretty printer
	"github.com/gorilla/mux"          // webserver
	"github.com/joho/godotenv"        // ini file reader
	"io"
	"log"
	"net/http"
	"os"
	"time"
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
//----------------------------------------------------------------------
// web-server
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

// GET Method handler
func handleGET(w http.ResponseWriter, r *http.Request) {
	bytes, err := json.MarshalIndent(Blockchain, "", "  ")  // cely blockchain prehodi do JSONu
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	io.WriteString(w, string(bytes))	// a vypíše do responsu
}

type Message struct {
	Data int
}

// POST Method handler
func handlePOST(w http.ResponseWriter, r *http.Request) {
	var m Message
	decoder := json.NewDecoder(r.Body)		// dekódujeme body POST do štruktúry Message, ak sa da
	if err := decoder.Decode(&m); err != nil {
		respondWithJSON(w, r, http.StatusBadRequest, r.Body)
		return
	}
	defer r.Body.Close()	// vytvoríme nový blok s novou hodnotou
	newBlock, err := generateBlock(Blockchain[len(Blockchain)-1], m.Data)
	if err != nil {
		respondWithJSON(w, r, http.StatusInternalServerError, m)
		return
	}
	if isBlockValid(newBlock, Blockchain[len(Blockchain)-1]) {
		newBlockchain := append(Blockchain, newBlock)
		replaceChain(newBlockchain)
		spew.Dump(Blockchain) // fmt.Println(Blockchain)
	}
	respondWithJSON(w, r, http.StatusCreated, newBlock)
}

func respondWithJSON(w http.ResponseWriter, r *http.Request, code int, payload interface{}) {
	response, err := json.MarshalIndent(payload, "", "  ")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("HTTP 500: Internal Server Error"))
		return
	}
	w.WriteHeader(code)
	w.Write(response)
}

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal(err)
	}
	go func() {
		t := time.Now()
		genesisBlock := Block{0, t.String(), 0, "", ""} // pociatocny blok
		genesisBlock.Hash = calculateHash(genesisBlock)
		spew.Dump(genesisBlock) //	fmt.Println(genesisBlock)
		Blockchain = append(Blockchain, genesisBlock)
	}()
	log.Fatal(run())		// spusti web-server
}
