% Jedine Mario dal explicitny vzorec...
% k rozcvicke 9, sucet clenov geometricke postupnosti:
%       S(n) = a  + a*q  + a*q^2 ... + a*q^n
%     q*S(n) = a*q+ a*q^2+ a*q^3 ... + a*q^(n+1)
%-------------------------------------------------- oditame 2.riadok od prveho
% (q-1)*S(n) =  a*q^(n+1) - a

% S(n) = a*(q^(n+1)-1) / (q-1)

% co ak a=1, q=2
% 1+2+4+8+16+31 ????
%----------------------------------------------
% a uz len prolog...

% pozrite si kniznicu lists pre swi-Prolog, kopec uzitocnych predikatov na pracu so zoznamami
% tie mozete pouzivat
% https://www.swi-prolog.org/pldoc/man?section=lists
:- use_module(library(lists)).   % toto je import library(lists)

%-------------------------------------------------------------------
%--- ak to chcete pustat v tutorials point
% :- initialization(main).
% main :- nejaky ciel....
%--------------------------------------------------------------------

% a uz vidite aj ako sa pisu komentare...

%------------------------------------------------- ciselne funckie
% priklad z prednasky, vidite standardny predikat _ is _, ktory vyhodnoti pravu stranu
% a budto priradi do lavej premennej

len([], 0).
len([_| Xs], N) :- len(Xs, N1), N is N1 + 1.

%-------------------------------------------------- cisla, div, mod

%- Definujte predikat cifSum(X,Y), ktory plati, ak Y je ciferny sucet cisla X, X >= 0
%cifSum(X, Y):-fail.
cifSum(N,N) :- N < 10.
cifSum(N,CS) :- N > 9, A = N mod 10, B = N // 10, 
                cifSum(B,CSB), CS is CSB+A.


%?- cifSum(123,X).
%X = 6 ;
%false.
%?- cifSum(1234567,X).
%X = 28 ;
%false. 


%- Definujte predikát otoc(X,Y), ktorý platí, ak  císlo Y je zrkadlovým obrazom èísla X
%- v desiatkovej sústave. Vedúce nuly samozrejme zaniknú. 
%- Príklad, otoc(123,321), otoc(120,21),otoc(0,0)


otoc(A,B) :- otoc(A, 0, B).
%otoc(0, Acc, B) :- B=Acc.
otoc(0, Acc, Acc).
otoc(A, Acc, B) :- A>0,A1 is A mod 10, A2 is A // 10, R is 10*Acc+A1,
                   otoc(A2, R, B).


% otoc(1234, 0, B) :- otoc(123, 4, B) :- otoc(12, 43, B) :- otoc(1, 432, B), otoc(0,4321, B)
% ?- otoc(123,321).
% ?- otoc(123,321).
% ?- otoc(12378,X).

% presvedcte sa, ze rozdiel cisla a jeho zrkadloveho obrazu je delitelny deviatimi
% zamyslite sa, ci a preco plati lemma
lemma(X):-otoc(X,XR), 0 is (XR-X) mod 9.

% between(From, To, X) je predikat, ktory plati, ak From <= X <= To, a zaroven vsetky take X generuje
% Definujte predikat medzi(From, To, X), ktory generuje vsetky celociselne 
% hodnoty X z uzavreteho intervalu [From;To]
% tento predikat je v standarde a vola sa between

medzi(From, To, From) :- From =< To.
medzi(From, To, X) :- From < To, From1 is From+1,
                      medzi(From1,To,X).

% overte lemmu tak, ze ju vyskusate napr, 1..100000.

kontrapriklad(X):-medzi(1,1000000,X), not(lemma(X)).


%false.
%  ... kontrapriklad sa do miliona nenasiel, povazujte za dokazane :)

% bolo na prednaske
intToZoznam(0,[]).
intToZoznam(C,[X|Xs]) :- C > 0, X is C mod 10, C1 is C // 10, intToZoznam(C1,Xs).

% --------------------------------------- symboly, slova

% definujte predikat, ktory akceptuje len slova obsahujece symbol a, teda nieco ako a^*
acka([]).
acka([a|Xs]) :- acka(Xs).

bcka([]).
bcka([b|Xs]) :- bcka(Xs).

% definujte predikat, ktory akceptuje slova a^N b^M, N a M nemusia byt rovnake...

aNbM([]).
aNbM([a|Xs]) :- aNbM(Xs).
aNbM([b|Xs]) :- bcka(Xs).

% definujte predikat, ktory akceptuje slova a^N b^N
%aNbN(Xs) :- aNbM(Xs), aux(Xs, 0).
%aux([], 0).
%aux([a|Xs], Acc) :- Acc1 is Acc+1, aux(Xs, Acc1).
%aux([b|Xs], Acc) :- Acc1 is Acc-1, aux(Xs, Acc1).

aNbN(Xs) :- append(U,V,Xs), length(U,L), length(V,L), acka(U), bcka(V).

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
% Xs \ Ys
% Xs \ Ys union Ys \ Xs.

rozdiel([],Ys,Ys).
%rozdiel(Xs,[],Xs).
rozdiel([X|Xs], Ys, Zs) :- select(X, Ys, Ws), rozdiel(Xs,Ws,Zs).
rozdiel([X|Xs], Ys, [X|Zs]) :- not(member(X, Ys)), rozdiel(Xs,Ys,Zs).


% ?- rozdiel([1,2,3],[2,3,4,5],R).
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

%vso
slovoAB(0, []).
slovoAB(N, [X|Xs]) :- N>0, (X=a; X=b), N1 is N-1, slovoAB(N1, Xs).



% Definujte predikat slovo, ktory plati, ak zoznam je akekolvek slovo nad abecedou dlzky N.
slovo(0, _Abeceda, []).
slovo(N, Abeceda, [X|Xs]) :- N>0, member(X, Abeceda), N1 is N-1, 
                             slovo(N1, Abeceda, Xs).

/*
?- pocetVariacii(3,[a,b,c],P).
P = 27.

?- pocetVariacii(4,[a,b,c],P).
P = 81.


?- string_chars("abc",Ch), length(Ch,L).
Ch = [a, b, c],
L = 3.
*/

vbo(0, _Abeceda, []).
vbo(N, Abeceda, [X|Xs]) :- N>0, select(X, Abeceda, Abeceda1), 
                                N1 is N-1, 
                                vbo(N1, Abeceda1, Xs).
          
% N = |Abaceda|, 0<=K<=N          
kbo(0, _Abeceda, []).
kbo(K, [_|Abeceda], Ws) :- K>0, kbo(K, Abeceda, Ws).
kbo(K, [X|Abeceda], [X|Ws]) :- K>0, K1 is K-1, kbo(K1, Abeceda, Ws).

%----
kso(0, _Abeceda, []).
kso(K, [_|Abeceda], Ws) :- K>0, kso(K, Abeceda, Ws).
kso(K, [X|Abeceda], [X|Ws]) :- K>0, K1 is K-1, kso(K1, [X|Abeceda], Ws).
%kso(K, [X|Abeceda], Ws) :- K>0, K1 is K-1, kso(K1, Abeceda, Ws).