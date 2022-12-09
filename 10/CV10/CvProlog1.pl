%-- a uz len prolog...

% pozrite si kniznicu lists pre swi-Prolog, kopec uzitocnych predikatov na pracu so zoznamami
% https://www.swi-prolog.org/pldoc/man?section=lists
:- use_module(library(lists)).   % toto je import library(lists)

len([],0).
len([_|Xs],N+1):-len(Xs,N).

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
cifSum(N, S) :- N > 0, NDiv10 is N//10, NMod10 is N mod 10, cifSum(NDiv10,SDiv10), S is SDiv10 + NMod10.


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



otoc(X, Y):-otoc(X,0,Y).
otoc(0, A, A).
otoc(X, A,Y):- X>0, Xd10 is X//10, AA is 10*A+(X mod 10), otoc(Xd10,AA,Y).

% presvedcte sa, ze rozdiel cisla a jeho zrkadloveho obrazu je delitelny deviatimi
lema(X):-otoc(X,Y), 0 is abs(X-Y) mod 9.

% between(From, To, X) je predikat, ktory plati, ak From <= X <= To, a zaroven vsetky take X generuje

kontrapriklad(X):-between(1,1000000,X), not(lema(X)).

%?- kontrapriklad(X).
%false.
%  ... kontrapriklad sa do miliona nenasiel, povazujte za dokazane :)

%------------------------
% Definujte vasu verziu between, nazvyte ju medzi
medzi(From, To, From):-From=<To.
medzi(From, To, X):-From<To,From1 is From+1,medzi(From1,To,X).
%----------------------------------------

%- neprázdny zoznam
neprazdnyZoznam([_|_]).
neprazdnyZoznam1(Zs):-length(Zs,Len), Len > 0.

%- aspon dvojprvkový zoznam
asponDvojPrvkovyZoznam([_,_|_]).
asponDvojPrvkovyZoznam1(Zs):-length(Zs,Len), Len >= 2.

%- tretí prvok
tretiPrvok([_,_,T|_],T).

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
prostredny(Xs,T):-append(U,[T|V],Xs), length(U,L), length(V,L).
prostredny1(Xs,T):-length(Xs,Len), LenDiv2 is Len // 2, nth0(LenDiv2,Xs,T).

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
% Definujte predikat, ktory plati, ak zoznam Zs je #a(Zs) = #b(Zs), pocet a-cok je taky ako pocet bcok
sameAB(Zs):-sameAB(Zs,0,0).
sameAB([],A,B):-A=B.
%to iste ako 
%sameAB([],A,A).
sameAB([a|Xs],A,B):-A1 is A+1,sameAB(Xs,A1,B).
sameAB([b|Xs],A,B):-B1 is B+1,sameAB(Xs,A,B1).

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
aNbM([a|Xs]):-aNbM(Xs).
aNbM([b|Xs]):-bM(Xs).
bM([b|Xs]):-bM(Xs).
bM([]).

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
aNbN([]).
aNbN([a|Xs]):-reverse(Xs,[b|XrR]),reverse(XrR,Ys),aNbN(Ys).

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

aPrime(Xs):-length(Xs,L),isPrime(L).

isPrime(N):-not(isNotPrime(N)).
isNotPrime(N):-N>2,N2 is N//2,between(2,N2,D),0 is N mod D.
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
slovoAB(N, [a|Xs]):-N>0, N1 is N-1,slovoAB(N1,Xs).
slovoAB(N, [b|Xs]):-N>0, N1 is N-1,slovoAB(N1,Xs).


% Definujte predikat slovo, ktory plati, ak zoznam je akekolvek slovo nad abecedou dlzky N.
% slovo(N, Abeceda, Xs)
slovo(0, _, []).
slovo(N, Abeceda, [Pismenko|Xs]):-N>0, member(Pismenko,Abeceda),N1 is N-1,slovo(N1,Abeceda,Xs).

% a to su variacie s opakovanim...
% ich pocet sa dozviete asi na 3.prednaske, ale takto
pocetVariacii(N,Abeceda,Pocet):-bagof(V, slovo(N,Abeceda,V),BagOfVariacii),length(BagOfVariacii,Pocet).

/*
?- pocetVariacii(3,[a,b,c],P).
P = 27.

?- pocetVariacii(4,[a,b,c],P).
P = 81.


?- string_chars("abc",Ch), length(Ch,L).
Ch = [a, b, c],
L = 3.
*/
