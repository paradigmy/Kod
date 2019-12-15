%-----------
cisloXX(XX) :- repeat, write('Zadaj dvociferne cislo '), read(XX), (XX<100,XX>9, !, write(ok) ; write(zle), nl, fail).

cisloYY(XX) :- repeat, write('Zadaj dvociferne cislo '), read(XX),(XX<100,XX>9 -> write(ok)
					        ; write(zle), nl, fail).

cisloZZ(XX) :- repeat, write('Zadaj dvociferne cislo '), read(XX),(XX<100,XX>9 -> write(ok), !
					        ; write(zle), nl, fail).
					        
					        					        
sign(X,-1) :- X<0, !.
sign(X, 0):-X=0, !.
sign(X, 1):-X>0, !.
 
%--- jednotazky

neohr(1,2).
neohr(1,3).
neohr(1,4).
neohr(1,5).

neohr(2,3).
neohr(2,4).

neohr(3,4).
neohr(3,5).

hrany(Hrany) :- setof((X,Y), neohr(X,Y),Hrany).

jednotazka(X,Res) :- hrany(Hrany), jednotazka(X,Hrany,[X],Res).

jednotazka(_,[],C,Res):-Res = C.
jednotazka(X,Hrany,C,Res):-
		(select((X,Y),Hrany,Hrany1) ; select((Y,X),Hrany,Hrany1)),
		jednotazka(Y,Hrany1,[Y|C],Res).

% jednotazka(X,Y,Path) :- pocetHran(PH), cesta(X,Y,[],Path), length(Path,PH).

%-- farbenie grafu

mapa(
  [susedia(portugal,Portugal,[Spain]),
   susedia(spain,Spain,[France,Portugal]),
   susedia(france,France,[Spain,Italy,Switzerland,Belgium,Germany,Luxemburg]),
   susedia(belgium,Belgium,[France,Holland,Luxemburg,Germany]),
   susedia(holland,Holland,[Belgium,Germany]),
   susedia(germany,Germany,[France,Austria,Switzerland,Holland,Belgium,Luxemburg]),
   susedia(luxemburg,Luxemburg,[France,Belgium,Germany]),
   susedia(italy,Italy,[France,Austria,Switzerland]),
   susedia(switzerland,Switzerland,[France,Austria,Germany,Italy]),
   susedia(austria,Austria,[Italy,Switzerland,Germany])
  ]).

colors([green,red,blue,yellow]).

members([],_).
members([X|Xs],Ys):-member(X,Ys), members(Xs,Ys).

colorMap([],_).
colorMap([susedia(_,Color,Neighbors)|Xs],Colors) :-
	select(Color,Colors,Colors1),
	members(Neighbors,Colors1),
	colorMap(Xs,Colors).

colorit :- mapa(M), colors(Cols), colorMap(M,Cols), write(M),nl.


/* --------------------------- HRY
zoberme si nejaku jednoduchu NIM-like hru, napr: jednokopovy NIM,
Pravidla:
 - hrac berie 1,2 alebo 3 zapalky,
 - vyhrava ten, kto berie poslednu zapalku

a naprogramujme predikaty vitaznaPozicia1NIM, prehravajucaPozicia1NIM a spravnyTah1NIM

*/
vitaznaPozicia1NIM(N):-N>0, N<4, !.
vitaznaPozicia1NIM(N):-tah1NIM(N,N1),			% existuje nejaky spravny tah z N do N1,
			prehravajucaPozicia1NIM(N1).	% ze nova konfiguracia N1 je prehravajuca

tah1NIM(N,N1):-between(1,3,Tah), Tah=<N, N1 is N-Tah.	% existuje korektny nejaky Tah

prehravajucaPozicia1NIM(0):-!.
prehravajucaPozicia1NIM(N):-bagof(vitaznaPozicia1NIM(N1), tah1NIM(N,N1), All),
							% pre lubovony tah, nova konfiguracia je vitazna
			forall(All).

% plati pre vsetky podciele v zozname
forall(G):-write(G),nl, fail.
forall([]).
forall([G|Gs]):-G,forall(Gs).

spravnyTah1NIM(N):-tah1NIM(N,N1), prehravajucaPozicia1NIM(N1),
		write('nechaj ='), write(N1),nl.

/*
co vie uz aj ziacik na zakladke, ze zle pozicie su tvaru 3*x+1 a vitazna strategia je:
ak super zoberie t zapaliek, ja beriem 4-t, ak som vo vitaznej pozicii,
ak som v prehravajucej pozicii, je to fuk, takze beriem co najmenej (sanca ze sa super pomyli).

*/

%======================================================

/*
- skusme nieco zlozitejsie: 3-kopovy NIM
pravidla (http://en.wikipedia.org/wiki/Nim):
- hrac berie z lubovolnej kopy (ale len jednej) lub.pocet zapaliek
- vyhrava ten, kto berie poslednu (t.j. prehrava, ten co uz nema co brat).

definujme predikaty: vitaznaPozicia3NIM, prehravajucaPozicia3NIM a spravnyTah3NIM
*/

% - toto je zavisle na hre
tah3NIM([A,B,C],[A1,B,C]):-X is A-1, between(0,X,A1).
tah3NIM([A,B,C],[A,B1,C]):-X is B-1, between(0,X,B1).
tah3NIM([A,B,C],[A,B,C1]):-X is C-1, between(0,X,C1).

/*
technika tabeliazacie:

ak mam dokazat P, je moze, ze som to uz pocital, a potom som si to ulozil do databazy faktov, alebo
to teda musim spocitat, ale potom si to ulozim do databazy faktov
*/

lemma(P):-write('zistujem '), write(P), nl, fail.
%lemma(P):-P.
lemma(P):-(clause(P,true),write('nasiel '), write(P), nl, !)
		;
	  (   P,write('dokazal '), write(P), nl, assertz(P:-true)).

:-dynamic
     vitaznaPozicia3NIM/1.

vitaznaPozicia3NIM([A,0,0]):-A>0.
vitaznaPozicia3NIM([0,B,0]):-B>0.
vitaznaPozicia3NIM([0,0,C]):-C>0.


%- toto je nezavisle na hre
vitaznaPozicia3NIM(N):-tah3NIM(N,N1),			% existuje nejaky spravny tah z N do N1,
			lemma(prehravajucaPozicia3NIM(N1)).	% ze nova konfiguracia N1 je prehravajuca

:-dynamic
     prehravajucaPozicia3NIM/1.

prehravajucaPozicia3NIM([0,0,0]).
prehravajucaPozicia3NIM(N):-bagof(lemma(vitaznaPozicia3NIM(N1)), tah3NIM(N,N1), All),
							% pre lubovony tah, nova konfiguracia je vitazna
			forall(All).

spravnyTah3NIM(N):-tah3NIM(N,N1), lemma(prehravajucaPozicia3NIM(N1)),
		write('nechaj ='), write(N1),nl.

%-------------------------------------

:-dynamic fib/2.	

fib(N,1):-N<2,!.
fib(N,F):-N1 is N-1, N2 is N-2, 
		lemma(fib(N1,F1)), 
 	  	lemma(fib(N2,F2)), 
		F is F1+F2.



%------------------------------------------------------------

% èo robí/znamená tento predikát

foo(X):-(X,(retract(db(fooo,_)),!,fail;
	asserta(db(fooo,X)), fail) )
        ;
        retract(db(fooo,X)).

a.	% predikát s jedným riešením
b.	% predikát s dvomi riešeniami
b.
c.	% predikát s tromi riešeniami
c.
c.
d.
d.
d.
d.
e.
e.
e.
e.
e.
f:-fail.% predikát so žiadnym riešením

:-dynamic 
	db/2.

/* 
ak X nie je splnite¾ný, foo(X) neplatí, posledný retract sa nepodari, foo(X) zlyhá,
ak X má riešenie, nájdeme prvé, retract(db(fooo,_)) zlyhá, takže 
   assert(db(fooo,X)) uspeje, a následne fail, 
   ak X nemá ïalšie riešenie posledný retract(db(fooo,X)) odmaže, èo assert vsunul.
   Teda, databáza je v pôvodnom stave.
   ak X má druhé riešenie, retract(db(foo,_)) vymaže prvé riešenie, urobí cut-fail takže
   výpoèet pokraèuje retract(db(fooo,X)), ktorý zlyhá.
   Podomne, ak má viac riešení.
   
?- foo(a).
Yes
?- foo(b).
No
?- foo(c).

No
?- foo(f).
No

takže, foo(X) vlastne znamená:
  */
foo1(X):-findall(X,X,[_]).
         
%-------------------------------------------------------------------

% predefinujte predikát goo bez assert a retract
goo(X):- (X,
          (retract(db(gooo,_)),! ;
           asserta(db(gooo,1)), fail ) 
         );
         (retract(db(gooo,_)), fail).
         
/*
  Ak X nemá riešenie, goo(X) neplatí.
  Ak má X jedno riešenie, tak retract(db(gooo,_)) zlyhá, vykoná sa asserta(db(gooo,1)), fail zlyhá.
    Ak neexistuje ïalšie riešenie X, retract(db(gooo,_)) odmaže db(gooo,1) a klauzula zlyhá. 
  Ak existuje ïalšie X neexistuje (napr. X dve riešenia), retract(db(gooo,_)),! odmaže prvé a cut
  odstráni alternatívy.
  */         

%-------------------------------------------------------------------

:-dynamic 
	p/1.
    
p(1):-retract(p(_):-_),assert(p(2)).

/*
1 ?- p(1).
Yes
2 ?- p(2).
Yes
3 ?- p(3).
No
*/
%------------------------------------------------------

gen(N,List):-myfindall(X,between(1,N,X),List).
gen1(N,List):-between(1,N,M), gen(M,List).
gengen1(N,ListList):-myfindall(List,gen1(N,List),ListList).

/*
?- gen(5,L).
L = [1, 2, 3, 4, 5] ;
No
?- gen1(5,L).
L = [1] ;
L = [1, 2] ;
L = [1, 2, 3] ;
L = [1, 2, 3, 4] ;
L = [1, 2, 3, 4, 5] ;
No
?- gengen1(5,L).
L = [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5]] ;
*/
%------------------------------------------------------

%myfindall(Term,Goal,_):-Goal,assertz(bof(Term)), fail.
%myfindall(_,_,List):-loop(List), !.
%loop([X|List]):-retract(bof(X)),!,loop(List).
%loop([]).


% spravna verzia...
myfindall(Term,Goal,_):-asserta(bof(end)),Goal,asserta(bof(Term)), fail.
myfindall(_,_,List):-retract(bof(X)), loop(X, [], List), !. 
loop(end,L,L):- !. 		
loop(X,L1,L):-retract(bof(Y)), !, loop(Y,[X|L1], L). 


%------------------------------------------------------
%- domaca uloha pre fajnsmekrov

hoo(X):-(X, (retract(db(fooo,_)), !, fail ; assert(db(fooo(X)), fail)));
         retract(db(fooo,X)).
         
ioo(X):-X,
        (retract(db(fooo,_)), ! ; asserta(db(gooo,1)),fail); retract(db(fooo,_)), fail.
                 
%---------------------------------------------------

redukuj:-cesta(A,B,AB,CestaAB), cesta(B,C,BC,CestaBC), cesta(A,C,AC,CestaAC),
         da_sa_kratsie(AB,BC,AC,ABC)->append(CestaAB,CestaBC,CestaABC), replace(cesta(A,C,ABC, CestaABC)), redukuj.
	
da_sa_kratsie(AB,BC,AC,ABC):-number(AB), number(BC), ABC is AB+BC, ((number(AC),ABC<AC);AC=nekonecno).
	        
replace(cesta(A,B,AB, CestaAB)):-
	retractall(cesta(A,B,_,_)),
	write(cesta(A,B,AB, CestaAB)),nl,
	assert(cesta(A,B,AB, CestaAB)).
	
vrcholy(V):-setof(X,Y^C^(hrana(X,Y,C);hrana(Y,X,C)),V).

pridajCesty(Vs):-member(V1,Vs), assert(cesta(V1,V1,0,[])), fail.
pridajCesty(Vs):-member(V1,Vs), member(V2, Vs), not(V1 = V2),
  	     (hrana(V1,V2,C) -> 
		assert(cesta(V1,V2,C,[V1-V2])),assert(cesta(V2,V1,C,[V2-V1])) 
  	     	; 
  	     	assert(cesta(V1,V2,nekonecno,neexistuje)), assert(cesta(V2,V1,nekonecno,neexistuje))), 
  	     fail.
pridajCesty(_).
  	     
najkratsiaCesta(V1,V2,D,C):-vrcholy(Vs), pridajCesty(Vs), redukuj, cesta(V1,V2,D,C).

:-dynamic
     cesta/4.

/*
hrana(a,b,5).
hrana(b,d,2).
hrana(c,d,1).
hrana(a,c,1).
hrana(d,e,1).
hrana(c,f,2).
hrana(e,f,3).
*/

hrana(aberdeen,    edinburgh,   115).
hrana(aberdeen,    glasgow,     142).
hrana(aberystwyth, birmingham,  114).
hrana(aberystwyth, cardiff,     108).
hrana(aberystwyth, liverpool,   100).
hrana(aberystwyth, nottingham,  154).
hrana(aberystwyth, sheffield,   154).
hrana(aberystwyth, swansea,      75).
hrana(birmingham,  bristol,      86).
hrana(birmingham,  cambridge,    97).
hrana(birmingham,  cardiff,     100).
hrana(birmingham,  liverpool,    99).
hrana(birmingham,  manchester,   80).
hrana(birmingham,  nottingham,   48).
hrana(birmingham,  oxford,       63).
hrana(birmingham,  sheffield,    75).
hrana(birmingham,  swansea,     125).
hrana(brighton,    bristol,     136).
hrana(brighton,    dover,        81).
hrana(brighton,    oxford,       96).
hrana(brighton,    portsmouth,   49).
hrana(brighton,    london,       52).
hrana(bristol,     exeter,       76).
hrana(bristol,     oxford,       71).
hrana(bristol,     portsmouth,   97).
hrana(bristol,     swansea,      89).
hrana(bristol,     london,      116).
hrana(cambridge,   nottingham,   82).
hrana(cambridge,   oxford,       80).
hrana(cambridge,   london,       54).
hrana(cardiff,     swansea,      45).
hrana(carlisle,    edinburgh,    93).
hrana(carlisle,    glasgow,      94).
hrana(carlisle,    leeds,       117).
hrana(carlisle,    liverpool,   118).
hrana(carlisle,    manchester,  120).
hrana(carlisle,    newcastle,    58).
hrana(carlisle,    york,        112).
hrana(dover,       london,       71).
hrana(edinburgh,   glasgow,      44).
hrana(edinburgh,   newcastle,   104).
hrana(exeter,      penzance,    112).
hrana(exeter,      portsmouth,  126).
hrana(glasgow,     newcastle,   148).
hrana(hull,        leeds,        58).
hrana(hull,        nottingham,   90).
hrana(hull,        sheffield,    65).
hrana(hull,        york,         37).
hrana(leeds,       manchester,   41).
hrana(leeds,       newcastle,    89).
hrana(leeds,       sheffield,    34).
hrana(leeds,       york,         23).
hrana(liverpool,   manchester,   35).
hrana(liverpool,   nottingham,  100).
hrana(liverpool,   sheffield,    70).
hrana(manchester,  newcastle,   130).
hrana(manchester,  sheffield,    38).
hrana(newcastle,   york,         80).
hrana(nottingham,  sheffield,    38).
hrana(oxford,      london,       57).
