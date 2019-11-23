%-- protekcie

pozna(jano, fero).
pozna(fero, jozo).
pozna(jano, ludovit).
pozna(zuzka, amalka).
pozna(zuzka, maria).
pozna(maria, fero).
pozna(cyril, metod).

protekcia(X,X).
protekcia(X,Y) :- protekcia(Y,X).
protekcia(X,Y) :- protekcia(X,Z), pozna(Z,Y).
protekcia(X,Y) :- protekcia(Z,Y), pozna(X,Z).

% - rodinka
rodic(jano, zuzka).
rodic(jano, palko).
rodic(zuzka, miska).
muz(jano).
muz(palko).
zena(zuzka).
zena(miska).

otec(X,Y) :- rodic(X,Y), muz(X).
dedo(X,Y) :- otec(X,Z), rodic(Z,Y).
brat(X,Y) :- rodic(Z,X), rodic(Z,Y), muz(X).

predok(X,Y) :- rodic(X,Y).
predok(X,Y) :- rodic(X,Z), predok(Z,Y).

vrstovnik(X,X).
vrstovnik(X,Y):- rodic(Xr,X), rodic(Yr,Y), vrstovnik(Xr,Yr).

skutocnyVrstovnik(X,Y) :- vrstovnik(X,Y), not(X=Y).

%---- Peanova aritmetika

less(0, succ(_)).
less(succ(X), succ(Y)) :- less(X,Y).

add(0,Y,Y).
add(succ(X),Y,succ(Z)) :- add(X,Y,Z).

time(0,_,0).				%-- time(X,Y,Z) ? Z = X*Y
time(succ(X), Y, Z) :- time(X,Y,W), add(W,Y,Z).

fact(0,succ(0)).				%-- fact(N,F) ? F = N!
fact(succ(N),F) :- fact(N,F1), time(succ(N), F1, F).

						%-- modulo(X,Y,Z)?Z = X mod Y
modulo(X,Y,Z) :- less(Z,Y), add(W,Z,X), time(Y,_,W).

						%-- nsd(X,Y,G)?G je nsd(X,Y) najvacsi spolocny delitel
nsd(X,Y,G) :- modulo(X,Y,Z), nsd(Y,Z,G).
nsd(X,0,X) :- less(0,X).

%--

mult(0,_,0).
mult(X,Y,Z) :- X>0, X1 is X-1, mult(X1,Y,W), Z is W+Y.

factorial(0,1).
factorial(N,F) :- N>0, N1 is N-1, factorial(N1,F1), F is N*F1.


%% ---

mymember(X, [X|_]).
mymember(X, [_|Ys]) :- mymember(X,Ys).

len([], 0).
len([_|Xs], s(L)) :- len(Xs,L).
%--len([_|Xs], L1) :- len(Xs,L), L1 is L+1.

myprefix([], _).
myprefix([X|Xs], [X|Ys]) :- myprefix(Xs, Ys).

%--

%- zoznam usporiadaný vzostupne
vzostupne([]).
vzostupne([_]).
vzostupne([X1,X2|Xs]) :- X1=<X2, vzostupne([X2|Xs]).

%- zoznam usporiadaný zostupne
zostupne([]).
zostupne([_]).
zostupne([X1,X2|Xs]) :- X1>=X2, zostupne([X2|Xs]).

%- usporiadaný zoznam
usporiadany(X) :- zostupne(X) ; vzostupne(X).

%--

nAzJedna(0,[]).
nAzJedna(N,[N|X]):-N>0,N1 is N-1,nAzJedna(N1,X).


jednaAzN(N,Res):-jednaAzN(N,[],Res).
jednaAzN(0,Acc,Res):-Acc=Res.
jednaAzN(N,Acc,Res):-N>0,N1 is N-1,jednaAzN(N1,[N|Acc],Res).

%---

%- súvislý podzoznam, napr. sublist([3,4,5],[1,2,3,4,5,6])
sublist1(X,Y) :- append(_,X,V),append(V,_,Y).
sublist2(X,Y) :- append(V,_,Y),append(_,X,V).

%- chvost zoznamu
sufix(Xs,Xs).
sufix(Xs,[_|Ys]):-sufix(Xs,Ys).

%- keï už poznáme reverse...
sufix1(Xs,Ys):-reverse(Xs,Xs1),reverse(Ys,Ys1),prefix(Xs1,Ys1).

%- ešte raz podzoznam
sublst(Xs,Ys):-prefix(W,Ys),sufix(Xs,W).
sublst2(Xs,Ys):-sufix(W,Ys),prefix(Xs,W).

%- vybrata podpostupnost (nesuvisla) zo zoznamu
subseq([X|Xs],[X|Ys]):-subseq(Xs,Ys).
subseq(Xs,[_|Ys]) :- subseq(Xs,Ys).
subseq([],_).
%--
zoznamToInt([],0).
zoznamToInt([X|Xs],C) :- zoznamToInt(Xs,C1), C is 10*C1+X.

intToZoznam(0,[]).
intToZoznam(C,[X|Xs]) :- C > 0, X is C mod 10, C1 is C // 10, intToZoznam(C1,Xs).

zoznamToInt2(X,Res) :- zoznamToInt2(X,0,Res).
zoznamToInt2([],C,Res) :- Res = C.
zoznamToInt2([X|Xs],C,Res) :- C1 is 10*C+X, zoznamToInt2(Xs,C1, Res).

intToZoznam2(X,Res) :- intToZoznam2(X,[],Res).
intToZoznam2(0,Res,Res).
intToZoznam2(C,Xs,Res) :- C > 0, X is C mod 10, C1 is C // 10, intToZoznam2(C1,[X|Xs],Res).
%--
flat([X|Xs],Ys) :- flat(X,Ys1), flat(Xs,Ys2), append(Ys1, Ys2, Ys).
flat(X, [X]) :- atomic(X), X\=[].
flat([],[]).

flat1(X,Y) :- flat1(X, [], Y).
flat1([X|Xs], Ys1, Ys) :- flat1(X, Ys1, Ys2), flat1(Xs, Ys2, Ys).
flat1(X,Ys,[X|Ys]) :- atomic(X), X\=[].
flat1([], Ys, Ys).

%--
myappend([], X, X).
myappend([X | Xs], Y, [X | Zs]) :- myappend(Xs, Y, Zs).
%--

myreverse([], []).
myreverse([X|Xs], Y) :- myreverse(Xs, Ys), append(Ys, [X], Y).

areverse(X, Y) :- reverse(X, [], Y).
reverse([], Acc, Acc).
reverse([X | Xs], Acc, Z) :- reverse(Xs, [X | Acc], Z).

%-- neprázdny zoznam
neprazdnyZoznam([_|_]).

%- aspoò dvojprvkový zoznam
asponDvojPrvkovyZoznam([_,_|_]).

%- tretí prvok
tretiPrvok([_,_,T|_],T).

%- posledný prvok zoznamu
posledny([X],X).
%- posledny([_,Y|Ys],X):-posledny([Y|Ys],X).
posledny([_|Ys],X):-posledny(Ys,X).

%- tretí od konca
tretiOdKonca(Xs,T) :- reverse(Xs,Ys),tretiPrvok(Ys,T).

%- prostredný prvok zoznamu, ak existuje
prostredny(Xs,T):-append(U,[T|V],Xs),length(U,L), length(V,L).


%--
hrana(a,b).
hrana(c,a).
hrana(c,b).
hrana(c,d).

cesta(X,X).
cesta(X,Y) :- hrana(X, Z), cesta(Z, Y).

%-- cesta(X,Y) :- (hrana(X, Z) ; hrana(Z, X)), cesta(Z, Y).



%------------------

neohrana(X,Y) :- hrana(X,Y).
neohrana(X,Y) :- hrana(Y,X).

cesta1(X, X, _).
cesta1(X, Y,C):-neohrana(X, Z), not(member(Z,C)), cesta1(Z, Y,[Z|C]).

cesta2(X,X,C,Res) :- Res = C.
cesta2(X,Y,C,Res) :- neohrana(X, Z), not(member(Z,C)), cesta2(Z,Y,[Z|C],Res).

%------------------

magicke(X):-magicke(X,0,0).

magicke([],_,_).
magicke([X|Xs],Cislo,N) :- Cislo1 is 10*Cislo+X, N1 is N+1,
				        0 is Cislo1 mod N1,
				        magicke(Xs,Cislo1,N1).

uplneMagicke(X) :- magicke(X),
	member(1,X), member(2,X), member(3,X),
	member(4,X), member(5,X), member(6,X),
	member(7,X), member(8,X), member(9,X).

%---

cifra(1).
cifra(2).
cifra(3).
cifra(4).
cifra(5).
cifra(6).
cifra(7).
cifra(8).
cifra(9).

umag(X):-cifra(C1),cifra(C2),cifra(C3),cifra(C4),cifra(C5),cifra(C6),
		cifra(C7),cifra(C8),cifra(C9),uplneMagicke([C1,C2,C3,C4,C5,C6,C7,C8,C9]),
		zoznamToInt2([C1,C2,C3,C4,C5,C6,C7,C8,C9],X).


umagicifra(X):- length(X,9) -> zoznamToInt2(X,Y),write(Y),nl
			;
			cifra(C),not(member(C,X)),
			append(X,[C],Y),magicke(Y),umagicifra(Y).

umagic7(X):- length(X,7) -> zoznamToInt2(X,Y),write(Y),nl,fail
			;
			cifra(C),not(member(C,X)),
			append(X,[C],Y),magicke(Y),umagic7(Y).


main :- pozna(X,Y), write((X,Y)), nl, fail.