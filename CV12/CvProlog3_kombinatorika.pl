% generujme binarne cisla dlzky n (to su vlastne variacie s opakovanim dlzky N mnoziny {0,1})

bin(0,[]).
bin(N,[0|Y]):-N>0, N1 is N-1, bin(N1,Y).
bin(N,[1|Y]):-N>0, N1 is N-1, bin(N1,Y).

%vso(N, Base, V)
vso(0, _, []).    % variacia dlzky 0 z lubovolne mnoziny je []
vso(N, Base, [X|Xs]) :- N>0, N1 is N-1, member(X,Base), vso(N1, Base, Xs).

/*
setof(K, vso(3,[a,b,c,d,e], K), List), length(List,Len).
125 = 5*5*5
bagof(K, vso(3,[a,b,c,d,e], K), List), length(List,Len).
125 = 5*5*5
*/

%vbo(N, Base, V)
vbo(0, _, []).    % variacia dlzky 0 z lubovolne mnoziny je []
vbo(N, Base, [X|Xs]) :- N>0, N1 is N-1, select(X,Base, Rest), vbo(N1, Rest, Xs).

/*
setof(K, vbo(3,[a,b,c,d,e], K), List), length(List,Len).
60 = 5*4*3
bagof(K, vbo(3,[a,b,c,d,e], K), List), length(List,Len).
60 = 5*4*3
*/

podmnozina(_, []).
podmnozina([X|Xs],[X|Ys]) :- podmnozina(Xs,Ys).
podmnozina([_|Xs],Ys) :- podmnozina(Xs,Ys).

/*
setof(P, podmnozina([a,b,c],P), PowerSet), length(PowerSet,L).
8
bagof(P, podmnozina([a,b,c],P), PowerSet), length(PowerSet,L).
15 :(
*/

% niektore riesenia boli redundante....
% a uz nie su
podmnozina1([], []).
podmnozina1([X|Xs],[X|Ys]) :- podmnozina1(Xs,Ys).
podmnozina1([_|Xs],Ys) :- podmnozina1(Xs,Ys).

/*
setof(P, podmnozina1([a,b,c],P), PowerSet), length(PowerSet,L).
8
bagof(P, podmnozina1([a,b,c],P), PowerSet), length(PowerSet,L).
8 :)
*/


kbo(0, _, []).
kbo(K, [X|Xs], [X|Ys]) :- K > 0, K1 is K-1, kbo(K1, Xs, Ys).
kbo(K, [_|Xs], Ys) :- K > 0, kbo(K, Xs, Ys).

/*
n nad k, teda 5 nad 2  je 10...

bagof(K, kbo(2,[a,b,c,d,e], K), List), length(List, Len).
10

setof(K, kbo(2,[a,b,c,d,e], K), List), length(List, Len).
10
*/

kso(0, _, []).
kso(K, [X|Xs], [X|Ys]) :- K > 0, K1 is K-1, kso(K1, [X|Xs], Ys).
kso(K, [_|Xs], Ys) :- K > 0, kso(K, Xs, Ys).

/*
n+k-1 nad k = n+k-1 nad n-1 =  5+3-1 nad 3, co je 7 nad 3 =  7*6*5/6 = 35

?- bagof(K, kso(3,[a,b,c,d,e], K), List), length(List, Len).
35

?- setof(K, kso(3,[a,b,c,d,e], K), List), length(List, Len).
35
*/
%-----------------------------------------------------------------------

%-- kombinatorika (prve dve su z prednasky)

% pocet: n!
%perm(Xs,[H|Hs]):-delete(H,Xs,W),perm(W,Hs).
perm(Xs,[H|Hs]):-select(H,Xs,W),perm(W,Hs).
perm([],[]).
   
insert(X,Y,Z):-select(X,Z,Y).
perm2([],[]).
perm2([X|Xs],Zs) :- perm2(Xs,Ys),insert(X,Ys,Zs).

%- pocet: n nad k
comb_bez_opakovania([],_).
comb_bez_opakovania([X|Xs],[X|T]):-comb_bez_opakovania(Xs,T).
comb_bez_opakovania([X|Xs],[_|T]):-comb_bez_opakovania([X|Xs],T).

%- K-prvkove kombinacie bez opakovania z mnoziny M velkosti N, comb_bez_opakovania(K, M, X)
%comb_bez_opakovania(N,Mnozina,Kombinacia)

comb_bez_opakovania(0,_,[]).
comb_bez_opakovania(K,[X|T],[X|Xs]):-K>0,K1 is K-1,comb_bez_opakovania(K1,T,Xs).
comb_bez_opakovania(K,[_|T],[X|Xs]):-comb_bez_opakovania(K,T,[X|Xs]).

%==================================================

/* V cukr??rni sa pod??vaj?? 4 druhy z??kuskov :
vencek, vetern??k, laskonky a dobo??ka. Kolk??mi
sp??sobmi je mo??no k??pit 7 z??kuskov */

% N-prvkove kombinacie s *opakovanim prvkov*
% u kombinacii nezalezi na poradi

% pocet: (n+k-1) nad k

%comb(N,Mnozina,Kombinacia)

comb(0,_,[]):-!.
comb(K,[X|Xs],[X|Ys]):-K1 is K-1,comb(K1,[X|Xs],Ys).
comb(K,[_|Xs],Ys):-comb(K,Xs,Ys).

/*
?- bagof(X,comb(3,[a,b,c,d],X),L),write(L).

poznamka: bagof(X,G,L) je predikat,ktory pozbiera hodnoty vyrazu X pre vsetky riesenia
ciela G do zoznamu L.

[[a,a,a],[a,a,b],[a,a,c],[a,a,d],[a,b,b],[a,b,c],[a,b,d],[a,c,c],[a,c,d],[a,d,d],[b,b,b],[b,b,c],[b,b,d],[b,c,c],[b,c,d],[b,d,d],[c,c,c],[c,c,d],[c,d,d],[d,d,d]]
*/

/*
podme riesit zakusky:
?- comb(7,[vencek,veternik,laskonka,doboska],Zak).
... 120 rieseni

alebo
?- bagof(Zak,comb(7,[vencek,veternik,laskonka,doboska],Zak),List),length(List,N).

Zak = _G664
List = [[vencek, vencek, vencek, vencek, vencek, vencek, vencek], [vencek, vencek, vencek, vencek, vencek, vencek, veternik], [vencek, vencek, vencek, vencek, vencek, vencek|...], [vencek, vencek, vencek, vencek, vencek|...], [vencek, vencek, vencek, vencek|...], [vencek, vencek, vencek|...], [vencek, vencek|...], [vencek|...], [...|...]|...]
N = 120 ;
t.j. 
N=4, k=7
4+7-1 nad 7 = 10 nad 7 = 10.9.8.7.6.5.4/7.6.5.4.3.2 = 10.3.4 = 120
n+k-1 nad k ==== n+k-1 nad n-1
*/

comb_([],[]):-!.
comb_([X|Xs],[X|Ys]):-comb_([X|Xs],Ys).
comb_([_|Xs],Ys):-comb_(Xs,Ys).

/*
?- L=[_,_,_],comb_([a,b,c,d],L).
L = [a,a,a] ;
L = [a,a,b] ;
L = [a,a,c] ;
L = [a,a,d] ;
L = [a,b,b] ;
L = [a,b,c] ;
L = [a,b,d] ;
L = [a,c,c] ;
L = [a,c,d] ;
L = [a,d,d] ;
L = [b,b,b] ;
L = [b,b,c] ;
L = [b,b,d] ;
L = [b,c,c] ;
L = [b,c,d] ;
L = [b,d,d] ;
L = [c,c,c] ;
L = [c,c,d] ;
L = [c,d,d] ;
L = [d,d,d] ;
*/

%==================================================================

% K-prvkove variacie

/*
zdroj: http://forum.matweb.cz/viewtopic.php?id=2479

Hlavny rozdiel medzi variaciami a kombinaciami je,ze pri variaciach zalezi na 
poradi,pricom pri kombinaciach nie. Permutacie su specialnym pripadom variacii.
Teda ked budeme rozpravat o pocte moznosti vytvorenia 4-ciferneho cisla _ _ _ _ 
z cislic {1,2,3,4},podme premyslat. Zalezi na poradi cislic? Urcite ano,
teda budu to variacie. Kolko mame moznosti? Na prve miesto mozme dosadit lubovolnu 
cislicu,teda moznosti je [4] _ _ _ . Dalej,ci sa cisla mozu alebo nemozu opakovat. 
Ak sa mozu,pocet moznosti bude logicky [4] [4] [4] [4] ,teda 4^4 (pocet cislic 
(mnoziny) na pocet miest,n^k). Ak sa opakovat nemozu,vysledkom bude [4] [3] [2] [1],
teda 4! ,co je v tomto pripade prave pocet permutacii bez opakovania. 
Ked je pocet cislic a miest rovny (n=k),hovorime o permutaciach a vysledkom je 
jednoducho n!. Kebyze mame na vyber cislice {1,2,3,4,5,6} ,vidime,ze celu mnozinu neminieme. 
Vysledkom bude [6] [5] [4] [3] ,teda vztah pre variacie bez opakovania nam 
vyjde n! / (n-k)!  Odtial aj vidno,ako nam vyjde vztah pre permutacie,kedy n=k.
*/

% K-prvkove variacie s opakovanim
% pocet: n^k

variacie(0,_,[]):-!.
variacie(K,Xs,[X|Ys]):-K1 is K-1,member(X,Xs),variacie(K1,Xs,Ys).


% K-prvkove variacie bez opakovania
% pocet: n.(n-1).....(n-k+1), alias n!/(n-k)!

variacie_bez_opakovania(0,_,[]).
variacie_bez_opakovania(K,Xs,[X|Ys]):-K>0, K1 is K-1, select(X,Xs,Zs),variacie_bez_opakovania(K1,Zs,Ys).

select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]):-select(X,Ys,Zs).

/*
?- L=[_,_,_],bagof(L,variacie_bez_opakovania([a,b,c,d],L),List),write(List),nl,length(List,Len),write(Len).
[[a,b,c],[a,b,d],[a,c,b],[a,c,d],[a,d,b],[a,d,c],[b,a,c],[b,a,d],[b,c,a],[b,c,d],[b,d,a],[b,d,c],[c,a,b],[c,a,d],[c,b,a],[c,b,d],[c,d,a],[c,d,b],[d,a,b],[d,a,c],[d,b,a],[d,b,c],[d,c,a],[d,c,b]]
24
*/


