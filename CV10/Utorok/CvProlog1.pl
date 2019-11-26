%-- a uz len prolog...

% pozrite si kniznicu lists pre swi-Prolog, kopec uzitocnych predikatov na pracu so zoznamami
% https://www.swi-prolog.org/pldoc/man?section=lists
:- use_module(library(lists)).   % toto je import library(lists)

%-------------------------------------------------- ciselne funckie
len([], 0).
len([_| Xs], N) :- len(Xs, N1), N is N1 + 1.


%- Definujte predikat cifSum(X,Y), ktory plati, ak Y je ciferny sucet cisla X, X >= 0
%cifSum(X, Y):-fail.


%?- cifSum(123,X).
%X = 6 ;
%false.
%?- cifSum(1234567,X).
%X = 28 ;
%false. 

cifSum(0, 0).
cifSum(X, Y) :- X > 0, X1 is (X // 10), cifSum(X1, Y1), Y is Y1 + (X mod 10).

otoc(X,R) :- otoc(X,0,R).

otoc(0, Acc, Acc). 
otoc(X, Acc, Res) :- X > 0, X1 is X//10, Acc1 is ((Acc * 10) + (X mod 10)), otoc(X1, Acc1,Res).

lema(X) :- otoc(X,N), 0 is ((X - N) mod 9).

medzi(From,To,From):-From =< To.
medzi(From, To, X) :- From < To, From1 is From + 1 ,medzi(From1, To, X). 

acka([]).
acka([a|Xs]) :- acka(Xs).

bcka([]).
bcka([b|Xs]) :- bcka(Xs).

aNbN(Xs) :- append(As,Bs,Xs),acka(As), bcka(Bs), length(As,N), length(Bs,N).

aNbM([]).
aNbM([b|Xs]) :- bcka(Xs).
aNbM([a|Xs]) :- aNbM(Xs).

%-------------------------------------------------- cisla, div, mod

%- Definujte predikát otoc(X,Y), ktorý platí, ak  císlo Y je zrkadlovým obrazom èísla X
%- v desiatkovej sústave. Vedúce nuly samozrejme zaniknú. 
%- Príklad, otoc(123,321), otoc(120,21),otoc(0,0)

%otoc(X, Y):-fail.

% presvedcte sa, ze rozdiel cisla a jeho zrkadloveho obrazu je delitelny deviatimi
%lema(X):-fail.

% between(From, To, X) je predikat, ktory plati, ak From <= X <= To, a zaroven vsetky take X generuje

%kontrapriklad(X):-fail.

%?- kontrapriklad(X).
%false.
%  ... kontrapriklad sa do miliona nenasiel, povazujte za dokazane :)

%----------------------------------------

%- neprázdny zoznam

%- aspon dvojprvkový zoznam

%- tretí prvok

%- posledný prvok zoznamu

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


%rozdiel(Xs,Ys,Zs):-fail.

%-----------------------------
% Definujte predikat, ktory plati, ak zoznam Zs je #a(Zs) = #b(Zs), pocet a-cok je taky ako pocet bcok
%sameAB(Zs):-fail.

/*
?- sameAB([a,a,b,a,b,b]).
true.
?- sameAB([a,a,b,a,b]).
false.
?- sameAB([a,a,b,b]).
true.
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

%-----------------------------

% Definujte predikat, ktory plati, ak zoznam je akekolvek slovo nad abecedou {a,b} dlzky N.
%slovoAB(N, Ws):-fail.


% Definujte predikat slovo, ktory plati, ak zoznam je akekolvek slovo nad abecedou dlzky N.
%slovo(N, Abeceda, Ws):-fail.

/*
?- pocetVariacii(3,[a,b,c],P).
P = 27.

?- pocetVariacii(4,[a,b,c],P).
P = 81.


?- string_chars("abc",Ch), length(Ch,L).
Ch = [a, b, c],
L = 3.
*/
