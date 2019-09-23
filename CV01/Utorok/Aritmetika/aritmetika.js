var a = 0;  // jedina globalna premenna

function input(str) {  // funkcia, ktora vypromptuje celociselnu hodnotu 
	a = Number(prompt(str));
}
//---------------------------- az potialto, nic nemente

// ak nevies ako, pouzi repl.it
// alebo http://math.chapman.edu/~jipsen/js/
// alebo https://playcode.io/

// súčet dvoch prirodzených čísel s jednou globalnou premennou
function sum2Nat() {
  input("Zadaj prve cislo");
  alert('ich sucet je: ' + a);
}
sum2Nat();
