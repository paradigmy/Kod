
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

flat2([[H1|T1]|T],Res):-flat2([H1|[T1|T]],Res).
flat2([X|T],[X|Res]):-not(is_list(X)),flat2(T,Res).
flat2([[]|T],Res):-flat2(T,Res).
flat2(X,[X]):-not(is_list(X)).
flat2([],[]).





% -----------------


%   VINGT
%    CINQ
%    CINQ
% --------
%  TRENTE

% ---------------------------------
% VINGT + CINQ + CINQ = TRENTE

c(X) :- between(0,9,X).
sum(Be,C1,C2,C3,R,Af):- X is C1+C2+C3+Be, R is X mod 10, Af is X//10.

solve :- select(T,[0,1,2,3,4,5,6,7,8,9],R1), select(Q,R1,R2), sum(0,T,Q,Q,E,Af1), select(E,R2,R3), 
         select(G,R3,R4), select(N,R4,R5), sum(Af1,G,N,N,T,Af2), 
         select(I,R5,R6), sum(Af2,N,I,I,N,Af3),
         select(C,R6,R7), sum(Af3,I,C,C,E,Af4),
         select(V,R7,R8), sum(Af4,V,0,0,R,T), select(R,R8,_),        
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
% h(a,b).
% h(b,c).
% h(c,a).
% h(a,c).
% h(c,d).
% h(d,e).
% h(c,e).

cesta(X,X,Path,Path).
cesta(X,Y,Path,Res):-h(X,Z), not(member(Z,Path)), cesta(Z,Y,[Z|Path],Res).

%?- cesta(a,e,[a],R).
%R = [e, d, c, b, a] ;
%R = [e, c, b, a] ;
%R = [e, d, c, a] ;
%R = [e, c, a] ;


zabky:-init(S), final(F), cesta(S,F,[S], Sol), write(Sol), nl.

init([r,r,r,e,l,l,l]).
final([l,l,l,e,r,r,r]).

h(C1,C2):-append(U,[r,e|V],C1), append(U,[e,r|V],C2).
h(C1,C2):-append(U,[e,l|V],C1), append(U,[l,e|V],C2).
h(C1,C2):-append(U,[r,X,e|V],C1), append(U,[e,X,r|V],C2).
h(C1,C2):-append(U,[e,X,l|V],C1), append(U,[l,X,e|V],C2).








