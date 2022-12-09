% Pyramidy v Midterme
% SO

:- use_module(library(lists)).   % toto je import library(lists)

% rozcvicka

% obsahuju dve nuly po sebe
obsahuje00([0,0|_]).
obsahuje00([_|Xs]) :- obsahuje00(Xs).

%?- obsahuje00([1,2,0,0,1,2]).

% neobsahuju dve nuly po sebe
bez00(Xs) :- not(obsahuje00(Xs)).

%?- bez00([1,2,0,2,0,1,2]).
% ---------------
druhyNajvacsi(Xs, M2) :- max_member(M1, Xs),
                        select(M1, Xs, Ys),
                        max_member(M2, Ys).

% ?- druhyNajvacsi([1,2,3,4], DN).


%% --------------------------------------------------------------------------

% pocet a-cok v z zoznam, ktore je spravne riesenie
pocetA([],0).
pocetA([a|Xs],N) :- N1 is N-1, pocetA(Xs,N1).

% cele zle....
countA([],0).
countA([a|Xs],N) :- N1 is N+1, countA(Xs,N1).

% cele zle
schitat([],0).
schitat([a|Xs],N) :- schitat(Xs,N1), N1 is N+1.

combien([],0).
combien([a|Xs],N) :- combien(Xs,N1), N is N1+1.

%% ----------------------------------------------------------------------------

% zovseobecnenie, geralizacia, countX rata pismenka X
countX(_,[], 0).
% countX(X,[Y|Xs], N):- X==Y, countX(X,Xs,N1), N is N1+1.
% countX(X,[Y|Xs], N):- not(X=Y), countX(X,Xs,N).

% X /= Y

% takto sa pise if-then-else
countX(X,[Y|Xs], N):- X==Y -> (countX(X,Xs,N1), N is N1+1) ; countX(X,Xs,N).

% if C then T else E sa pise C -> T ; E
/*
?- countX(a,[a,b,b,a],X).
X = 2 ;
false.
*/

%% --------------------------------------------------------------------------

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

flat2([[Y|Ys]|Xs], List) :- flat2([Y|[Ys|Xs]], List).
flat2([X|Xs], [X|List]) :- not(is_list(X)), flat2(Xs,List).
flat2([[]|Xs], Ys) :- flat2(Xs, Ys).
flat2([], []).



% ---------------------------------
% VINGT + CINQ + CINQ = TRENTE


c(X) :- between(0,9,X).

sum(X, C1, C2, C3, R, Y) :- Res is X+C1+C2+C3,
                            R is Res mod 10,
                            Y is Res // 10.

allDiff([]).
allDiff([X|Xs]) :- not(member(X,Xs)), allDiff(Xs).

solve(V,I,N,G,T,C,Q,R,E) :-
        c(T), c(Q), sum(0, T,Q,Q, E, Pr1),
        allDiff([T, Q, E]),
        c(G), c(N), sum(Pr1, G,N,N, T, Pr2),
        allDiff([T, Q, E, G, N]),        
        c(I), sum(Pr2, N,I,I, N, Pr3),
        allDiff([T, Q, E, G, N, I]),
        c(C), C \= 0, sum(Pr3, I, C,C, E, Pr4),
        allDiff([T, Q, E, G, N, I, C]),
        c(V), V \=0, sum(Pr4, V,0,0, R, Pr5),
        allDiff([T, Q, E,   G, N, I,   R, C, V]),
        T = Pr5, T \= 0.

%   VINGT  
%    CINQ
%    CINQ
% --------
%  TRENTE
        
solve1(V,I,N,G,T,C,Q,R,E) :-
        select(T, [0,1,2,3,4,5,6,7,8,9], Z1),
        select(Q, Z1, Z2),
        sum(0, T,Q,Q, E, Pr1),
        select(E, Z2, Z3),
        
        select(G, Z3, Z4),
        select(N, Z4, Z5),
        sum(Pr1, G,N,N, T, Pr2),
        
        select(I,Z5,Z6),
        sum(Pr2, N,I,I, N, Pr3),
        
        select(C,Z6,Z7),
        sum(Pr3, I, C,C, E, Pr4),
        
        select(V,Z7,Z8),
        sum(Pr4, V,0,0, R, Pr5),
        T = Pr5,
        select(R, Z8, _),
        V \=0, T\=0, C\=0.
        
% -- LES * LES = PRALES        


%-------------------------------------- HLADANIE CEST V CYKLICKOM GRAFE

% - bude na prednaske
% cesta(X,Y,[],Path) plati, ak v grafe urcenom relaciou next existuje cesta z X do Y a Path je tato cesta od konca, urob reverz a mas cestu

cesta(X,X, Visited, Visited).
cesta(X,Y, Visited, P) :- next(X,Z), 
                          not(member(Z,Visited)),
                          cesta(Z, Y, [Z|Visited], P).

/*------------------------------------------------------------------------------------------------
na siedmych kamenoch sedi 6 ziab, 3 otocene vpravo, 3 vlavo, stredny kamen volny.
Zaby sa nikdy neotocia do protismeru, a zaba moze skocit v svojom smere
na susedny volny kamen, alebo preskocit jednu (!) zabu

prave zabky chcu ist na vlavo a lave napravo, ako ?

idea
konfiguracia ziab je kodovana ako 7-prvkovy zoznam
[z1,z2,z3,z4,z5,z6,z7], kde zi = -1, 0, 1,
0 je medzera
*/
init([-1,-1,-1,0,1,1,1]).
%final([1,1,1,0,-1,-1,-1]).
final(Xs):-init(Ys),reverse(Ys,Xs).


zabky :- init(I), final(F), cesta(I,F,[I],P), writeZabky(P).

next(C1, C2) :- append(U,[0,1|V],C1), append(U,[1,0|V],C2).
next(C1, C2) :- append(U,[-1,0|V],C1), append(U,[0,-1|V],C2).
next(C1, C2) :- append(U,[-1,X,0|V],C1), append(U,[0,X,-1|V],C2).
next(C1, C2) :- append(U,[0,X,1|V],C1), append(U,[1,X,0|V],C2).


writeZabky([]):-nl.
writeZabky([Z|Zs]):-write(Z), nl, writeZabky(Zs).

/*
riesenie:

?- zabky.
[1, 1, 1, 0, -1, -1, -1]
[1, 1, 0, 1, -1, -1, -1]
[1, 1, -1, 1, 0, -1, -1]
[1, 1, -1, 1, -1, 0, -1]
[1, 1, -1, 0, -1, 1, -1]
[1, 0, -1, 1, -1, 1, -1]
[0, 1, -1, 1, -1, 1, -1]
[-1, 1, 0, 1, -1, 1, -1]
[-1, 1, -1, 1, 0, 1, -1]
[-1, 1, -1, 1, -1, 1, 0]
[-1, 1, -1, 1, -1, 0, 1]
[-1, 1, -1, 0, -1, 1, 1]
[-1, 0, -1, 1, -1, 1, 1]
[-1, -1, 0, 1, -1, 1, 1]
[-1, -1, -1, 1, 0, 1, 1]
*/

%-----------------------------------------------------------------------------------------
% co tak 4+4 zabky

init8([-1-1,-1,-1,0,1,1,1,1]).
final8(Xs):-init8(Ys),reverse(Ys,Xs).
zabky8:- init8(I), final8(F), cesta(I,F,[I],P), length(P,L), write(L), nl, writeZabky(P).

%-----------------------------------------------------------------------------------------


% https://www.plastelina.net/game7.html

%-----------------------------------------------------------------------------------------
% co tak 5+5 zabky

init10([-1,-1,-1,-1,-1,0,1,1,1,1,1]).
final10(Xs):-init10(Ys),reverse(Ys,Xs).
zabky10:- init10(I), final10(F), cesta(I,F,[I],P), length(P,L), write(L), nl, writeZabky(P).


%-----------------------------------------------------------------------------------------
% co tak N+N zabky
repeat(0,_,[]).
repeat(N,X,[X|Xs]):-N>0, N1 is N-1, repeat(N1,X,Xs).

initN(N,Ws) :- repeat(N,-1,As), repeat(N,1,Bs), append(As, [0|Bs],Ws).
finalN(N,Xs):-initN(N,Ys),reverse(Ys,Xs).
zabky(N):- initN(N,I), finalN(N,F), cesta(I,F,[I],P), length(P,L), write(L), nl, writeZabky(P).

