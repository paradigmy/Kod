/*
lcuin (Alkuin, Alch-wine, angl. Ealtwine (priateľ chrámu)) 
(* 735, Northumbria – † 19. máj 804, Tours) bol anglický filozof, 
anglosaský mních, odchovanec yorkskej školy, učiteľ a radca Karola 
Veľkého, potom opát v Tours. 
*/

/*
There were three men, each having an unmarried sister, who needed to
cross a river. Each man was desirous of his friend's sister. Coming to the
river, they found only a small boat in which only two persons could cross
at a time. How did they cross the river, so that none of the sisters were
defiled by the men?

https://www.psychologytoday.com/nz/blog/brain-workout/201006/alcuin-s-river-crossing-puzzles-and-common-sense

Three men, each one accompanied by his unmarried sister, come to a riverbank. 
The small boat that will take them across can hold only two people. 
To avoid any compromising situations, the crossings are to be so arranged 
that no sister shall be left alone with a man-on the boat or on either 
side-unless her brother is present. 
How many crossings are required, if any man or woman can be the rower?
*/

init(state([1,1,1],[1,1,1],l)).
final(state([0,0,0],[0,0,0],r)).

% jeden muz sa plavi z lava do prava
next(state([1,M2,M3],[W1,W2,W3],l), state([0,M2,M3],[W1,W2,W3],r)).
next(state([M1,1,M3],[W1,W2,W3],l), state([M1,0,M3],[W1,W2,W3],r)).
next(state([M1,M2,1],[W1,W2,W3],l), state([M1,M2,0],[W1,W2,W3],r)).

% jedna zena sa plavi z lava do prava
next(state([M1,M2,M3],[1,W2,W3],l), state([M1,M2,M3],[0,W2,W3],r)).
next(state([M1,M2,M3],[W1,1,W3],l), state([M1,M2,M3],[W1,0,W3],r)).
next(state([M1,M2,M3],[W1,W2,1],l), state([M1,M2,M3],[W1,W2,0],r)).

% dvaja muzi sa plavia z lava do prava
next(state([1,1,M3],[W1,W2,W3],l), state([0,0,M3],[W1,W2,W3],r)).
next(state([1,M2,1],[W1,W2,W3],l), state([0,M2,0],[W1,W2,W3],r)).
next(state([M1,1,1],[W1,W2,W3],l), state([M1,0,0],[W1,W2,W3],r)).

% dve zeny sa plavia z lava do prava
next(state([M1,M2,M3],[1,1,W3],l), state([M1,M2,M3],[0,0,W3],r)).
next(state([M1,M2,M3],[1,W2,1],l), state([M1,M2,M3],[0,W2,0],r)).
next(state([M1,M2,M3],[W1,1,1],l), state([M1,M2,M3],[W1,0,0],r)).

% muz a jeho zena
next(state([1,M2,M3],[1,W2,W3],l), state([0,M2,M3],[0,W2,W3],r)).
next(state([M1,1,M3],[W1,1,W3],l), state([M1,0,M3],[W1,0,W3],r)).
next(state([M1,M2,1],[W1,W2,1],l), state([M1,M2,0],[W1,W2,0],r)).


% doprogramuj opacne, lodka sa plavi sprava do lava
next(state(Ms,Ws,r), state(Ms1,Ws1,l) ) :- next(state(Ms1,Ws1,l), state(Ms,Ws,r) ).


% doprogramuj, ze na lavom brehu sa nic zle nestane
%bankOk/1
%bankOk(state([Ms,Ws,_]):-

% doprogramuj, rightBank, ktora pre lavy breh vypocita stav na pravom brehu
%rightBank(state([M1,M2,M3],[W1,W2,W3],_),state([?,?,?],[?,?,?],r)):-

% doprogramuj, ze na oboch breho sa nic zle nestane
%banksOk/1

bankOk(state([M1,M2,M3],[W1,W2,W3],_)):-M1=0,W1=1->0 is M2+M3;
                                            (M2=0,W2=1->0 is M1+M3;
                                                (M3=0,W3=1->0 is M1+M2;true
                                                )
                                            ).                        

rightBank(state([M1,M2,M3],[W1,W2,W3],_),state([RM1,RM2,RM3],[RW1,RW2,RW3],_)):-
          RM1 is 1-M1,RM2 is 1-M2,RM3 is 1-M3,
          RW1 is 1-W1,RW2 is 1-W2,RW3 is 1-W3.
                                            
banksOk(Left):-bankOk(Left),
               rightBank(Left,Right),
               bankOk(Right).

cesta(X,X,P,P).
cesta(X,Y,Visited,P):- 
  next(X,Z), 
  not(member(Z,Visited)), banksOk(Z),
  cesta(Z,Y,[Z|Visited],P).
  
  
hladaj(L) :- init(Z), final(K), cesta(Z,K,[Z],P),length(P,L),reverse(P,P1), write(P1).

/*                        
?- hladaj(12).
init        state([1,1,1],[1,1,1],l),
w1,w2->     state([1,1,1],[0,0,1],r),
w2<-        state([1,1,1],[0,1,1],l),
w2,w3->     state([1,1,1],[0,0,0],r),
w1<-        state([1,1,1],[1,0,0],l),
m2,m3->     state([1,0,0],[1,0,0],r),
m2,w2<-     state([1,1,0],[1,1,0],l),
m1,m2->     state([0,0,0],[1,1,0],r),
w3<-        state([0,0,0],[1,1,1],l),
w1,w2->     state([0,0,0],[0,0,1],r),
m3<-        state([0,0,1],[0,0,1],l),
m3,w3->     state([0,0,0],[0,0,0],r)
*/
