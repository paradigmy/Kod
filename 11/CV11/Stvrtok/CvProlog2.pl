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
%druhyNajvacsi(Xs, M)

druhyNajvacsi(Xs, M2) :- max_member(M1, Xs), select(M1, Xs, BezM1), max_member(M2, BezM1).
% ?- druhyNajvacsi([1,2,3,4], DN).

deleteAll(_, [], []).
%deleteAll(M, [M|T], T1) :- deleteAll(M, T, T1).
%deleteAll(M, [H|T], [H|T1]) :- H \= M, deleteAll(M, T, T1).               % H \= M


deleteAll(M, [H|T], Y) :- H == M -> (deleteAll(M, T, Y) ); (deleteAll(M, T, T1), Y = [H|T1]).

% if c then T else C;   (C) -> T ; E

deleteFirst(_, [], []).
deleteFirst(M, [M|T], T).
deleteFirst(M, [H|T], [H|T1]) :- H \= M, deleteFirst(M, T, T1).               % H \= M



%% ----------------------------------------------------------------------------

% pocet a-cok v z zoznam, ktore je spravne riesenie
pocetA([],0).
pocetA([a|Xs],N) :- N1 is N-1, pocetA(Xs,N1).

countA([],0).
countA([a|Xs],N) :- N1 is N+1, countA(Xs,N1).

schitat([],0).
schitat([a|Xs],N) :- schitat(Xs,N1), N1 is N+1.

combien([],0).
combien([a|Xs],N) :- combien(Xs,N1), N is N1+1.

%% ----------------------------------------------------------------------------

% zovseobecnenie, geralizacia, countX rata pismenka X
countX(_,[], 0).
%countX(X,[X|Xs], N):-countX(X,Xs,N1), N is N1+1.
%countX(X,[Y|Xs], N):-not(X=Y),countX(X,Xs,N).
% takto sa pise if-then-else
countX(X,[Y|Xs], N):- (X==Y) ->(countX(X,Xs,N1), N is N1+1) ; countX(X,Xs,N).

% if C then T else E sa pise E -> T ; E
/*
?- countX(a,[a,b,b,a],X).
X = 2 ;
false.
*/

%% --------------------------------------------------------------------------
% is_list(X) X je zoznam ?

f([H|T], Y) :- f(H, Hf), f(T, Tf), append(Hf, Tf, Y).
f([], []).
f(X, [X]) :- not(is_list(X)).
%f(X, [X]) :- atomic(X), X \= [].

dr([H|T], Y) :- dr(H, Hf), dr(T, Tf), append(Tf, [Hf], Y).
dr([], []).
dr(X, X) :- not(is_list(X)).



% existuje predikat is_list(X) ktory plati, ak X je zoznam, teda [] alebo [H|T]
% atom je predikat, ktory plati pre konstanty, a, b, jozo, ...
% atomic je predikat, ktory plati pre atom alebo integer

% z prednasky
% stromova rekuzia a append
flat([X|Xs],Ys) :- flat(X,Ys1), flat(Xs,Ys2), append(Ys1, Ys2, Ys).
flat(X, [X]) :- atomic(X), X\=[].
flat([],[]).

%?- flat([[a],b,[],[[[c],d,[e]]]],F).
%F = [a, b, c, d, e] ;

% stromova rekuzia bez appendu 
flat1(X,Y) :- flat1(X, [], Y).
flat1([X|Xs], Ys1, Ys) :- flat1(X, Ys1, Ys2), flat1(Xs, Ys2, Ys).
%flat1(X,Ys,[X|Ys]) :- atomic(X), X\=[].
flat1(X,Ys,[X|Ys]) :- not(is_list(X)).
flat1([], Ys, Ys).

% skuste bez stromovej rekuzie a appendu
flat2([[Y|Ys]|Xs], List) :- flat2([Y|[Ys|Xs]], List).  % trik
%flat2([X|Xs], [X|List]) :- atomic(X), X\=[], flat2(Xs,List).
flat2([X|Xs], [X|List]) :- not(is_list(X)), flat2(Xs,List).
flat2([[]|Xs], Ys) :- flat2(Xs, Ys).
flat2([], []).


farba(cervena).
farba(zelena).
farba(zlta).


% ---------------------------------
% VINGT + CINQ + CINQ = TRENTE

%   VINGT  
%    CINQ
%    CINQ
% --------
%  TRENTE

c(X) :- between(0,9,X).

allDiff([]).
allDiff([X|Xs]) :- not(member(X,Xs)), allDiff(Xs).

sum(X,C1,C2,C3,R,Y) :- Res is X+C1+C2+C3,
                       R is Res mod 10,
                       Y is Res // 10.
                       
solve(V,I,N,G,T,C,Q,R,E) :-
        c(T), c(Q), sum(0, T,Q,Q, E, Pr1),
        allDiff([T,Q,E]),
        c(G), c(N), sum(Pr1, G,N,N, T, Pr2),
        allDiff([T,Q,E, G, N]),
        c(I), sum(Pr2, N,I,I, N, Pr3),
        allDiff([T,Q,E, G, N, I]),
        c(C), sum(Pr3, I,C,C, E, Pr4),
        allDiff([T,Q,E, G, N, I, C]),
        c(V), sum(Pr4, V,0,0, R, Pr5),
        allDiff([T,Q,E, G, N, I, C, V,R]), 
        V \= 0,
        T = Pr5, C \= 0, T \=0.
        
% ----------------------------------------
solve1(V,I,N,G,T,C,Q,R,E) :-
        select(T, [0,1,2,3,4,5,6,7,8,9], Z1),
        select(Q, Z1, Z2),
        sum(0, T,Q,Q, E, Pr1),
        select(E,Z2,Z3),
        
        select(G,Z3, Z4),
        select(N,Z4, Z5),
        sum(Pr1, G,N,N, T, Pr2),
        
        select(I,Z5,Z6),
        sum(Pr2, N,I,I, N, Pr3),
        
        select(C,Z6,Z7),
        sum(Pr3, I,C,C, E, Pr4),
        
        select(V,Z7,_Z8),
        sum(Pr4, V,0,0, R, Pr5),
        allDiff([T,Q,E, G, N, I, C, V,R]), 
        V \= 0,
        T = Pr5, C \= 0, T \=0.
        
% -- LES * LES = PRALES        


%-------------------------------------- HLADANIE CEST V CYKLICKOM GRAFE

% - bude na prednaske
% cesta(X,Y,[],Path) plati, ak v grafe urcenom relaciou next existuje cesta z X do Y a Path je tato cesta od konca, urob reverz a mas cestu

cesta(X,X,P,P).
cesta(X,Y,Visited,P):- 
    next(X,Z), 
    not(member(Z,Visited)), 
    cesta(Z,Y,[Z|Visited],P).

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
final(Xs):-init(Ys),reverse(Ys,Xs).

next(C1, C2) :- append(X,[0,1|Y],C1), append(X,[1,0|Y],C2).
next(C1, C2) :- append(X,[-1,0|Y],C1), append(X,[0,-1|Y],C2).

next(C1, C2) :- append(X,[0,-1,1|Y],C1), append(X,[1,-1,0|Y],C2).
next(C1, C2) :- append(X,[-1,1,0|Y],C1), append(X,[0,1,-1|Y],C2).


zabky :- init(I), final(F), cesta(I,F,[],P), writeZabky(P).

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
zabky8:- init8(I), final8(F), cesta(I,F,[],P), writeZabky(P).

%-----------------------------------------------------------------------------------------


