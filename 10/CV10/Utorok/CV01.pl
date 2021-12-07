% pozrite si kniznicu lists pre swi-Prolog, kopec uzitocnych predikatov na pracu so zoznamami
% tie mozete pouzivat
% https://www.swi-prolog.org/pldoc/man?section=lists
:- use_module(library(lists)).   % toto je import library(lists)

myapp([],Ys,Ys).
myapp([X|Xs],Ys,[X|Zs]):-myapp(Xs,Ys,Zs).

% sucet zoznamu sucet/2
sucet([],0).
sucet([X|Xs],S) :- sucet(Xs,S1), S is S1+X.

% cifSucet(12345,15).
cifSucet(0, 0).
cifSucet(N, S) :- N>0, N10 is N//10, C10 is N mod 10, cifSucet(N10, S1), S is S1+C10.

% otoc(123456, 654321).
otoc(0,0).
otoc(X,Y) :- otoc(X, 0, Y).

% otoc(123   , 654, 654321).
otoc(0, Y, Y).
otoc(X, Acc, Y) :- X>0, X10 is X//10, C10 is X mod 10, Acc1 is 10*Acc+C10, otoc(X10, Acc1, Y).

lemma(X) :- otoc(X,XR), 0 is abs(X-XR) mod 9.

kontrapriklad(X) :- between(1,1000000, X), not(lemma(X)).

% X in [A..B]
mybetween(A,B,A) :- A=<B.
mybetween(A,B,X) :- A<B, A1 is A+1, mybetween(A1,B,X).

% to je subtract..
rozdiel(Xs, [], Xs).
rozdiel(Xs, [Y|Ys], Zs) :- not(member(Y,Xs)), rozdiel(Xs, Ys, Zs).
rozdiel(Xs, [Y|Ys], Zs) :- member(Y,Xs), delete1(Y,Xs,XsD), rozdiel(XsD, Ys, Zs).

%delete1(Y, Xs, Zs) :- select(Y,Xs,Zs).

delete1(_, [], []) .
delete1(Y, [Y|Xs], Rs) :-  delete1(Y,Xs, Rs).
delete1(Y, [X|Xs], [X|Rs]) :- not(X = Y), delete1(Y,Xs, Rs).

delete2(X,[X|Xs],Xs).
delete2(X,[Y|Ys],[Y|Zs]):-delete2(X,Ys,Zs).

%-----------------------

% [a,b,a,b]

acka([]).
acka([a|Xs]) :- acka(Xs).

bcka([]).
bcka([b|Xs]) :- bcka(Xs).

% a^n b^m
aNbM([]).
aNbM([a|Xs]) :- aNbM(Xs).
aNbM([b|Xs]) :- bcka(Xs).


% #a(w) = #b(w)

bcka1([],0).
bcka1([b|Xs],Acc) :- Acc1 is Acc-1, bcka1(Xs, Acc1).

% a^n b^n
aNbN(Xs) :- aNbN(Xs, 0).
aNbN([], 0).
aNbN([a|Xs], Acc) :- Acc1 is Acc+1, aNbN(Xs, Acc1).
aNbN([b|Xs], Acc) :- Acc1 is Acc-1, bcka1(Xs, Acc1).

slova(0,[]).
slova(N, [X|Ys]) :- N>0, N1 is N-1, slova(N1, Ys), member(X, [a,b,c]).

%slova(N, [a|Ys]) :- N>0, N1 is N-1, slova(N1, Ys).
%slova(N, [b|Ys]) :- N>0, N1 is N-1, slova(N1, Ys).


