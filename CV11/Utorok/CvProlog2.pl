% Pyramidy v Midterme
% SO

:- use_module(library(lists)).   % toto je import library(lists)

% rozcvicka

% obsahuju dve nuly po sebe
obsahuje00(_).

%?- obsahuje00([1,2,0,0,1,2]).

% neobsahuju dve nuly po sebe
bez00(_).

%?- bez00([1,2,0,2,0,1,2]).
% ---------------
%druhyNajvacsi(Xs, M)

% ?- druhyNajvacsi([1,2,3,4], DN).

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


% ---------------------------------
% VINGT + CINQ + CINQ = TRENTE

%   VINGT  
%    CINQ
%    CINQ
% --------
%  TRENTE

                       
%solve(V,I,N,G,T,C,Q,R,E) :-
        
% -- LES * LES = PRALES        


%-------------------------------------- HLADANIE CEST V CYKLICKOM GRAFE

% - bude na prednaske
% cesta(X,Y,[],Path) plati, ak v grafe urcenom relaciou next existuje cesta z X do Y a Path je tato cesta od konca, urob reverz a mas cestu


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


%zabky :- init(I), final(F), cesta(I,F,[],P), writeZabky(P).

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
%zabky8:- init8(I), final8(F), cesta(I,F,[],P), writeZabky(P).

%-----------------------------------------------------------------------------------------


