%---
myBetween(Od,Do,Od):-Od =< Do.
myBetween(Od,Do,X):-Od<Do,Od1 is Od+1, myBetween(Od1,Do,X).


mySqrt(N,SQRT):-between(1,N,SQRT), SQRT2 is SQRT*SQRT, SQRT2 =< N, 
			    SQRT1_2 is (SQRT+1)*(SQRT+1), SQRT1_2 > N.
%--

% index(X,Xs,I) plati aj X je I-ty prvok zoznamu Xs
index(X,[X|_],1).
index(X,[_|Ys],I):-index(X,Ys,I1),I is I1+1.

select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]):-select(X,Ys,Zs).

delete(X,Y,Z):-select(X,Y,Z).
insert(X,Y,Z):-select(X,Z,Y).    
%-----------

next(q0,a,q0).
next(q0,b,q0).
next(q0,b,q1).
next(q1,a,q2).
next(q2,b,q3).
next(q3,b,q4).
next(q4,a,q5).
next(q5,a,q5).
next(q5,b,q5).

initial(q0).
finals([q5]).

%-- akceptovanie na NKA
accept(Ws) :- initial(IS), derivation(IS,Ws).
derivation(S,[]) :- finals(Fins), member(S,Fins).
derivation(S, [W|Ws]) :- next(S,W,S1), derivation(S1,Ws).

%- generator vsetkych slov, ale zly
word([]).
word([a|Ws]):-word(Ws).
word([b|Ws]):-word(Ws).

%- generator vsetkych slov dlzky k (vlastne to su K-vso nad mnozinou symbolov, teda a,b
kword(0,[]).
kword(K,[a|Ws]):-K>0,K1 is K-1,kword(K1,Ws).
kword(K,[b|Ws]):-K>0,K1 is K-1,kword(K1,Ws).

% --- k-prvkove variacie s opakovanim, vso(K,Alphabet,Word)
vso(0,_,[]).
vso(K,Alphabet,[Symbol|Ws]):-K>0,K1 is K-1,member(Symbol, Alphabet),vso(K1,Alphabet,Ws).


language(Word) :- between(0,10,Len), vso(Len,[a,b],Word), accept(Word).
%----------------

subseq([X|Xs],[X|Ys]):-subseq(Xs,Ys).
subseq([X|Xs],[_|Ys]) :- subseq([X|Xs],Ys).
subseq([],_).

isOk(Xs):- not(subseq([0,1,2],Xs)), not(subseq([3,4,5], Xs)), not(subseq([6,7,8], Xs)),
    	   not(subseq([0,3,6], Xs)), not(subseq([1,4,7], Xs)), not(subseq([2,5,8], Xs)),
    	   not(subseq([0,4,8], Xs)), not(subseq([2,4,6], Xs)).
	
%-----------------

magicke(X):-magicke(X,0,0).

magicke([],_,_).
magicke([X|Xs],Cislo,N) :- Cislo1 is 10*Cislo+X, N1 is N+1,
				        0 is Cislo1 mod N1, 					        
				        magicke(Xs,Cislo1,N1).
				        
uplneMagicke(X) :- magicke(X), 
	member(1,X), member(2,X), member(3,X),
	member(4,X), member(5,X), member(6,X),
	member(7,X), member(8,X), member(9,X).

%%-  X=[_,_,_,_,_,_,_,_,_],member(1,X),member(2,X),member(3,X),member(4,X),member(5,X),member(6,X),member(7,X),member(8,X),member(9,X).
%% -- 
kandidat9(X) :- X=[_,_,_,_,_,_,_,_,_],member(1,X),member(2,X),member(3,X),member(4,X),member(5,X),member(6,X),member(7,X),member(8,X),member(9,X).

kandidat7(X) :- X=[_,_,_,_,_,_,_],member(1,X),member(2,X),member(3,X),member(4,X),member(5,X),member(6,X),member(7,X).

%----------------

umag(X):-cifra(C1),cifra(C2),cifra(C3),cifra(C4),cifra(C5),cifra(C6),
 		cifra(C7),cifra(C8),cifra(C9),uplneMagicke([C1,C2,C3,C4,C5,C6,C7,C8,C9]),
 		zoznamToInt2([C1,C2,C3,C4,C5,C6,C7,C8,C9],X).
 		




umagic9(X,Sol):- length(X,9) -> Sol = X %zoznamToInt2(X,Y),write(Y),nl
		;
        length(X,L), L < 9,
		cifra(C),not(member(C,X)), 
		append(X,[C],Y),magicke(Y),umagic9(Y,Sol).



	
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

perm(Xs,[H|Hs]):-delete(H,Xs,W),perm(W,Hs).
perm([],[]).
   
perm2([],[]).
perm2([X|Xs],Zs) :- perm2(Xs,Ys),insert(X,Ys,Zs).


comb([],_).
comb([X|Xs],[X|T]):-comb(Xs,T).
comb([X|Xs],[_|T]):-comb([X|Xs],T).

%-- findMM

findMM(Qs, Code) :- 
	Code1 = [_,_,_,_], 
	comb(Code1,[1,2,3,4,5,6]),
	perm(Code1,Code),
	checkMM(Qs,Code).

checkMM([],_).
checkMM([dotaz(Q,X,Y)|Qs],Code) :-
	mm(Q,Code,X,Y), checkMM(Qs,Code).
	
%--- 8 dam na sachovnici

queens:-queens(8,[]). 
queens(N,Qs):-N==0->write(Qs),nl,fail
			  ;
			  q(Q),safe(Q,Q,Q,Qs),N1 is N-1,queens(N1,[Q|Qs]).

q(X):-between(1,8,X).

queeens(SIZE, Sol):-queeens(SIZE, SIZE,[],Sol). 
queeens(SIZE, N,Qs,Sol):- N==0->Sol = Qs
			  ;
			  between(1,SIZE,Q),safe(Q,Q,Q,Qs),N1 is N-1,queeens(SIZE, N1,[Q|Qs],Sol).


betwen(I,J,I):-I =< J.
betwen(I,J,M):-I<J,I1 is I+1,betwen(I1,J,M).

safe(_,_,_,[]). 
safe(A,B,C,[Q|Qs]):-A1 is A+1,C1 is C-1,A1\=Q,B\=Q,C1\=Q,safe(A1,B,C1,Qs).

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



%---------------------------------------------------------- VINGT+CINQ+CINQ=TRENTE
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
solve :- search([1,1,1,2,2,1,1],[0,0,0,0,0,0,0], X), length(X,L), write(X), write(L), nl, fail.


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

%--------------------------------------------------------------
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



