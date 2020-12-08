/*
lcuin (Alkuin, Alch-wine, angl. Ealtwine (priateľ chrámu)) 
(* 735, Northumbria – † 19. máj 804, Tours) bol anglický filozof, 
anglosaský mních, odchovanec yorkskej školy, učiteľ a radca Karola 
Veľkého, potom opát v Tours. 
*/

% vlk, koza a kapusta chcu cez rieku, nikto nechce byt zozraty

% depth-first v grafe for free...

cesta(X,X,P,P).
cesta(X,Y,Visited,P):- 
  hrana(X,Z), ok(Z),
  not(member(Z,Visited)), 
  cesta(Z,Y,[Z|Visited],P).
  
hladaj :- zac(Z), kon(K), cesta(Z,K,[Z],P), reverse(P,P1), write(P1), nl.

%----------------- dodefinujte kozu, kapustu a vlka (alias hrana)

zac(state(left, 1,1,1)).
kon(state(right, 0,0,0)).

hrana(state(left, Vl, Ko, Ka), state(right, Vl, Ko, Ka)).
hrana(state(left, Vl, 1, Ka), state(right, Vl, 0, Ka)).
hrana(state(left, Vl, Ko, 1), state(right, Vl, Ko, 0)).
hrana(state(left, 1, Ko, Ka), state(right, 0, Ko, Ka)).

hrana(state(right, Vl,Ko,Ka), state(left, Vl1,Ko1,Ka1)) :-
                hrana(state(left, Vl1,Ko1,Ka1), state(right, Vl,Ko,Ka)).
               

% lavobreh state(Lo,Vl,Ko,Ka)
% pravobeh 1-Lo, 1-Vl, 1-Ko, 1-Ka

vkkOK(Vl,Ko,Ka) :- (KoKa is Ko+Ka, KoKa < 2), (VlKo is Vl+Ko, VlKo < 2).

ok(state(left, Vl,Ko,Ka)) :- Vl1 is Vl-1, Ko1 is 1-Ko, Ka1 is 1-Ka, vkkOK(Vl1, Ko1, Ka1).
ok(state(right,Vl,Ko,Ka)) :- vkkOK(Vl,Ko,Ka).
