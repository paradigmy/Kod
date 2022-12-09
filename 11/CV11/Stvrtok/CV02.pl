
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

% ------------------------

% existuje predikat is_list(X) ktory plati, ak X je zoznam, teda [] alebo [H|T]
% atom je predikat, ktory plati pre konstanty, a, b, jozo, ...
% atomic je predikat, ktory plati pre atom alebo integer

% z prednasky
% stromova rekuzia a append
flat([X|Xs],Ys) :- flat(X,Ys1), flat(Xs,Ys2), append(Ys1, Ys2, Ys).
flat(X, [X]) :- not(is_list(X)).
flat([],[]).

% [ 1 | Xs]
% flat(a, [a]).

%?- flat([[a],b,[],[[[c],d,[e]]]],F).
%F = [a, b, c, d, e] ;

% stromova rekuzia bez appendu 
flat1(X,Y) :- flat1(X, [], Y).

% flat1(X,Y,Z) = Z\\Y to su prvky nasiel X

flat1([X|Xs], Acc1, Acc) :- flat1(X, Acc1, Acc2), flat1(Xs, Acc2, Acc).
flat1(X,Ys,[X|Ys]) :- not(is_list(X)).
flat1([], Ys, Ys).





% -----------------


%   VINGT
%    CINQ
%    CINQ
% --------
%  TRENTE

% ---------------------------------
% VINGT + CINQ + CINQ = TRENTE


sum(P, C1,C2,C3, Res, Tr) :- X is C1+C2+C3+P, Res is X mod 10, Tr is X//10.
c(X) :- between(0,9,X).

solve :- select(T,[0,1,2,3,4,5,6,7,8,9,0],L1),
         select(Q,L1,L2),
         sum(0, T,Q,Q, E, Tr1), select(E,L2,L3),
         select(G,L3,L4), 
         select(N,L4,L5),
         sum(Tr1, G,N,N, T, Tr2),
         select(I,L5,L6),
         sum(Tr2, N,I,I, N, Tr3),
         select(C,L6,L7),
         sum(Tr3, I,C,C, E, Tr4),
         select(V,L7,L8),
         sum(Tr4, V,0,0, R, T), select(R,L8,_),
         write(' '), write(V), write(I), write(N), write(G), write(T), nl,
         write(' '), write(' '), write(C), write(I), write(N), write(Q), nl,
         write(' '), write(' '), write(C), write(I), write(N), write(Q), nl,
         write('--------'), nl,
         write(T), write(R), write(E), write(N), write(T), write(E), nl.
         

%  94851
%   6483
%   6483
% ------
% 107817

% orientovany graf
h(a,b).
h(b,c).
h(c,a).
h(a,c).
h(c,d).
h(d,e).
h(c,e).

cesta(X,X,Path, Path).
cesta(X,Z,Path, Res) :- h(X,Y), not(member(Y,Path)), cesta(Y,Z,[Y|Path],Res).

%?- cesta(a,e,[a],R).
%R = [e, d, c, b, a] ;
%R = [e, c, b, a] ;
%R = [e, d, c, a] ;
%R = [e, c, a] ;

init([1,1,1,0,-1,-1,-1]).
final([-1,-1,-1,0,1,1,1]).

zabky(X,X,Path, Path).
zabky(X,Z,Path, Res) :- step(X,Y), not(member(Y,Path)), zabky(Y,Z,[Y|Path],Res).

step(Xs,Ys) :- append(U,[1,0|V],Xs), append(U,[0,1|V],Ys).
step(Xs,Ys) :- append(U,[0,-1|V],Xs), append(U,[-1,0|V],Ys).
step(Xs,Ys) :- append(U,[1,-1,0|V],Xs), append(U,[0,-1,1|V],Ys).
step(Xs,Ys) :- append(U,[0,1,-1|V],Xs), append(U,[-1,1,0|V],Ys).

zabky:-init(S), final(F), zabky(S,F,[S], Sol), write(Sol), nl.

