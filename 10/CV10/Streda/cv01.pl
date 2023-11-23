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
cifSum(0,0).
cifSum(X,Y) :- X>0, Z is X//10, cifSum(Z,R), Y is R+X mod 10.

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

otoc(X,X) :- X<10.
otoc(X,Y) :- X>=10,otoc(X,0,Y).

otoc(0,Acc,Acc).
otoc(X,Acc,Y) :- X>0, Last is X mod 10, X10 is X//10, Acc1 is 10*Acc+Last, otoc(X10,Acc1,Y).  

% presvedcte sa, ze rozdiel cisla a jeho zrkadloveho obrazu je delitelny deviatimi

lemma(X):-otoc(X,Y), 0 is abs(X-Y) mod 9.

% between(From, To, X) je predikat, ktory plati, ak From <= X <= To, a zaroven vsetky take X generuje


%?- kontrapriklad(X).
%false.
%  ... kontrapriklad sa do miliona nenasiel, povazujte za dokazane :)

%------------------------
% Definujte vasu verziu between, nazvyte ju medzi

medzi(A,B,A) :- A=<B. 
medzi(A,B,X) :- A=<B, A1 is A+1, medzi(A1,B,X).
%----------------------------------------

%- neprázdny zoznam

neprazdny([_|_]).

%- aspon dvojprvkový zoznam

aspon2p([_,_|_]).

%- tretí prvok

%- posledný prvok zoznamu

prvy([R|_],R).
%posledny(Z,P) :- reverse(Z,Y), prvy(Y,P).
posledny(Z,P) :- reverse(Z,Y), Y=[P|_].

poslednyK([L],L).
poslednyK([_|T],L) :- poslednyK(T,L).

middle(Z,P) :- length(Z,N), N1 is N//2, nth0(N1, Z, P).

middleP(Z,P):-append(X,[P|Y],Z),length(X,N), length(Y,N).

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

%- prostredný prvok zoznamu, ak existuje

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

%- ine riesenie...


%-----------------------------
% Definujte predikat, ktory plati, ak zoznam Zs je #a(Zs) = #b(Zs), pocet a-cok je taky ako pocet bcok
%to iste ako 
%sameAB([],A,A).

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

% Definujte predikat slovo, ktory plati, ak zoznam je akekolvek slovo nad abecedou dlzky N.
% slovo(N, Abeceda, Xs)

% a to su variacie s opakovanim...
% ich pocet sa dozviete asi na 3.prednaske, ale takto

/*
?- pocetVariacii(3,[a,b,c],P).
P = 27.

?- pocetVariacii(4,[a,b,c],P).
P = 81.


?- string_chars("abc",Ch), length(Ch,L).
Ch = [a, b, c],
L = 3.
*/
