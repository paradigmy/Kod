reverse([], []).
reverse([X|Xs], Y) :- reverse(Xs, Ys), append(Ys, [X], Y).

areverse(X, Y) :- reverse(X, [], Y).
% -- najjednoduchsi sposob debugu
reverse(Xs, Ys, _) :- write('Xs='), write(Xs), write(', Ys='), write(Ys), nl, fail.
reverse([], Acc, Acc).
reverse([X | Xs], Acc, Z) :- reverse(Xs, [X | Acc], Z).

%-------------

prevod(X,Res) :- zoznamToBin(X,0,Res).

zoznamToBin([],C,Res) :- Res = C.
zoznamToBin([X|Xs],C,Res) :- C1 is 2*C+X, zoznamToBin(Xs,C1, Res).
	
%---

nAzJedna(0,[]).
nAzJedna(N,[N|X]):-N>0,N1 is N-1,nAzJedna(N1,X).


jednaAzN(N,Res):-jednaAzN(N,[],Res).
jednaAzN(0,Acc,Res):-Acc=Res.
jednaAzN(N,Acc,Res):-N>0,N1 is N-1,jednaAzN(N1,[N|Acc],Res).

%------
flat([X|Xs],Ys) :- flat(X,Ys1), flat(Xs,Ys2), append(Ys1, Ys2, Ys).
flat(X, [X]) :- atomic(X), X\=[].
flat([],[]).

flat1(X,Y) :- flat1(X, [], Y).
flat1([X|Xs], Ys1, Ys) :- flat1(X, Ys1, Ys2), flat1(Xs, Ys2, Ys).
flat1(X,Ys,[X|Ys]) :- atomic(X), X\=[].
flat1([], Ys, Ys).


%------------

wwr(X) :- append(U,V,X), reverse(U,V).

%---

subseq([X|Xs],[X|Ys]):-subseq(Xs,Ys).
subseq(Xs,[_|Ys]) :- Xs=[_|_], subseq(Xs,Ys).
%--subseq([X|Xs],[_|Ys]) :- subseq([X|Xs],Ys).
subseq([],_).

%----
sezamOtvorSa(Ys) :- subseq([s, e, z, a, m, o, t, v, o, r, s, a],Ys).

%-------

sublist1(X,Y) :- append(_,X,V),append(V,_,Y).
sublist2(X,Y) :- append(V,_,Y),append(_,X,V).

prefix([],_).
prefix([X|Xs],[X|Ys]):-prefix(Xs, Ys).

sufix(Xs,Xs).
sufix(Xs,[_|Ys]):-sufix(Xs,Ys).

%sufix(Xs,Ys):-reverse(Xs,Xs1),reverse(Ys,Ys1),prefix(Xs1,Ys1).

sublst(Xs,Ys):-prefix(W,Ys),sufix(Xs,W).
sublst2(Xs,Ys):-sufix(W,Ys),prefix(Xs,W).

sublist3(Xs,Ys):-prefix(W,Ys),sufix(Xs,W).
sublist4(Xs,Ys):-sufix(W,Ys),prefix(Xs,W).

%---

splosti([X|Xs],Ys):-splosti(X,Ys1),splosti(Xs,Ys2),append(Ys1,Ys2,Ys). 
splosti(X,[X]):-atomic(X),X \= [].
splosti([],[]).

splosti1(X,Y):-splosti1(X,[],Y).
splosti1([X|Xs],Ys1,Ys):-splosti1(X,Ys1,Ys2),splosti1(Xs,Ys2,Ys).
splosti1(X,Ys,[X|Ys]):-atomic(X),X \= [].
splosti1([],Ys,Ys).

%---

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

%----------------

umag(X):-cifra(C1),cifra(C2),cifra(C3),cifra(C4),cifra(C5),cifra(C6),
 		cifra(C7),cifra(C8),cifra(C9),uplneMagicke([C1,C2,C3,C4,C5,C6,C7,C8,C9]),
 		zoznamToInt2([C1,C2,C3,C4,C5,C6,C7,C8,C9],X).
 		

umagic9(X):- length(X,9) -> zoznamToInt2(X,Y),write(Y),nl
		;
		cifra(C),not(member(C,X)), 
		append(X,[C],Y),magicke(Y),umagic9(Y).
	
umagic7(X):- length(X,7) -> zoznamToInt2(X,Y),write(Y),nl,fail
		;
		cifra(C),not(member(C,X)), 
		append(X,[C],Y),magicke(Y),umagic7(Y).

%---
zoznamToInt([],0).
zoznamToInt([X|Xs],C) :- zoznamToInt(Xs,C1), C is 10*C1+X.

intToZoznam(0,[]).
intToZoznam(C,[X|Xs]) :- C > 0, X is C mod 10, C1 is C // 10, intToZoznam(C1,Xs).

zoznamToInt2(X,Res) :- zoznamToInt2(X,0,Res).
zoznamToInt2([],C,Res) :- Res = C.
zoznamToInt2([X|Xs],C,Res) :- C1 is 10*C+X, zoznamToInt2(Xs,C1, Res).

intToZoznam2(X,Res) :- intToZoznam2(X,[],Res).
	intToZoznam2(0,Res,Res).
	intToZoznam2(C,Xs,Res) :- C > 0, 
		X is C mod 10, C1 is C // 10, intToZoznam2(C1,[X|Xs],Res).

%------------------
s(S,E,N,D,M,O,R,Y):-
cifra0(D), 
cifra0(E),D\=E, 
Y is (D+E) mod 10, 
Y\=E,Y\=D, 
Pr1 is (D+E) // 10, 
cifra0(N),N\=D,N\=E,N\=Y, 
cifra0(R),R\=D,R\=E,R\=Y,R\=N, 
E is (N+R+Pr1) mod 10, 
Pr2 is (N+R+Pr1) // 10, 
cifra0(O), O\=D,O\=E,O\=Y,O\=N,O\=R, 
N is (E+O+Pr2) mod 10, 
Pr3 is (E+O+Pr2) // 10, 
cifra0(S), S\=D,S\=E,S\=Y,S\=N,S\=R,S\=O, 
cifra0(M), M\=0,M\=D,M\=E,M\=Y,M\=N,M\=R,M\=O,M\=S, 
O is (S+M+Pr3) mod 10, 
M is (S+M+Pr3) // 10, 
write(' '),write(S),write(E),write(N),write(D), nl, 
write('+'),write(M),write(O),write(R),write(E), nl, 
write(M),write(O),write(N),write(E),write(Y),nl. 

cifra0(0).
cifra0(X):-cifra(X). 

%---
isOk(Xs):- not(subseq([0,1,2],Xs)), not(subseq([3,4,5], Xs)), not(subseq([6,7,8], Xs)),
    	   not(subseq([0,3,6], Xs)), not(subseq([1,4,7], Xs)), not(subseq([2,5,8], Xs)),
    	   not(subseq([0,4,8], Xs)), not(subseq([2,4,6], Xs)).

%---

queens:-queens(8,[]). 
queens(N,Qs):-N==0->write(Qs),nl,fail
			  ;
			  q(Q),safe(Q,Q,Q,Qs),N1 is N-1,queens(N1,[Q|Qs]).

q(X):-between(1,8,X).

betwen(I,J,I):-I =< J.
betwen(I,J,M):-I<J,I1 is I+1,betwen(I1,J,M).

safe(_,_,_,[]). 
safe(A,B,C,[Q|Qs]):-A1 is A+1,C1 is C-1,A1\=Q,B\=Q,C1\=Q,safe(A1,B,C1,Qs).

%---

select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]):-select(X,Ys,Zs).

perm([],[]).
perm(Xs,[Z|Zs]):-select(Z,Xs,Ys),perm(Ys,Zs).

index(X,[X|_],1).
index(X,[_|Ys],I):-index(X,Ys,I1),I is I1+1.

insert(X,Y,Z):-select(X,Z,Y).
perm2([],[]).
perm2([X|Xs],Zs):-perm2(Xs,Ys),insert(X,Ys,Zs).

myBetween(Od,Do,Od):-Od =< Do.
myBetween(Od,Do,X):-Od<Do,Od1 is Od+1, myBetween(Od1,Do,X).

mySqrt(N,SQRT) :- between(1,N,SQRT), 
		SQRT2 is SQRT*SQRT, SQRT2 =< N, 
		SQRT1_2 is (SQRT+1)*(SQRT+1), SQRT1_2 > N.
%---
% dom 		1	2	3	4	5
% narod		N1	N2	N3	N4	N5
% zviera	Z1	Z2	Z3	Z4	Z5
% napoj		P1  P2	P3	P4	P5
% fajci		F1	F2	F3	F4	F5
% farba		C1	C2	C3	C4	C5

susedia(N,Z,P,F,C) :-
	N=[N1,_,_,_,_], perm([brit,sved,dan,nor,nemec],N),
	N1=nor,
	P=[_,_,P3,_,_], perm([caj,voda,pivo,kava,mlieko],P),
	P3=mlieko,
	index(dan,N,I2), index(caj,P,I2),	
	C=[_,_,_,_,_], perm([cerveny,biely,modry,zlty,zeleny],C),
	index(brit,N,I3), index(cerveny,C,I3),
	index(zeleny,C,I4), index(kava,P,I4),
	index(biely,C,I5), I5 is I4+1,	
	index(modry,C,I14), vedla(I14,1),
	Z=[_,_,_,_,_], perm([pes,macka,vtak,kon,rybicky],Z),
	index(sved,N,I1), index(pes,Z,I1),
	F=[_,_,_,_,_], perm([pallmall,dunhill,prince,blend,bluemaster],F),
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

connected(X,Y,P) :- connected(X,Y,[X],P).

connected(X,X,P,P).
connected(X,Y,Visited,P):- 
	h(X,Z), 
	not(member(Z,Visited)), 
	connected(Z,Y,[Z|Visited],P).



doit :- init(I), final(F), connected(I,F,P), write(P).

%[state(0, 0, r), state(1, 1, l), state(0, 1, r), state(0, 3, l), 
%state(0, 2, r), state(2, 2, l), state(1, 1, r), state(3, 1, l), 
%state(3, 0, r), state(3, 2, l), state(2, 2, r), state(3, 3, l)]

%-- Master Mind

countTrue([],0).
countTrue([C|Cs],N) :- countTrue(Cs,N1),
					   (C -> N is N1+1
					    ; 
					    N is N1).

mm([C1,C2,C3,C4],[Q1,Q2,Q3,Q4],X,Y) :-
    C = [C1,C2,C3,C4],
	countTrue([member(Q1,C),member(Q2,C),member(Q3,C),member(Q4,C)],X),
	countTrue([C1=Q1,C2=Q2,C3=Q3,C4=Q4],Y).

%-- kombinatorika
%-- vsetky kombinacie, to su vlastne vsetky podmnoziny mnoziny

comb([],_).
comb([X|Xs],[X|T]):-comb(Xs,T).
comb([X|Xs],[_|T]):-comb([X|Xs],T).

%-- vsetky K-prvkove kombinacie

comb(0,[],_).
comb(K,[X|Xs],[X|T]):-K1 is K-1,comb(K1,Xs,T).
comb(K,[X|Xs],[_|T]):-comb(K,[X|Xs],T).



%-- findMM

findMM(Qs, Code) :- 
	Code1 = [_,_,_,_], 
	comb(Code1,[1,2,3,4,5,6]),
	perm(Code1,Code),
	checkMM(Qs,Code).

checkMM([],_).
checkMM([dotaz(Q,X,Y)|Qs],Code) :-
	mm(Q,Code,X,Y), checkMM(Qs,Code).

cisloXX(XX) :- repeat, write('Zadaj dvociferne cislo '), read(XX),
		(XX<100,XX>9, !, write(ok) ; write(zle), nl, fail).

cisloXX1(XX) :- repeat, write('Zadaj dvociferne cislo '), read(XX),
		(XX<100,XX>9 -> write(ok) 
				; write(zle), nl, fail).

