%-------

nAzJedna(0,[]).
nAzJedna(N,[N|X]):-N>0,N1 is N-1,nAzJedna(N1,X).

jednaAzN(N,Res):-jednaAzN(N,[],Res).
jednaAzN(0,Res,Res).
jednaAzN(N,Acc,Res):-N>0,N1 is N-1,jednaAzN(N1,[N|Acc],Res).

nTo1(0,[]):-!.
nTo1(N,[N|X]):-N1 is N-1,nTo1(N1,X).

oneToN(N,Res):-oneToN(N,[],Res).
oneToN(0,Res,Res):-!.
oneToN(N,Acc,Res):-N1 is N-1,oneToN(N1,[N|Acc],Res).

vzostupne([]).
vzostupne([_]).
vzostupne([X1,X2|Xs]):-X1=<X2,vzostupne([X2|Xs]).

parNepar([]).
parNepar([_]).
parNepar([X1,X2|Xs]):-1 is (X1+X2) mod 2,parNepar([X2|Xs]).

vzostupneParNepar([]).
vzostupneParNepar([_]).
vzostupneParNepar([X1,X2|Xs]):-X1=<X2,1 is (X1+X2) mod 2, vzostupneParNepar([X2|Xs]).


zostupne([]).
zostupne([_]).
zostupne([X1,X2|Xs]):-X1>=X2,zostupne([X2|Xs]).

usporiadany(X) :- zostupne(X) ; vzostupne([]).

%--- 8 dam na sachovnici

queens:-queens(8,[]). 
queens(N,Qs):-N==0->write(Qs),nl,fail
			  ;
			  q(Q),safe(Q,Q,Q,Qs),N1 is N-1,queens(N1,[Q|Qs]).

q(X):-between(1,8,X).

betwen(I,J,I):-I =< J.
betwen(I,J,M):-I<J,I1 is I+1,betwen(I1,J,M).

safe(_,_,_,[]). 
safe(A,B,C,[Q|Qs]):-A1 is A+1,C1 is C-1,A1\=Q,B\=Q,C1\=Q,safe(A1,B,C1,Qs).


%--

% index(X,Xs,I) plati aj X je I-ty prvok zoznamu Xs
index(X,[X|_],1).
index(X,[_|Ys],I):-index(X,Ys,I1),I is I1+1.

select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]):-select(X,Ys,Zs).

delete(X,Y,Z):-select(X,Y,Z).
insert(X,Y,Z):-select(X,Z,Y).    
			 
%--- Missionari a kanibali

check(M,K) :- (M = 0 ; K =< M),!.

check2(M,K) :- check(M,K), M1 is 3-M, K1 is 3-K, check(M1, K1).

init(state(3,3,l)).

final(state(0,0,r)).

h(state(M,K,l), state(M1, K1, r)) :- check2(M,K),
				((M>1, M1 is M-2, K1 is K);
				 (M>0, M1 is M-1, K1 is K);
				 (K>0, M1 is M, K1 is K-1);
				 (M>0, K>0, M1 is M-1, K1 is K-1); 
				 (K>1, M1 is M, K1 is K-2)),
				check2(M1,K1).

h(state(M,K,r), state(M1, K1, l)) :- 
				check2(M,K),
				((M<2, M1 is M+2, K1 is K);
				 (M<3, M1 is M+1, K1 is K);
				 (K<3, M1 is M, K1 is K+1);
				 (M<3, K<3, M1 is M+1, K1 is K+1); 
				 (K<2, M1 is M, K1 is K+2)),
				check2(M1,K1).

cesta(X,X,P,P).
cesta(X,Y,Visited,P):- 
	h(X,Z), 
	not(member(Z,Visited)), 
	cesta(Z,Y,[Z|Visited],P).

misio :- init(I), final(F), cesta(I,F,[],P), write(P).

%[state(0, 0, r), state(1, 1, l), state(0, 1, r), state(0, 3, l), 
%state(0, 2, r), state(2, 2, l), state(1, 1, r), state(3, 1, l), 
%state(3, 0, r), state(3, 2, l), state(2, 2, r), state(3, 3, l)]

%===================================================== pltnici

%--- state representation (X means 'X on left side'):
%--- [boat,father,mother,sons,daughters,policeman,criminal]

%--- next(state1, state2)
next([1,1,M,S,D,P,C], [0,0,M,S,D,P,C]).
next([1,F,1,S,D,P,C], [0,F,0,S,D,P,C]).
next([1,F,M,S,D,1,C], [0,F,M,S,D,0,C]).
next([1,1,1,S,D,P,C], [0,0,0,S,D,P,C]).
next([1,1,M,S,D,P,C], [0,0,M,SX,D,P,C]) :- between(1,2,S), succ(SX,S).
next([1,1,M,S,D,P,C], [0,0,M,S,DX,P,C]) :- between(1,2,D), succ(DX,D).
next([1,1,M,S,D,1,C], [0,0,M,S,D,0,C]).
next([1,1,M,S,D,P,1], [0,0,M,S,D,P,0]).
next([1,F,1,S,D,P,C], [0,F,0,SX,D,P,C]) :- between(1,2,S), succ(SX,S).
next([1,F,1,S,D,P,C], [0,F,0,S,DX,P,C]) :- between(1,2,D), succ(DX,D).
next([1,F,1,S,D,1,C], [0,F,0,S,D,0,C]).
next([1,F,1,S,D,P,1], [0,F,0,S,D,P,0]).
next([1,F,M,S,D,1,C], [0,F,M,SX,D,0,C]) :- between(1,2,S), succ(SX,S).
next([1,F,M,S,D,1,C], [0,F,M,S,DX,0,C]) :- between(1,2,D), succ(DX,D).
next([1,F,M,S,D,1,1], [0,F,M,S,D,0,0]).
next([0|X], [1|Y]) :- next([1|Y], [0|X]).

%--- valid(state)
valid_father([_,F,M,_,D,_,_]) :- F = M; F is 1, D is 0; F is 0, D is 2.
valid_mother([_,F,M,S,_,_,_]) :- F = M; M is 1, S is 0; M is 0, S is 2.
valid_criminal([_,F,M,S,D,P,C]) :- C = P;
    C is 1, F is 0, M is 0, S is 0, D is 0;
    C is 0, F is 1, M is 1, S is 2, D is 2.
valid(S) :- valid_father(S), valid_mother(S), valid_criminal(S).

%--- search(start, finish, path [,visited])
%--- finds a path of states from one state into another
search(S, F, P) :- search(S, F, P, [S]).
search(F, F, [F], _).
search(S, F, [S,X|T], V) :- valid(X), next(S, X), not(member(X, V)), search(X, F, [X|T], [X|V]).

%--- solve
solve :- search([1,1,1,2,2,1,1],[0,0,0,0,0,0,0], X), print(X), nl. %, fail.

%=====================================================


%---    
hanoi_init(N,Xs:[]:[]):-jednaAzN(N,Xs).
hanoi_final(N,[]:[]:Zs):-jednaAzN(N,Zs).

%hanoi_move([X|Xs]:Ys:Zs,Xs:[X|Ys]:Zs) :- vzostupne([X|Ys]).
%hanoi_move([X|Xs]:Ys:Zs,Xs:Ys:[X|Zs]) :- vzostupne([X|Zs]).
%hanoi_move(Xs:[Y|Ys]:Zs,[Y|Xs]:Ys:Zs) :- vzostupne([Y|Xs]).
%hanoi_move(Xs:[Y|Ys]:Zs,Xs:Ys:[Y|Zs]) :- vzostupne([Y|Zs]).
%hanoi_move(Xs:Ys:[Z|Zs],[Z|Xs]:Ys:Zs) :- vzostupne([Z|Xs]).
%hanoi_move(Xs:Ys:[Z|Zs],Xs:[Z|Ys]:Zs) :- vzostupne([Z|Ys]).

hanoi_move([X|Xs]:Ys:Zs,Xs:[X|Ys]:Zs) :- vzostupneParNepar([X|Ys]).
hanoi_move([X|Xs]:Ys:Zs,Xs:Ys:[X|Zs]) :- vzostupneParNepar([X|Zs]).
hanoi_move(Xs:[Y|Ys]:Zs,[Y|Xs]:Ys:Zs) :- vzostupneParNepar([Y|Xs]).
hanoi_move(Xs:[Y|Ys]:Zs,Xs:Ys:[Y|Zs]) :- vzostupneParNepar([Y|Zs]).
hanoi_move(Xs:Ys:[Z|Zs],[Z|Xs]:Ys:Zs) :- vzostupneParNepar([Z|Xs]).
hanoi_move(Xs:Ys:[Z|Zs],Xs:[Z|Ys]:Zs) :- vzostupneParNepar([Z|Ys]).

connected(X,Y,P) :- connected(X,Y,[X],P).

connected(X,X,P,P).
connected(X,Y,Visited,P):- 
	hanoi_move(X,Z), 
	not(member(Z,Visited)), 
	connected(Z,Y,[Z|Visited],P).

doit(N,Len) :- hanoi_init(N,I), hanoi_final(N,F), connected(I,F,P), 
	length(P,Len),
	write(P),nl,
	write(Len),nl,fail.


%-- kombinatorika

perm(Xs,[H|Hs]):-delete(H,Xs,W),perm(W,Hs).
perm([],[]).
   
perm2([],[]).
perm2([X|Xs],Zs) :- perm2(Xs,Ys),insert(X,Ys,Zs).


comb([],_).
comb([X|Xs],[X|T]):-comb(Xs,T).
comb([X|Xs],[_|T]):-comb([X|Xs],T).


hmove(1,X,Y,_) :-  
    write('Move top disk from '), 
    write(X), 
    write(' to '), 
    write(Y), 
    nl. 
hmove(N,X,Y,Z) :- 
    N>1, 
    N1 is N-1, 
    hmove(N1,X,Z,Y), 
    hmove(1,X,Y,_), 
    hmove(N1,Z,Y,X). 	

%---

%---
% dom 		1	2	3	4	5
% narod		N1	N2	N3	N4	N5
% zviera	Z1	Z2	Z3	Z4	Z5
% napoj		P1  P2	P3	P4	P5
% fajci		F1	F2	F3	F4	F5
% farba		C1	C2	C3	C4	C5

susedia(N,Z,P,F,C) :-
	N=[N1,N2,N3,N4,N5], perm([brit,sved,dan,nor,nemec],N),
	N1=nor,
	P=[P1,P2,P3,P4,P5], perm([caj,voda,pivo,kava,mlieko],P),
	P3=mlieko,
	index(dan,N,I2), index(caj,P,I2),	
	C=[C1,C2,C3,C4,C5], perm([cerveny,biely,modry,zlty,zeleny],C),
	index(brit,N,I3), index(cerveny,C,I3),
	index(zeleny,C,I4), index(kava,P,I4),
	index(biely,C,I5), I5 is I4+1,	
	index(modry,C,I14), vedla(I14,1),
	Z=[Z1,Z2,Z3,Z4,Z5], perm([pes,macka,vtak,kon,rybicky],Z),
	index(sved,N,I1), index(pes,Z,I1),
	F=[F1,F2,F3,F4,F5], perm([pallmall,dunhill,prince,blend,bluemaster],F),
	index(nemec,N,I6), index(prince,F,I6),
	index(bluemaster,F,I7), index(pivo,P,I7),
	index(zlty,C,I8), index(dunhill,F,I8),
	index(pallmall,F,I9), index(vtak,Z,I9),
	index(blend,F,I10), index(macka,Z,I11), vedla(I10,I11),
	index(kon,Z,I12), index(dunhill,F,I13), vedla(I12,I13),
	index(blend,F,I15), index(voda,P,I16),vedla(I15,I16).
%	write('riesenie='),
%	write(N),	
%	write(Z),	
%	write(P),	
%	write(F),	
%	write(C).
	
vedla(I,J) :- I is J+1 ; J is I+1.



% bluff([dotaz([1,2,3,4],3,1),dotaz([3,2,1,5],2,0)], dotaz([4,1,5,6],X,Y),N).

bluff(Qs,dotaz(C,X,Y),Size):- 
	between(2,4,X),between(0,X,Y),
	setof(Code,findMM([dotaz(C,X,Y)|Qs],Code),Set),
	length(Set,Size).	
	
% best_bluffs([dotaz([1,2,3,4],3,1),dotaz([3,2,1,5],2,0)], [4,1,5,6],B).	
	
best_bluff(Qs,C,BestBluff) :- 
	setof((Size,X:Y),bluff(Qs,dotaz(C,X,Y),Size),List),
	findMax((0,0:0),List,BestBluff).
	
findMax(B,[],B).
findMax((Max,X:Y),[(S,_:_)|Xs],B):-Max>S, findMax((Max,X:Y),Xs,B).
findMax((Max,_:_),[(S,X1:Y1)|Xs],B):-Max=<S,findMax((S,X1:Y1),Xs,B).

%---

hrana(a,b).
hrana(c,b).
hrana(c,a).
hrana(c,d).


most(X,Y) :- hrana(X,Y) ; hrana(Y,X).
%most(X,Y) :- hrana(X,Y).

cest(X,X,P,P).
cest(X,Y,Visited,P):- 
	most(X,Z),
	not(member(Z,Visited)), 
	cest(Z,Y,[Z|Visited],P).

susedia(X,Zs) :- setof(Y,most(X,Y),Zs).
graph(G) :- setof((X,Xs),susedia(X,Xs),G).

suvislyKomp(X,Comp):- setof(Y,Path^cest(X,Y,[],Path),Comp).

stupenVrchola(X,N) :- susedia(X, Zs), length(Zs,N).

% - bagof

jednaAzNN(N,List) :- bagof(X,between(1,N,X),List).

allCombinations(List) :- setof(C,comb(C,[1,2,3,4,5]),List).

cestadoSirky(X,Y) :- cestaDoSirky([X],[],Y).
cestaDoSirky([Y|_],_,Y).
cestaDoSirky([X|Xs],Navstivene,Y):-X\=Y,
	setof(Z,(hrana(X,Z), not(member(Z,Navstivene))),Nasledovnici),
	%append(Nasledovnici,Xs,Xs1),
	append(Xs,Nasledovnici,Xs1),
	cestaDoSirky(Xs1,[X|Navstivene],Y).


%--- jednotazky

neohr(1,2).
neohr(1,3).
neohr(1,4).
neohr(1,5).

neohr(2,3).
neohr(2,4).

neohr(3,4).
neohr(3,5).

hrany(Hrany) :- setof((X,Y), neohr(X,Y),Hrany).

jednotazka(X,Res) :- hrany(Hrany), jednotazka(X,Hrany,[X],Res).

jednotazka(_,[],C,Res):-Res = C.
jednotazka(X,Hrany,C,Res):-
		(delete((X,Y),Hrany,Hrany1) ; delete((Y,X),Hrany,Hrany1)),
		jednotazka(Y,Hrany1,[Y|C],Res).

% jednotazka(X,Y,Path) :- pocetHran(PH), cesta(X,Y,[],Path), length(Path,PH).

%-- farbenie grafu

mapa(
  [susedia(portugal,Portugal,[Spain]),
   susedia(spain,Spain,[France,Portugal]),
   susedia(france,France,[Spain,Italy,Switzerland,Belgium,Germany,Luxemburg]),
   susedia(belgium,Belgium,[France,Holland,Luxemburg,Germany]),
   susedia(holland,Holland,[Belgium,Germany]),
   susedia(germany,Germany,[France,Austria,Switzerland,Holland,Belgium,Luxemburg]),
   susedia(luxemburg,Luxemburg,[France,Belgium,Germany]),
   susedia(italy,Italy,[France,Austria,Switzerland]),
   susedia(switzerland,Switzerland,[France,Austria,Germany,Italy]),
   susedia(austria,Austria,[Italy,Switzerland,Germany])
  ]).

colors([green,red,blue,yellow]).

members([],_).
members([X|Xs],Ys):-member(X,Ys), members(Xs,Ys).

colorMap([],_).
colorMap([susedia(_,Color,Neighbors)|Xs],Colors) :-
	delete(Color,Colors,Colors1),
	members(Neighbors,Colors1),
	colorMap(Xs,Colors).

colorit :- mapa(M), colors(Cols), colorMap(M,Cols), write(M),nl.

%-- Bill Clementson's code. 
%- http://sandbox.rulemaker.net/ngps/119

next_to(X, Y, List) :- iright(X, Y, List).
next_to(X, Y, List) :- iright(Y, X, List).

iright(L, R, [L | [R | _]]).
iright(L, R, [_ | Rest]) :- iright(L, R, Rest).

einstein(Houses, Fish_Owner) :-
  Houses = [[ norwegian, _, _, _, _], _, [ _, _, _, milk, _], _, _],
  member([ brit, _, _, _, red], Houses),
  member([ swede, dog, _, _, _], Houses),
  member([ dane, _, _, tea, _], Houses),
  iright([ _, _, _, _, green], [ _, _, _, _, white], Houses),
  member([ _, _, _, coffee, green], Houses),
  member([ _, bird, pallmall, _, _], Houses),
  member([ _, _, dunhill, _, yellow], Houses),
  next_to([ _, _, dunhill, _, _], [ _, horse, _, _, _], Houses),
  member([ _, _, _, milk, _], Houses),
  next_to([ _, _, marlboro, _, _], [ _, cat, _, _, _], Houses),
  next_to([ _, _, marlboro, _, _], [ _, _, _, water, _], Houses),
  member([ _, _, winfield, beer, _], Houses),
  member([ german, _, rothmans, _, _], Houses),
  next_to([ norwegian, _, _, _, _], [ _, _, _, _, blue], Houses),
  member([ Fish_Owner, fish, _, _, _], Houses).



/* --------------------------- HRY
zoberme si nejaku jednoduchu NIM-like hru, napr: jednokopovy NIM,
Pravidla:
 - hrac berie 1,2 alebo 3 zapalky,
 - vyhrava ten, kto berie poslednu zapalku

a naprogramujme predikaty vitaznaPozicia1NIM, prehravajucaPozicia1NIM a spravnyTah1NIM

*/
vitaznaPozicia1NIM(N):-N>0, N<4, !.
vitaznaPozicia1NIM(N):-tah1NIM(N,N1),			% existuje nejaky spravny tah z N do N1,
			prehravajucaPozicia1NIM(N1).	% ze nova konfiguracia N1 je prehravajuca

tah1NIM(N,N1):-between(1,3,Tah), Tah=<N, N1 is N-Tah.	% existuje korektny nejaky Tah

prehravajucaPozicia1NIM(0):-!.
prehravajucaPozicia1NIM(N):-bagof(vitaznaPozicia1NIM(N1), tah1NIM(N,N1), All),
							% pre lubovony tah, nova konfiguracia je vitazna
			forall(All).

% plati pre vsetky podciele v zozname
forall(G):-write(G),nl, fail.
forall([]).
forall([G|Gs]):-G,forall(Gs).

spravnyTah1NIM(N):-tah1NIM(N,N1), prehravajucaPozicia1NIM(N1),
		write('nechaj ='), write(N1),nl.

/*
co vie uz aj ziacik na zakladke, ze zle pozicie su tvaru 3*x+1 a vitazna strategia je:
ak super zoberie t zapaliek, ja beriem 4-t, ak som vo vitaznej pozicii,
ak som v prehravajucej pozicii, je to fuk, takze beriem co najmenej (sanca ze sa super pomyli).

*/

%======================================================

/*
- skusme nieco zlozitejsie: 3-kopovy NIM
pravidla (http://en.wikipedia.org/wiki/Nim):
- hrac berie z lubovolnej kopy (ale len jednej) lub.pocet zapaliek
- vyhrava ten, kto berie poslednu (t.j. prehrava, ten co uz nema co brat).

definujme predikaty: vitaznaPozicia3NIM, prehravajucaPozicia3NIM a spravnyTah3NIM
*/

% - toto je zavisle na hre
tah3NIM([A,B,C],[A1,B,C]):-X is A-1, between(0,X,A1).
tah3NIM([A,B,C],[A,B1,C]):-X is B-1, between(0,X,B1).
tah3NIM([A,B,C],[A,B,C1]):-X is C-1, between(0,X,C1).

/*
technika tabeliazacie:

ak mam dokazat P, je moze, ze som to uz pocital, a potom som si to ulozil do databazy faktov, alebo
to teda musim spocitat, ale potom si to ulozim do databazy faktov
*/

lemma(P):-write('zistujem '), write(P), nl, fail.

%lemma(P):-P.
lemma(P):-(clause(P,true),write('nasiel '), write(P), nl, !)
		;
	  (   P,write('dokazal '), write(P), nl, assertz(P:-true)).

:-dynamic
     vitaznaPozicia3NIM/1.

vitaznaPozicia3NIM([A,0,0]):-A>0.
vitaznaPozicia3NIM([0,B,0]):-B>0.
vitaznaPozicia3NIM([0,0,C]):-C>0.


%- toto je nezavisle na hre
vitaznaPozicia3NIM(N):-tah3NIM(N,N1),			% existuje nejaky spravny tah z N do N1,
			lemma(prehravajucaPozicia3NIM(N1)).	% ze nova konfiguracia N1 je prehravajuca

:-dynamic
     prehravajucaPozicia3NIM/1.

prehravajucaPozicia3NIM([0,0,0]).
prehravajucaPozicia3NIM(N):-bagof(lemma(vitaznaPozicia3NIM(N1)), tah3NIM(N,N1), All),
							% pre lubovony tah, nova konfiguracia je vitazna
			forall(All).

spravnyTah3NIM(N):-tah3NIM(N,N1), lemma(prehravajucaPozicia3NIM(N1)),
		write('nechaj ='), write(N1),nl.



