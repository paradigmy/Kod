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

sucet([], 0).
sucet([X|Xs], C) :- sucet(Xs, C1), C is C1+X.

cifSucet(0, 0).
cifSucet(X, C) :- X>0, D10 is X//10, M10 is X mod 10, cifSucet(D10,C1), C is M10+C1.

otoc(X, Y) :- otoc(X, 0, Y).

otoc(0, Acc, Y) :- Y = Acc.
otoc(X, Acc, Y) :- X > 0, D10 is X//10, M10 is X mod 10, Acc1 is 10*Acc+M10, otoc(D10, Acc1, Y).

lemma(X) :- otoc(X, XR), 0 is (X-XR) mod 9.

% ?- between(1,1000000, X), not(lemma(X)).

acka([]).
acka([a|Xs]):-acka(Xs).

bcka([]).
bcka([b|Xs]):-bcka(Xs).

aNbM([a|Xs]):-aNbM(Xs).
aNbM([b|Xs]):-bcka(Xs).


% -- obrazy
% [-1,1,2,-2]
reduce([],[]).
reduce([X],[X]).
reduce([X,Y|Xs],R) :- X is -Y, reduce(Xs,R).
reduce([X,Y|Xs],[X|R]) :- not(X is -Y), reduce([Y|Xs],R).

reduceAll(Xs, Ys) :- reduce(Xs, XsR), not(Xs = XsR), reduceAll(XsR, Ys).
reduceAll(Xs, Xs) :- reduce(Xs, XsR), Xs = XsR.

obrazPadne(Xs) :- reduceAll(Xs, []).

odstranKlinec(_, [], []).
odstranKlinec(K, [L|Motanie], M) :- (K is L; K is -L), odstranKlinec(K, Motanie, M).
odstranKlinec(K, [L|Motanie], [L|M]) :- not(K is L), not(K is -L), odstranKlinec(K, Motanie, M).

