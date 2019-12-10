% najdite 10-ciferne cislo, ktore obsahuje 
% tolko 0, kolko je prva cifra
% tolko 1, kolko je druha cifra
% tolko 2, kolko je tretia cifra
%...
% tolko 9, kolko je posledna, desiata cifra


% naivne riesenie (ktore nedobehne), najdite ine...
solve(Riesenie) :- Riesenie = [P0,P1,P2,P3,P4,P5,P6,P7,P8,P9],
	between(0,9,P0), check([P0]),
	between(0,9,P1), check([P0,P1]),
	between(0,9,P2), check([P0,P1,P2]), 
	between(0,9,P3), check([P0,P1,P2,P3]),
	between(0,9,P4), check([P0,P1,P2,P3,P4]),
	between(0,9,P5), check([P0,P1,P2,P3,P4,P5]),
	between(0,9,P6), check([P0,P1,P2,P3,P4,P5,P6]),
	between(0,9,P7), check([P0,P1,P2,P3,P4,P5,P6,P7]),
	between(0,9,P8), check([P0,P1,P2,P3,P4,P5,P6,P7,P8]),
	between(0,9,P9), check([P0,P1,P2,P3,P4,P5,P6,P7,P8,P9]),
	count(0,Riesenie,P0),
	count(1,Riesenie,P1),
	count(2,Riesenie,P2),
	count(3,Riesenie,P3),
	count(4,Riesenie,P4),
	count(5,Riesenie,P5),
	count(6,Riesenie,P6),
	count(7,Riesenie,P7),
	count(8,Riesenie,P8),
	count(9,Riesenie,P9).

count(_,[],0).
count(X,[Y|Xs],N1):-X=Y->count(X,Xs,N),N1 is N+1;count(X,Xs,N1).

% doprogramujte check, ktory overi, ci z toho este moze byt riesenie
%check(L):-...

/*
vymyslite lepsi algoritmus, ktory najde riesenie...
?- solve([6,2,1,0,0,0,1,0,0,0]).
Yes
*/
