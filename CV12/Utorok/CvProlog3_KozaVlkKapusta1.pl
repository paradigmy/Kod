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

% nie redundatne, stav na lavobrehu
% state(left/right, Vl, Ko, Ka)  (1-Vl, 1-Ko, 1-Ka)
% [Lod, Vl, Ko, Ka]
% state(left/right, [Vl, Ko, Ka], [VL1, Ko1, Ka1])
% 

zac(state(left, 1,1,1)).
kon(state(right, 0,0,0)).

hrana(state(left, Vl, Ko, Ka), state(right, Vl, Ko, Ka)).
hrana(state(left, 1, Ko, Ka), state(right, 0, Ko, Ka)).
hrana(state(left, Vl, 1, Ka), state(right, Vl, 0, Ka)).
hrana(state(left, Vl, Ko, 1), state(right, Vl, Ko, 0)).

hrana(state(right, Vl, Ko, Ka), state(left, Vl1, Ko1, Ka1)) :-
    hrana(state(left, Vl1, Ko1, Ka1), state(right, Vl, Ko, Ka)).

ok(state(left, Vl, Ko, Ka)) :- VlR is 1-Vl, KoR is 1-Ko, KaR is 1-Ka, vkkok(VlR,KoR,KaR).
ok(state(right, Vl, Ko, Ka)) :- vkkok(Vl, Ko, Ka) .

vkkok(Vl, Ko, Ka) :- (KoKa is Ko+Ka, KoKa < 2), (KoVl is Ko+Vl, KoVl < 2).


/*
state(left,1,1,1),
state(right,1,0,1),
state(left,1,0,1),
state(right,0,0,1),
state(left,0,1,1),
state(right,0,1,0),
state(left,0,1,0),
state(right,0,0,0)]
 
 VL KO KA              VL KO KA
--------------------------------
  0  0  0               1   1  1

*/