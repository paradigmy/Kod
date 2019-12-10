/*
lcuin (Alkuin, Alch-wine, angl. Ealtwine (priateľ chrámu)) 
(* 735, Northumbria – † 19. máj 804, Tours) bol anglický filozof, 
anglosaský mních, odchovanec yorkskej školy, učiteľ a radca Karola 
Veľkého, potom opát v Tours. 
*/

% vlk, koza a kapusta chcu cez rieku, nikto nechce byt zozraty

cesta(X,X,P,P).
cesta(X,Y,Visited,P):- 
  hrana(X,Z), 
  not(member(Z,Visited)), 
  cesta(Z,Y,[Z|Visited],P).
  
hladaj :- zac(Z), kon(K), cesta(Z,K,[],P), reverse(P,P1), write(P1).
