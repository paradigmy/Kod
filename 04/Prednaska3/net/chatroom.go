package main

import (
	"bufio"
	"fmt"
	"io"
	"net"
)

//--------------------------
type ChatClient struct {
	clientID int
	reader   *bufio.Reader
	writer   *bufio.Writer
}

func NewChatClient(clientID int, conn net.Conn) *ChatClient {
	return &ChatClient{
		clientID: clientID,
		reader:   bufio.NewReader(conn),
		writer:   bufio.NewWriter(conn),
	}
}

//---------------------------
type ChatRoom struct {
	clients []*ChatClient
}

func NewChatRoom() *ChatRoom {
	chatRoom := &ChatRoom{
		clients: make([]*ChatClient, 0),
	}
	return chatRoom
}

func (chr *ChatRoom) NewChatClient(conn net.Conn) *ChatClient {
	chatclient := NewChatClient(len(chr.clients)+1, conn)
	fmt.Printf("new client: %d\n", chatclient.clientID)
	chr.clients = append(chr.clients, chatclient)
	return chatclient
}

//---------------------------

func (chr *ChatRoom) handleConnection(conn net.Conn) {
	chatclient := NewChatClient(len(chr.clients)+1, conn)
	fmt.Printf("new client: %d\n", chatclient.clientID)
	chr.clients = append(chr.clients, chatclient)
	for {
		line, _, err := chatclient.reader.ReadLine()
		if err == io.EOF {
			break
		}
		msg := fmt.Sprintf("%d>%s\r\n", chatclient.clientID, line)
		fmt.Print(msg) // vypis na konzolu chatroomu
		for _, client := range chr.clients {
			if client.clientID != chatclient.clientID {
				client.writer.WriteString(msg)
				client.writer.Flush()
			}
		}
	}
}

func main() {
	chatRoom := NewChatRoom()
	listener, _ := net.Listen("tcp", ":8080")
	fmt.Println("listening on port localhost:8080")
	for {
		conn, _ := listener.Accept()
		go chatRoom.handleConnection(conn)
	}
}
