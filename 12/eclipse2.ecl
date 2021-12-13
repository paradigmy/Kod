:- lib(ic).

sendmore(Digits) :-
    Digits = [S,E,N,D,M,O,R,Y],
    Digits :: [0..9],		% obor hodnot
    alldifferent(Digits),	% vsetky prvky zoznamu musia byt rozne
    S #\= 0,			
    M #\= 0,
    (1000*S + 100*E + 10*N + D) + (1000*M + 100*O + 10*R + E)
    	#= 10000*M + 1000*O + 100*N + 10*E + Y,
    labeling(Digits),		% generovanie moznosti
    writeSolution(Digits).	% vypis riesenia
    
writeSolution([S,E,N,D,M,O,R,Y]) :-    
    write(' '),write(S),write(E),write(N),write(D), nl, 
    write('+'),write(M),write(O),write(R),write(E), nl, 
    write(M),  write(O),write(N),write(E),write(Y),nl.  
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uplneMagicke(Digits) :-
    Digits = [_,_,_,_,_,_,_,_,_],
    Digits :: [1..9],		% obor hodnot
    alldifferent(Digits),	% vsetky prvky zoznamu musia byt rozne
    magicke(Digits),
    labeling(Digits).		% generovanie moznosti

magicke(X):-magicke(X,0,0).

magicke([],_,_).
magicke([X|Xs],Cislo,N) :-  
	Cislo1 #= 10*Cislo+X, 
	N1 is N+1,
	Cislo1 / N1 #= _,
	magicke(Xs,Cislo1,N1).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

countTrue([],0).
countTrue([C|Cs],N) :- countTrue(Cs,N1),
			   (C -> N is N1+1
			    ; 
			    N is N1).

mm([C1,C2,C3,C4],[Q1,Q2,Q3,Q4],X,Y) :-
    C = [C1,C2,C3,C4],
	countTrue([member(Q1,C),member(Q2,C),member(Q3,C),member(Q4,C)],X),
	countTrue([C1=Q1,C2=Q2,C3=Q3,C4=Q4],Y).

%-- findMM

findMM(Qs, Code) :- 
	Code = [_,_,_,_], 
	Code :: [1..6],
	alldifferent(Code),
	labeling(Code),
	checkMM(Qs,Code).

checkMM([],_).
checkMM([dotaz(Q,X,Y)|Qs],Code) :-
	mm(Q,Code,X,Y), checkMM(Qs,Code).

%-----------------------------------------------------------

queens(Board) :-
	%Size = 8,
	Size = 20,
	dim(Board, [Size]),
	Board[1..Size] :: 1..Size,
	(for(I,1,Size), param(Board,Size) do
	  (for(J,I+1,Size), param(Board,I) do
	     Board[I] #\= Board[J],
	     Board[I] #\= Board[J]+J-I,
	     Board[I] #\= Board[J]+I-J
	   )
	),
	labeling(Board),
	write(Board), nl.
	
%-----------------------------------------------------------

queens2:-queens2(8,[]). 
queens2(N,Qs):-N==0->labeling(Qs),writeln(Qs),fail
	       ;
	       Q::1..8, safe(1,Q,Qs),N1 is N-1,queens2(N1,[Q|Qs]).

safe(_,_,[]). 
safe(I,B,[A|Qs]):-I1 is I+1,
		  B+I #\= A, 
		  B   #\= A, 
		  B-I #\= A, 
		  safe(I1,B,Qs).

%--------------------------------

subseq([X|Xs],[X|Ys]):-subseq(Xs,Ys).
subseq(Xs,[_|Ys]) :- subseq(Xs,Ys).
subseq([],_).

isOk1(Xs):- not(subseq([0,1,2],Xs)), not(subseq([3,4,5], Xs)), not(subseq([6,7,8], Xs)),
    	    not(subseq([0,3,6], Xs)), not(subseq([1,4,7], Xs)), not(subseq([2,5,8], Xs)),
    	    not(subseq([0,4,8], Xs)), not(subseq([2,4,6], Xs)).

isOk(Xs):- 
	    Xs[1]+Xs[2]+Xs[3] #<3,
	    Xs[4]+Xs[5]+Xs[6] #<3,
	    Xs[7]+Xs[8]+Xs[9] #< 3,
	    
	    Xs[1]+Xs[4]+Xs[7] #<3,
	    Xs[2]+Xs[5]+Xs[8] #<3,
	    Xs[3]+Xs[6]+Xs[9] #<3,
	    
	    Xs[1]+Xs[5]+Xs[9] #<3,
	    Xs[3]+Xs[5]+Xs[7] #<3.

isOk2(Xs):- 
	(for(I,0,2), param(Xs) do
	    Xs[1+3*I]+Xs[2+3*I]+Xs[3+3*I] #<3
	),
	(for(I,0,2), param(Xs) do
	    Xs[1+I]+Xs[4+I]+Xs[7+I] #<3
	),
	Xs[1]+Xs[5]+Xs[9] #<3,
	Xs[3]+Xs[5]+Xs[7] #<3.
   	    	   
threeXthree(Cs) :-	   
	dim(Cs,[9]),
	Cs::0..1,
	% 6 #= Cs[1] + Cs[2] + Cs[3] + Cs[4] + Cs[5] + Cs[6] + Cs[7] + Cs[8] + Cs[9],
	6 #= sum(Cs[1..9]), 
	isOk2(Cs), 
	labeling(Cs),	 
	writeln(Cs).	   
  
  
  
  
  %-------------------------------------------------------------------------------
  susedia(N,Z,P,F,C):-  
    N = [Brit,Sved,Dan,Nor,Nemec],  		N :: 1..5,  	    alldifferent(N),  
    Z = [Pes,Vtak,Macka,Kon,Rybicky],  		Z :: 1..5,      	alldifferent(Z),  
    P = [Caj,Kava,Mlieko,Pivo,Vodu],      	P :: 1..5,      	alldifferent(P),  
    F = [Pallmall,Dunhill,Blend,Bluemaster,Prince],   F :: 1..5,      alldifferent(F),  
    C = [Cerveny,Biely,Zeleny,Zlty,Modry],  C :: 1..5,      	alldifferent(C),  
  
    Brit #= Cerveny,  	% Brit býva v cervenom dome.
    Sved #= Pes,  		% Švéd chová psa.
    Dan #= Caj,  		% Dán pije caj.
    Biely #= Zeleny+1,  % Zelený dom stojí hned nalavo od bieleho.
    Zeleny #= Kava,  	% Majitel zeleného domu pije kávu.
    Pallmall #= Vtak,   % Ten, kto fajcí PallMall, chová vtáka.
    Zlty #= Dunhill,  	% Majitel žltého domu fajcí Dunhill.
    Mlieko #= 3,  		% Clovek z prostredného domu pije mlieko.
    Nor #= 1,  			% Nór býva v prvom dome.
    abs(Blend-Macka) #= 1,  % Ten, kto fajcí Blend, býva vedla toho, kto chová macku.
    abs(Kon-Dunhill) #= 1,  % Ten, kto chová kone, býva vedla toho, kto fajcí Dunhill.
    Bluemaster #= Pivo, % Ten, kto fajcí Blue Master, pije pivo.
    Nemec #= Prince,  	% Nemec fajcí Prince.
    abs(Nor-Modry) #= 1,% Nór býva vedla modrého domu.
    abs(Blend-Vodu) #=1,  % Ten, kto fajcí Blend, má suseda, ktorý pije vodu.
  
    labeling(N),  	labeling(C),	labeling(Z),     labeling(P),	labeling(F).
