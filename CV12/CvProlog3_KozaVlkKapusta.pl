/*
lcuin (Alkuin, Alch-wine, angl. Ealtwine (priateľ chrámu)) 
(* 735, Northumbria – † 19. máj 804, Tours) bol anglický filozof, 
anglosaský mních, odchovanec yorkskej školy, učiteľ a radca Karola 
Veľkého, potom opát v Tours. 
*/

% vlk, koza a kapusta chcu cez rieku, nikto nechce byt zozraty

zac(state(1,1,1,1)). % co je vlavo: lodka, vlk, koza, kapusta ;; kde je lodka, tam je rolnik
kon(state(0,0,0,0)). 

% lodka vpravo - kontroluje sa lavy breh
ok(0,Vl,Ko,Ka) :- KozaSKapustou is Ko+Ka, KozaSKapustou<2, KozaSVlkom is Ko+Vl, KozaSVlkom<2.
% lodka vlavo - kontroluje sa pravy breh
ok(1,Vl,Ko,Ka) :- Ko1 is 1-Ko, Ka1 is 1-Ka, KozaSKapustou is Ko1+Ka1, KozaSKapustou<2, Vl1 is 1-Vl, KozaSVlkom is Ko1+Vl1, KozaSVlkom<2.

hrana(state(1,Vl1,Ko1,Ka1),state(0,Vl2,Ko2,Ka2)) :-
    ((Vl1=1, Vl2 is 0, Ko2 is Ko1, Ka2 is Ka1);
     (Ko1=1, Vl2 is Vl1, Ko2 is 0, Ka2 is Ka1);
     (Ka1=1, Vl2 is Vl1, Ko2 is Ko1, Ka2 is 0);
     (Vl2 is Vl1, Ko2 is Ko1, Ka2 is Ka1)), 
    ok(0,Vl2,Ko2,Ka2).
    
hrana(state(0,Vl1,Ko1,Ka1),state(1,Vl2,Ko2,Ka2)) :- 
    ((Vl1=0, Vl2 is 1, Ko2 is Ko1, Ka2 is Ka1);
     (Ko1=0, Vl2 is Vl1, Ko2 is 1, Ka2 is Ka1);
     (Ka1=0, Vl2 is Vl1, Ko2 is Ko1, Ka2 is 1);
     (Vl2 is Vl1, Ko2 is Ko1, Ka2 is Ka1)),
    ok(1,Vl2,Ko2,Ka2).

cesta(X,X,P,P).
cesta(X,Y,Visited,P):- 
  hrana(X,Z), 
  not(member(Z,Visited)), 
  cesta(Z,Y,[Z|Visited],P).
  
hladaj :- zac(Z), kon(K), cesta(Z,K,[],P), reverse(P,P1), write(P1).
