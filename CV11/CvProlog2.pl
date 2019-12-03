%---- maly navrat k minulej rozcvicke
%- boli taketo riesenia
pocetA([],0).
pocetA([a|Xs],N) :- N1 is N-1, pocetA(Xs,N1).

%% aj taketo boli, ale tam uz je logicka chyba, zamyslite sa...
%% pocetA([a|Xs],N) :- N1 is N+1, pocetA(Xs,N1).

% jediny problem, ze volanie skonci takto
%?- pocetA([a,a,a],X).
% ERROR: Arguments are not sufficiently instantiated

/*
dovod: napriek tomu, ze hovorite, ze existuje X, tak on si prirodzene cisla nevie vyenumerovat
 
takty khack ide, ale tak sa neprogramuje !!!!!!!!!!!


?- between(0,1000000,X),pocetA([a,a,a],X).
X = 3 ;
false.  <- kym vam vypise tento false, tak naozaj vyskusa milion moznosti

*/

% takto to malo/mohlo byt - toto je REKUZIA

count([], 0).
count([a|Xs], N):-count(Xs,N1), N is N1+1.
 
/*
?- count([a,a,a],X).
X = 3.
*/ 

% takto to malo/mohlo byt - toto je ITERACIA, ALIAS CYKLUS

loop([], Acc, Acc).
%zaciatocnik napise: 
%loop([], Acc, Res) :- Res = Acc.
loop([a|Xs], Acc, Res):-Acc1 is Acc+1, loop(Xs,Acc1,Res).
% a chyba hlavne volanie, to nezabudnite, lebo neviem, co je inicialna hodnota Acc
loop(Xs, Res) :- loop(Xs,0,Res).

/*
?- loop([a,a,a],X).
X = 3.
*/

% geralizacia, countX rata pismenka X
countX(_,[], 0).
%countX(X,[X|Xs], N):-countX(X,Xs,N1), N is N1+1.
%countX(X,[Y|Xs], N):-not(X=Y),countX(X,Xs,N).
% takto sa pise if-then-else
countX(X,[Y|Xs], N):-X==Y->(countX(X,Xs,N1), N is N1+1);countX(X,Xs,N).

/*
?- countX(a,[a,b,b,a],X).
X = 2 ;
false.
*/

% potom zle riesenia rozcviky mohli vyzerat

aNbNPomiesane(Xs) :- countX(a,Xs,Pa), countX(b,Xs,Pb), Pa = Pb.
/* :( :(
?- aNbNPomiesane([a,b,b,a]).
true ;
*/

matejM(Xs):-pomaNbM(Xs,0,0), aNbM(Xs).
pomaNbM([a|Xs],P1,P2):-P3 is P1+1, pomaNbM(Xs,P3,P2).
pomaNbM([b|Xs],P1,P2):-P3 is P2+1, pomaNbM(Xs,P1,P3).
pomaNbM([],P1,P2):-P1=:=P2.

% Definujte predikat, ktory plati, ak zoznam je tvaru a^n b^m
aNbM([a|Xs]):-aNbM(Xs).
aNbM([b|Xs]):-bM(Xs).
bM([b|Xs]):-bM(Xs).
bM([]).


% spravne riesenie
aNbNPocitadlove(Xs):-pocitajA(Xs,0,0).
pocitajA([a|Xs],A,B):-A1 is A+1,pocitajA(Xs,A1,B).
pocitajA([b|Xs],A,B):-B1 is B+1,pocitajB(Xs,A,B1).
pocitajB([b|Xs],A,B):-B1 is B+1,pocitajB(Xs,A,B1).
pocitajB([],A,A).
%pocitajB([],A,B):-A=B.

/*
?- aNbNPocitadlove([a,a,b,b]).
true.

?- aNbNPocitadlove([a,b,b,a]).
false.
*/

% Definujte predikat, ktory plati, ak zoznam je tvaru a^n b^n
aNbN([]).
aNbN([a|Xs]):-reverse(Xs,[b|XrR]),reverse(XrR,Ys),aNbN(Ys).

/*
|    aNbN([a,a,b,b]).
true.

?- aNbN([a,b,b,a]).
false.
*/

% posledne riesenie je pecka do hlavy, pochopenim zazijete Paradigm shift...

aNbNPecka(Xs):-append(Acka,Bcka,Xs),length(Acka,N),length(Bcka,N),xN(a,Acka),xN(b,Bcka).

% x^N
xN(X,[X|Xs]):-xN(X,Xs).
xN(_,[]).

/*
?- aNbNPecka([a,a,b,b]).
true ;

?- aNbNPecka([a,b,b,a]).
false.

?- aNbNPecka([a,b,b]).
false.
*/


%-------------------------------------- HLADANIE CEST V CYKLICKOM GRAFE

% - bude na prednaske
% cesta(X,Y,[],Path) plati, ak v grafe urcenom relaciou next existuje cesta z X do Y a Path je tato cesta od konca, urob reverz a mas cestu

cesta(X,X,P,P).
cesta(X,Y,Visited,P):- 
    next(X,Z), 
    not(member(Z,Visited)), 
    cesta(Z,Y,[Z|Visited],P).

/*------------------------------------------------------------------------------------------------
na siedmych kamenoch sedi 6 ziab, 3 otocene vpravo, 3 vlavo, stredny kamen volny.
Zaby sa nikdy neotocia do protismeru, a zaba moze skocit v svojom smere
na susedny volny kamen, alebo preskocit jednu (!) zabu

prave zabky chcu ist na vlavo a lave napravo, ako ?

idea
konfiguracia ziab je kodovana ako 7-prvkovy zoznam
[z1,z2,z3,z4,z5,z6,z7], kde zi = -1, 0, 1,
0 je medzera
*/
init([-1,-1,-1,0,1,1,1]).
final(Xs):-init(Ys),reverse(Ys,Xs).

next(C1, C2) :- append(X,[0,1|Y],C1), append(X,[1,0|Y],C2).
next(C1, C2) :- append(X,[-1,0|Y],C1), append(X,[0,-1|Y],C2).

next(C1, C2) :- append(X,[0,-1,1|Y],C1), append(X,[1,-1,0|Y],C2).
next(C1, C2) :- append(X,[-1,1,0|Y],C1), append(X,[0,1,-1|Y],C2).


zabky :- init(I), final(F), cesta(I,F,[],P), writeZabky(P).

writeZabky([]):-nl.
writeZabky([Z|Zs]):-write(Z), nl, writeZabky(Zs).

/*
riesenie:

?- zabky.
[1, 1, 1, 0, -1, -1, -1]
[1, 1, 0, 1, -1, -1, -1]
[1, 1, -1, 1, 0, -1, -1]
[1, 1, -1, 1, -1, 0, -1]
[1, 1, -1, 0, -1, 1, -1]
[1, 0, -1, 1, -1, 1, -1]
[0, 1, -1, 1, -1, 1, -1]
[-1, 1, 0, 1, -1, 1, -1]
[-1, 1, -1, 1, 0, 1, -1]
[-1, 1, -1, 1, -1, 1, 0]
[-1, 1, -1, 1, -1, 0, 1]
[-1, 1, -1, 0, -1, 1, 1]
[-1, 0, -1, 1, -1, 1, 1]
[-1, -1, 0, 1, -1, 1, 1]
[-1, -1, -1, 1, 0, 1, 1]
*/

%-----------------------------------------------------------------------------------------
% co tak 4+4 zabky

init8([-1-1,-1,-1,0,1,1,1,1]).
final8(Xs):-init8(Ys),reverse(Ys,Xs).
zabky8:- init8(I), final8(F), cesta(I,F,[],P), writeZabky(P).

%-----------------------------------------------------------------------------------------

% existuje predikat is_list(X) ktory plati, ak X je zoznam, teda [] alebo [H|T]
% atom je predikat, ktory plati pre konstanty, a, b, jozo, ...
% atomic je predikat, ktory plati pre atom alebo integer

% z prednasky
% stromova rekuzia a append
flat([X|Xs],Ys) :- flat(X,Ys1), flat(Xs,Ys2), append(Ys1, Ys2, Ys).
%flat(X, [X]) :- atomic(X), X\=[].
flat(X, [X]) :- 
flat([],[]).

%?- flat([[a],b,[],[[[c],d,[e]]]],F).
%F = [a, b, c, d, e] ;

% stromova rekuzia bez appendu 
flat1(X,Y) :- flat1(X, [], Y).
flat1([X|Xs], Ys1, Ys) :- flat1(X, Ys1, Ys2), flat1(Xs, Ys2, Ys).
%flat1(X,Ys,[X|Ys]) :- atomic(X), X\=[].
flat1(X,Ys,[X|Ys]) :- not(is_list(X)).
flat1([], Ys, Ys).

% skuste bez stromovej rekuzie a appendu
flat2([[Y|Ys]|Xs], List) :- flat2([Y|[Ys|Xs]], List).  % trik
%flat2([X|Xs], [X|List]) :- atomic(X), X\=[], flat2(Xs,List).
flat2([X|Xs], [X|List]) :- not(is_list(X)), flat2(Xs,List).
flat2([[]|Xs], Ys) :- flat2(Xs, Ys).
flat2([], []).

/*
?- flat2([[],a,[[b]],[c]],Ls).
Ls = [a, b, c] ;

?- flat2([[],a,[[b,c],d],[e,[f]]],Ls).
Ls = [a, b, c, d, e, f] ;

?- flat2([[a],b,[],[[[c],d,[e]]]],Ls).
Ls = [a, b, c, d, e] ;
*/
%------------------------------------------------- HLBKOVY REVERZ ZOZNAMU

deepReverse([X|Xs],Z) :-deepReverse(X,Y), deepReverse(Xs,Ys), append(Ys,[Y],Z).
deepReverse([],[]).
deepReverse(X,X):-atomic(X), X\=[].

% ?- deepReverse([a,[[b,d],[c,e]]],X).
%X = [[[e, c], [d, b]], a] ;

%--- bez appendu s akumulatorom

deepReverse1(X,Y) :- deepReverse(X,[],Y).

deepReverse([X|Xs],Acc,Z) :- atomic(X), deepReverse(Xs,[X|Acc],Z).
deepReverse([X|Xs],Acc,Z) :- not(atomic(X)), deepReverse1(X,Y), deepReverse(Xs,[Y|Acc],Z).
deepReverse([],Acc,Acc).

/*
% tu sa zavedie "if-then-else"....
deepReverse([X|Xs],Acc,Z) :-(atomic(X) -> Y = X ; deepReverse1(X,Y)), deepReverse(Xs,[Y|Acc],Z).
deepReverse([],Acc,Acc).
*/

%?- deepReverse1([],X).
%X = [].
%?- deepReverse1([a],X).
%X = [a].
%?- deepReverse1([a,b],X).
%X = [b, a].
%?- deepReverse1([a,b,c],X).
%X = [c, b, a].
%?- deepReverse1([a,[b],c],X).
%X = [c, [b], a].
%?- deepReverse1([a,[b,d],c],X).
%X = [c, [d, b], a].
%?- deepReverse1([a,[b,d],[c,e]],X).
%X = [[e, c], [d, b], a].
%?- deepReverse1([a,[[b,d],[c,e]]],X).
%X = [[[e, c], [d, b]], a].


%--------------------------------------------- NEDETERMINISTICKE PROGRAMIKY

% z prednasky:
myBetween(OD,DO,OD):-OD=<DO.
myBetween(OD,DO,X):-OD < DO, OD1 is OD+1, myBetween(OD1,DO,X).

% inak pouzivajte vstavany predikat between(From, To, X)

% generujme binarne cisla dlzky n (to su vlastne variacie s opakovanim dlzky N mnoziny {0,1})

bin(0,[]).
bin(N,[0|Y]):-N>0, N1 is N-1, bin(N1,Y).
bin(N,[1|Y]):-N>0, N1 is N-1, bin(N1,Y).

%vso(N, Base, V)
vso(0, _, []).    % variacia dlzky 0 z lubovolne mnoziny je []
vso(N, Base, [X|Xs]) :- N>0, N1 is N-1, member(X,Base), vso(N1, Base, Xs).

/*
setof(K, vso(3,[a,b,c,d,e], K), List), length(List,Len).
125 = 5*5*5
bagof(K, vso(3,[a,b,c,d,e], K), List), length(List,Len).
125 = 5*5*5
*/

%vbo(N, Base, V)
vbo(0, _, []).    % variacia dlzky 0 z lubovolne mnoziny je []
vbo(N, Base, [X|Xs]) :- N>0, N1 is N-1, select(X,Base, Rest), vbo(N1, Rest, Xs).

/*
setof(K, vbo(3,[a,b,c,d,e], K), List), length(List,Len).
60 = 5*4*3
bagof(K, vbo(3,[a,b,c,d,e], K), List), length(List,Len).
60 = 5*4*3
*/

podmnozina(_, []).
podmnozina([X|Xs],[X|Ys]) :- podmnozina(Xs,Ys).
podmnozina([_|Xs],Ys) :- podmnozina(Xs,Ys).

/*
setof(P, podmnozina([a,b,c],P), PowerSet), length(PowerSet,L).
8
bagof(P, podmnozina([a,b,c],P), PowerSet), length(PowerSet,L).
15 :(
*/

% niektore riesenia boli redundante....
% a uz nie su
podmnozina1([], []).
podmnozina1([X|Xs],[X|Ys]) :- podmnozina1(Xs,Ys).
podmnozina1([_|Xs],Ys) :- podmnozina1(Xs,Ys).

/*
setof(P, podmnozina1([a,b,c],P), PowerSet), length(PowerSet,L).
8
bagof(P, podmnozina1([a,b,c],P), PowerSet), length(PowerSet,L).
8 :)
*/


kbo(0, _, []).
kbo(K, [X|Xs], [X|Ys]) :- K > 0, K1 is K-1, kbo(K1, Xs, Ys).
kbo(K, [_|Xs], Ys) :- K > 0, kbo(K, Xs, Ys).

/*
n nad k, teda 5 nad 2  je 10...

bagof(K, kbo(2,[a,b,c,d,e], K), List), length(List, Len).
10

setof(K, kbo(2,[a,b,c,d,e], K), List), length(List, Len).
10
*/

kso(0, _, []).
kso(K, [X|Xs], [X|Ys]) :- K > 0, K1 is K-1, kso(K1, [X|Xs], Ys).
kso(K, [_|Xs], Ys) :- K > 0, kso(K, Xs, Ys).

/*
n+k-1 nad k = n+k-1 nad n-1 =  5+3-1 nad 3, co je 7 nad 3 =  7*6*5/6 = 35

?- bagof(K, kso(3,[a,b,c,d,e], K), List), length(List, Len).
35

?- setof(K, kso(3,[a,b,c,d,e], K), List), length(List, Len).
35
*/
%-----------------------------------------------------------------------

%-- kombinatorika (prve dve su z prednasky)

% pocet: n!
%perm(Xs,[H|Hs]):-delete(H,Xs,W),perm(W,Hs).
perm(Xs,[H|Hs]):-select(H,Xs,W),perm(W,Hs).
perm([],[]).
   
insert(X,Y,Z):-select(X,Z,Y).
perm2([],[]).
perm2([X|Xs],Zs) :- perm2(Xs,Ys),insert(X,Ys,Zs).

%- pocet: n nad k
comb_bez_opakovania([],_).
comb_bez_opakovania([X|Xs],[X|T]):-comb_bez_opakovania(Xs,T).
comb_bez_opakovania([X|Xs],[_|T]):-comb_bez_opakovania([X|Xs],T).

%- K-prvkove kombinacie bez opakovania z mnoziny M velkosti N, comb_bez_opakovania(K, M, X)
%comb_bez_opakovania(N,Mnozina,Kombinacia)

comb_bez_opakovania(0,_,[]).
comb_bez_opakovania(K,[X|T],[X|Xs]):-K>0,K1 is K-1,comb_bez_opakovania(K1,T,Xs).
comb_bez_opakovania(K,[_|T],[X|Xs]):-comb_bez_opakovania(K,T,[X|Xs]).

%==================================================

/* V cukrárni sa podávajú 4 druhy zákuskov :
vencek, veterník, laskonky a doboška. Kolkými
spôsobmi je možno kúpit 7 zákuskov */

% N-prvkove kombinacie s *opakovanim prvkov*
% u kombinacii nezalezi na poradi

% pocet: (n+k-1) nad k

%comb(N,Mnozina,Kombinacia)

comb(0,_,[]):-!.
comb(K,[X|Xs],[X|Ys]):-K1 is K-1,comb(K1,[X|Xs],Ys).
comb(K,[_|Xs],Ys):-comb(K,Xs,Ys).

/*
?- bagof(X,comb(3,[a,b,c,d],X),L),write(L).

poznamka: bagof(X,G,L) je predikat,ktory pozbiera hodnoty vyrazu X pre vsetky riesenia
ciela G do zoznamu L.

[[a,a,a],[a,a,b],[a,a,c],[a,a,d],[a,b,b],[a,b,c],[a,b,d],[a,c,c],[a,c,d],[a,d,d],[b,b,b],[b,b,c],[b,b,d],[b,c,c],[b,c,d],[b,d,d],[c,c,c],[c,c,d],[c,d,d],[d,d,d]]
*/

/*
podme riesit zakusky:
?- comb(7,[vencek,veternik,laskonka,doboska],Zak).
... 120 rieseni

alebo
?- bagof(Zak,comb(7,[vencek,veternik,laskonka,doboska],Zak),List),length(List,N).

Zak = _G664
List = [[vencek, vencek, vencek, vencek, vencek, vencek, vencek], [vencek, vencek, vencek, vencek, vencek, vencek, veternik], [vencek, vencek, vencek, vencek, vencek, vencek|...], [vencek, vencek, vencek, vencek, vencek|...], [vencek, vencek, vencek, vencek|...], [vencek, vencek, vencek|...], [vencek, vencek|...], [vencek|...], [...|...]|...]
N = 120 ;
t.j. 
N=4, k=7
4+7-1 nad 7 = 10 nad 7 = 10.9.8.7.6.5.4/7.6.5.4.3.2 = 10.3.4 = 120
n+k-1 nad k ==== n+k-1 nad n-1
*/

comb_([],[]):-!.
comb_([X|Xs],[X|Ys]):-comb_([X|Xs],Ys).
comb_([_|Xs],Ys):-comb_(Xs,Ys).

/*
?- L=[_,_,_],comb_([a,b,c,d],L).
L = [a,a,a] ;
L = [a,a,b] ;
L = [a,a,c] ;
L = [a,a,d] ;
L = [a,b,b] ;
L = [a,b,c] ;
L = [a,b,d] ;
L = [a,c,c] ;
L = [a,c,d] ;
L = [a,d,d] ;
L = [b,b,b] ;
L = [b,b,c] ;
L = [b,b,d] ;
L = [b,c,c] ;
L = [b,c,d] ;
L = [b,d,d] ;
L = [c,c,c] ;
L = [c,c,d] ;
L = [c,d,d] ;
L = [d,d,d] ;
*/

%==================================================================

% K-prvkove variacie

/*
zdroj: http://forum.matweb.cz/viewtopic.php?id=2479

Hlavny rozdiel medzi variaciami a kombinaciami je,ze pri variaciach zalezi na 
poradi,pricom pri kombinaciach nie. Permutacie su specialnym pripadom variacii.
Teda ked budeme rozpravat o pocte moznosti vytvorenia 4-ciferneho cisla _ _ _ _ 
z cislic {1,2,3,4},podme premyslat. Zalezi na poradi cislic? Urcite ano,
teda budu to variacie. Kolko mame moznosti? Na prve miesto mozme dosadit lubovolnu 
cislicu,teda moznosti je [4] _ _ _ . Dalej,ci sa cisla mozu alebo nemozu opakovat. 
Ak sa mozu,pocet moznosti bude logicky [4] [4] [4] [4] ,teda 4^4 (pocet cislic 
(mnoziny) na pocet miest,n^k). Ak sa opakovat nemozu,vysledkom bude [4] [3] [2] [1],
teda 4! ,co je v tomto pripade prave pocet permutacii bez opakovania. 
Ked je pocet cislic a miest rovny (n=k),hovorime o permutaciach a vysledkom je 
jednoducho n!. Kebyze mame na vyber cislice {1,2,3,4,5,6} ,vidime,ze celu mnozinu neminieme. 
Vysledkom bude [6] [5] [4] [3] ,teda vztah pre variacie bez opakovania nam 
vyjde n! / (n-k)!  Odtial aj vidno,ako nam vyjde vztah pre permutacie,kedy n=k.
*/

% K-prvkove variacie s opakovanim
% pocet: n^k

variacie(0,_,[]):-!.
variacie(K,Xs,[X|Ys]):-K1 is K-1,member(X,Xs),variacie(K1,Xs,Ys).


% K-prvkove variacie bez opakovania
% pocet: n.(n-1).....(n-k+1), alias n!/(n-k)!

variacie_bez_opakovania(0,_,[]).
variacie_bez_opakovania(K,Xs,[X|Ys]):-K>0, K1 is K-1, select(X,Xs,Zs),variacie_bez_opakovania(K1,Zs,Ys).

select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]):-select(X,Ys,Zs).

/*
?- L=[_,_,_],bagof(L,variacie_bez_opakovania([a,b,c,d],L),List),write(List),nl,length(List,Len),write(Len).
[[a,b,c],[a,b,d],[a,c,b],[a,c,d],[a,d,b],[a,d,c],[b,a,c],[b,a,d],[b,c,a],[b,c,d],[b,d,a],[b,d,c],[c,a,b],[c,a,d],[c,b,a],[c,b,d],[c,d,a],[c,d,b],[d,a,b],[d,a,c],[d,b,a],[d,b,c],[d,c,a],[d,c,b]]
24
*/

%----------------
% VINGT + CINQ + CINQ = TRENTE

cifra(X):-between(1,9,X).
cifra0(X):-between(0,9,X).

%- vsetky rozne
alldiff([]).
alldiff([X|Xs]):- not(member(X,Xs)),alldiff(Xs).

%- scitovanie po stlpcoch
sumCol(Prenos,Cifra1,Cifra2,Cifra3,Cifra,NovyPrenos):-
				NovyPrenos is (Cifra1+Cifra2+Cifra3+Prenos)//10,
				Cifra is (Cifra1+Cifra2+Cifra3+Prenos) mod 10.

puzzle([V,I,N,G,T,C,Q,R,E]):-
  cifra(T),cifra(Q),alldiff([T,Q]),
  sumCol(0,T,Q,Q,E,Pr1),alldiff([E,T,Q]),
  
  cifra(G),cifra(N),alldiff([G,N,E,T,Q]),
  sumCol(Pr1,G,N,N,T,Pr2),

  cifra(I),alldiff([I,G,N,E,T,Q]),
  sumCol(Pr2,N,I,I,N,Pr3),

  cifra(C),alldiff([C,I,G,N,E,T,Q]),
  sumCol(Pr3,I,C,C,E,Pr4),

  cifra(V),alldiff([V,C,I,G,N,E,T,Q]),
  sumCol(Pr4,V,0,0,R,T),

  write(' '),write(V),write(I),write(N),write(G),write(T),nl,
  write('  '),        write(C),write(I),write(N),write(Q),nl,
  write('  '),        write(C),write(I),write(N),write(Q),nl,
  write(T),write(R),write(E),write(N),write(T),write(E),nl.

/*
?- puzzle([V,I,N,G,T,C,Q,R,E]).
 94851
  6483
  6483
------
107817
*/


