package main

import "fmt"

type BinNode struct {
	left  *BinNode
	value int
	right *BinNode
}

func generate(n int) *BinNode {
	if n == 0 {
		return nil
	} else {
		//return &BinNode{generate(n - 1), n, generate(n - 1)}
		//return &BinNode{value: n, left: generate(n - 1), right: generate(n - 1)}

		bt := new(BinNode)
		bt.left = generate(n - 1)
		bt.value = n
		bt.right = generate(n - 1)
		return bt

	}
}

func preorder(bt *BinNode) {
	if bt == nil {
		fmt.Print("nil")
	} else {
		fmt.Print("<")
		fmt.Print(bt.value)
		fmt.Print(",")
		preorder(bt.left)
		fmt.Print(",")
		preorder(bt.right)
		fmt.Print(">")
	}
}

func (bt *BinNode) inorder() {
	if bt == nil {
		fmt.Print("nil")
	} else {
		fmt.Print("<")
		bt.left.inorder()
		fmt.Print(",")
		fmt.Print(bt.value)
		fmt.Print(",")
		bt.right.inorder()
		fmt.Print(">")
	}
}

func main() {
	preorder(generate(4))
	fmt.Println()
	generate(4).inorder()
	fmt.Println()
	generate(0).inorder()
	fmt.Println()
}
