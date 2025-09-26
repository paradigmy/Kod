%-- a uz len prolog...

% pozrite si kniznicu lists pre swi-Prolog, kopec uzitocnych predikatov na pracu so zoznamami
% https://www.swi-prolog.org/pldoc/man?section=lists
:- use_module(library(lists)).   % toto je import library(lists)

len([],0).
len([_|Xs],Q):-len(Xs,N), Q is N+1.

/*
?- len([1,2,3],3).
false.

?- len([1,2,3],0+1+1+1).
true.

?- len([1,2,3],N),N = 3.
false.
?- len([1,2,3],N),N == 3.
false.
?- len([1,2,3],N),N =:= 3.
N = 0+1+1+1.

?- 1+3 =:= 2+2.

?- len([1,2,3],N),N > 2, N < 4.
N = 0+1+1+1.
?- len([1,2,3],N),3 is N.
N = 0+1+1+1.
*/

%-------------------------------------------------- ciselne funckie

%- Definujte predikat cifSum(X,Y), ktory plati, ak Y je ciferny sucet cisla X, X >= 0
cifSum(0, 0).
cifSum(N, S) :- N>0, C is N mod 10, D is N //10, cifSum(D,S1), S is S1+C.


%?- cifSum(123,X).
%X = 6 ;
%false.
%?- cifSum(1234567,X).
%X = 28 ;
%false.

%-------------------------------------------------- cisla, div, mod

%- Definujte predikát otoc(X,Y), ktorý platí, ak  císlo Y je zrkadlovým obrazom èísla X
%- v desiatkovej sústave. Vedúce nuly samozrejme zaniknú. 
%- Príklad, otoc(123,321), otoc(120,21),otoc(0,0)

% X=123, D=3, Zv = 12, Q = 21

otoc(X, Y) :- otoc(X, 0, Y).
otoc(0, C, C).
otoc(X, C, Y) :- X > 0, D is X mod 10, X10 is X //10, C1 is 10*C + D, otoc(X10, C1, Y).



%otoc(X,Z) :- intToZoznam(X,Y), reverse(Y,YY),zoznamToInt(YY,Z).
%otoc(X, Y) :- X >= 10, D is X mod 10, Zv is X //10, otoc(Zv, Q),  Y = D*10^ocet Q+

intToZoznam(0,[]).
intToZoznam(N,X) :- N > 0, D is N mod 10, Zv is N //10, intToZoznam(Zv, Q), X = [D|Q].

zoznamToInt([], 0).
zoznamToInt([C|X], N) :- zoznamToInt(X,N1), N is 10*N1+C.


% presvedcte sa, ze rozdiel cisla a jeho zrkadloveho obrazu je delitelny deviatimi
lema(X):-otoc(X,Y), 0 is abs(X-Y) mod 9.

% between(From, To, X) je predikat, ktory plati, ak From <= X <= To, a zaroven vsetky take X generuje

%kontrapriklad(X):- ...

%?- kontrapriklad(X).
%false.
%  ... kontrapriklad sa do miliona nenasiel, povazujte za dokazane :)

%------------------------
% Definujte vasu verziu between, nazvite ju medzi
medzi(From, To, From) :- From =< To.
medzi(From, To, X) :- From < To, From1 is From+1, medzi(From1, To, X).

%----------------------------------------

%- neprázdny zoznam
neprazdnyZoznam([_|_]).
neprazdnyZoznam1(Zs):-length(Zs,Len), Len > 0.

%- aspon dvojprvkový zoznam
asponDvojPrvkovyZoznam([_,_|_]).
asponDvojPrvkovyZoznam1(Zs):-length(Zs,Len), Len >= 2.

%- tretí prvok
tretiPrvok([_,_,T|_],T).
tretiPrvok1(X,T) :- nth1(3,X,T).


%- posledný prvok zoznamu
posledny([X],X).
posledny([_,Y|Ys],X):-posledny([Y|Ys],X).

posledny1(Xs,X):-reverse(Xs,[X|_]).

posledny2(Xs,X):-length(Xs,Len),nth1(Len,Xs,X).

/*
?- numlist(1,10,List),posledny(List,X).
List = [1, 2, 3, 4, 5, 6, 7, 8, 9|...],
X = 10 ;
false.

?- numlist(1,10,List),posledny1(List,X).
List = [1, 2, 3, 4, 5, 6, 7, 8, 9|...],
X = 10.

?- numlist(1,10,List),posledny2(List,X).
List = [1, 2, 3, 4, 5, 6, 7, 8, 9|...],
X = 10.
*/

%- tretí od konca
tretiOdKonca(Xs,T) :- reverse(Xs,Ys),tretiPrvok(Ys,T).

%- prostredný prvok zoznamu, ak existuje
%prostredny([T],T).
%prostredny([_|Xs],T) :- reverse(Xs, [_|Zs]), prostredny(Zs,T).

%prostredny(X,T) :- length(X, Len), Len2 is Len//2, nth0(Len2, X, T).
prostredny(X,T) :- append(U,[T|V],X), length(U, Ul), length(V, Ul).

/*
?- numlist(1,10,List),prostredny(List,T).
false.

?- numlist(1,10,List),prostredny1(List,T).
List = [1, 2, 3, 4, 5, 6, 7, 8, 9|...],
T = 6.

?- numlist(1,11,List),prostredny1(List,T).
List = [1, 2, 3, 4, 5, 6, 7, 8, 9|...],
T = 6.

?- numlist(1,11,List),prostredny(List,T).
List = [1, 2, 3, 4, 5, 6, 7, 8, 9|...],
T = 6 .
*/

%- rozdiel mnozin (prvky sa v zoznamoch nachadzaju najviac jedenkrat)

rozdiel([],_,[]).
rozdiel(XS,[],XS).
rozdiel(XS,[Y|YS],[Y|ZS]):-not(member(Y,XS)),rozdiel(XS,YS,ZS).
rozdiel(XS,[Y|YS],ZS):-member(Y,XS),deleteElem(Y,XS,X2S),rozdiel(X2S,YS,ZS).
deleteElem(_,[],[]).
deleteElem(X,[X|XS],XS).
deleteElem(X,[Y|XS],[Y|ZS]):-X\=Y,deleteElem(X,XS,ZS).

%- ine riesenie...

rozdiel2([],_,[]).
rozdiel2(XS,[],XS).
rozdiel2([X|XS],YS,ZS):-member(X,YS),rozdiel2(XS,YS,ZS).
rozdiel2([X|XS],YS,[X|ZS]):-not(member(X,YS)),rozdiel2(XS,YS,ZS).

%-----------------------------
% Definujte predikat, ktory plati, ak zoznam Zs je #a(Zs) = #b(Zs), pocet a-cok je taky ako pocet b-cok
%sameAB(Zs):-

/*
?- sameAB([a,a,b,a,b,b]).
true.
?- sameAB([a,a,b,a,b]).
false.
?- sameAB([a,a,b,b]).
true.


?-string_codes("abba",L),same(L).
*/
%-----------------------------


% Definujte predikat, ktory plati, ak zoznam je tvaru a^n b^m
%aNbM([a|Xs]):-

%?- bM([b,b,b,b]).
%true.
%?- bM([b,b,a,b]).
%false.
%?- aNbM([a,b,b,a,b]).
%false.
%?- aNbM([a,b,b,b]).
%true.

%-----------------------------

% Definujte predikat, ktory plati, ak zoznam je tvaru a^n b^n
%aNbN([]) :-

%?- aNbN([a,a,b,b]).
%true.
%?- aNbN([a,a,b,b,a]).
%false.
%?- aNbN([a,a,b,b,b]).
%false.
%?- aNbN([a,a,b]).
%false.

%?- aNbN([a,a,b,b]).
%true.
%?- aNbN([a,a,b,b,a]).
%false.
%?- aNbN([a,a,b,b,b]).
%false.
%?- aNbN([a,a,b]).
%false.

%-----------------------------
% Definute jazyk a^prime, pocet acok je prvocislo

%aPrime(Xs):-...

/*
?- between(2,100,N),isPrime(N),write(N),nl,fail.
2
3
5
7
11
13
17
19
23
29
31
37
41
43
47
53
59
61
67
71
73
79
83
89
97
*/

%-----------------------------

% Definujte predikat, ktory plati, ak zoznam je akekolvek slovo nad abecedou {a,b} dlzky N.
slovoAB(0, []).
slovoAB(N, [P|W]) :- N > 0, N1 is N-1, slovoAB(N1, W), member(P, [a,b,c,d]).


%slovo(2, [a,a]).

% Definujte predikat slovo, ktory plati, ak zoznam je akekolvek slovo nad abecedou dlzky N.
% slovo(N, Abeceda, Xs)

% a to su variacie s opakovanim...
% ich pocet sa dozviete asi na 3.prednaske, ale takto
%pocetVariacii(N,Abeceda,Pocet):-bagof(V, slovo(N,Abeceda,V),BagOfVariacii),length(BagOfVariacii,Pocet).

/*
?- pocetVariacii(3,[a,b,c],P).
P = 27.

?- pocetVariacii(4,[a,b,c],P).
P = 81.


?- string_chars("abc",Ch), length(Ch,L).
Ch = [a, b, c],
L = 3.
*/
