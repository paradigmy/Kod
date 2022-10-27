package main
import ("fmt")

func main() {
	var xx = 89
	yy := float64(xx)
	fmt.Println(yy)
	fmt.Println("Hello " + "world !")

	var imaginarnaJednotka = 1i // imaginarna jednotka
	fmt.Print("i*i =")
	fmt.Println(imaginarnaJednotka * imaginarnaJednotka)
	fmt.Print("0b1100 &^ 0b1010 =")
}