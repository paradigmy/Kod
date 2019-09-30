var a = 0;  // jedina globalna premenna

function input(str) {  // funkcia, ktora vypromptuje celociselnu hodnotu 
	a = Number(prompt(str));
}
//---------------------------- az potialto, nic nemente

// súčet dvoch prirodzených čísel s jednou globalnou premennou
function sum2Nat1() {
   if (a > 0) {
     a--;
     sum2Nat1();
     a++;
   } else {
     input("Zadaj druhe cislo");
  }
}
function sum2Nat() {
  input("Zadaj prve cislo");
  sum2Nat1();
  alert('ich sucet je: ' + a);
}
// sum2Nat();

// súčet dvoch celých čísel s jednou globalnou premennou
function sum2Int1() {
	if (a > 0) {
		a--;
		sum2Int1();
		a++;
	} else {
		if (a < 0) {
			a++;
			sum2Int1();
			a--;
		} else {
			input("Zadaj druhe cislo");
		}
	}
}

// súčet dvoch prirodzených čísel s jednou globalnou premennou
function sum2Int() {
  input("Zadaj prve cislo");
	sum2Int1();
  alert('ich sucet je: ' + a);
}
//sum2Int();


//#############################################################
//# JS 2- V jazyku JS napíšte program, ktorý načíta zo vstupu pomocou príkazu
//# input("zadaj cislo:")
//# tri CELÉ čísla a pomocou príkazu alert(a)
//# vypíše ich súčet. V programe môžete použiť iba jednu globálnu celočíselnú
//# premennú "a" a procedúry/funkcie bez argumentov.
//# Program musí fungovať správne aj pre záporné hodnoty.

//    súčet troch celých čísel s jednou globalnou premennou
function sum3IntX2() {
	if (a > 0) {
		a--;
		sum3IntX2();
		a++;
	} else {
		if (a < 0) {
			a++;
			sum3IntX2();
			a--;
		} else {
			input("zadaj tretie cele cislo:");
		}
	}
}

//    súčet troch celých čísel s jednou globalnou premennou
function sum3IntX1() {
	if (a > 0) {
		a--;
		sum3IntX1();
		a++;
	} else {
		if (a < 0) {
			a++;
			sum3IntX1();
			a--;
		} else {
			input("zadaj druhe cele cislo:");
			sum3IntX2();
		}
	}
}

//    súčet troch celých čísel s jednou globalnou premennou
function sum3Int() {
	input("zadaj prve cele cislo:");
	sum3IntX1();
  alert('ich sucet je: ' + a);
}

// sum3Int();


// ##########################################################
// # JS3 - Maximum dvoch celých čísel
// # V jazyku Go napíšte program, ktorý zo štandardného vstupu pomocou príkazu
// # input("zadaj cislo:")
// # načíta prirodzené čísla a pomocou príkazu alert(a)
// # vypíše ich maximum.
// # V programe môžete použiť iba jednu globlnu celoeselnú premennú "a" a
// # procedúry bez argumentov.

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
function max2NatX2() {
	if (a > 0) {
		a--;
		max2NatX2();
		a = 3 * a;
	} else {
		a = 1;
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
function max2NatX1() {
	if (a > 0) {
		a--;
		max2NatX1();
		a = 2 * a;
	} else {
		input("zadaj druhe cele cislo:");
		max2NatX2();
	}
}3

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
function log2() {
	if (a > 1) {
		a = a / 2;
		log2();
		a++;
	} else {
		a = 0;
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
function log3() {
	if (a > 1) {
		a = a / 3;
		log3();
		a++;
	} else {
		a = 0;
	}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
function log6() {
	if (a == 1) {
		a = 0;
	} else if (a%6 == 0) {
		a = a / 6;
		log6();
		a++;
	} else if (a%2 == 0) {
			log2();
		} else {
			if (a%3 == 0) {
				log3();
			}
		}
}

//    maximum dvoch prirodzených čísel s jednou globálnou premennou
function max2Nat() {
	input("zadaj prve cele cislo:");
	max2NatX1();
	// v premennej a je 2^prve*3^druhe
	// ... ideme logaritmovat
	// alert(a)
	log6();
	alert("ich maximum je: " + a);
}
max2Nat();


