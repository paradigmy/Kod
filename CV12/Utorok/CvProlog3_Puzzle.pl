% najdite 10-ciferne cislo, ktore obsahuje 
% tolko 0, kolko je prva cifra
% tolko 1, kolko je druha cifra
% tolko 2, kolko je tretia cifra
%...
% tolko 9, kolko je posledna, desiata cifra


% naivne riesenie (ktore nedobehne), najdite ine...
solve(Riesenie) :- Riesenie = [P0, P1, P2, P3, P4, P5, P6, P7, P8, P9],
    between(0,9,P0),
    between(0,9,P1), check([P0,P1]),
    between(0,9,P2), check([P0,P1, P2]),
    between(0,9,P3), check([P0,P1, P2, P3]),
    between(0,9,P4), check([P0,P1, P2, P3, P4]),
    between(0,9,P5), check([P0,P1, P2, P3, P4, P5]),
    between(0,9,P6), check([P0,P1, P2, P3, P4, P5, P6]),
    between(0,9,P7), check([P0,P1, P2, P3, P4, P5, P6, P7]),
    between(0,9,P8), check([P0,P1, P2, P3, P4, P5, P6, P7, P8]),
    between(0,9,P9), check([P0,P1, P2, P3, P4, P5, P6, P7, P8, P9]),
    count(0, Riesenie, P0),
    count(1, Riesenie, P1),
    count(2, Riesenie, P2),
    count(3, Riesenie, P3),
    count(4, Riesenie, P4),
    count(5, Riesenie, P5),
    count(6, Riesenie, P6),
    count(7, Riesenie, P7),
    count(8, Riesenie, P8),
    count(9, Riesenie, P9).

check(R) :- check2(R, 0, 0).

% sum p(i) <= 10
check1([], _).
check1([X|Xs], S) :- S1 is S+X, S1 =< 10, check1(Xs, S1).

% sum i*p(i) <= 10
check2([], _, _).
check2([X|Xs], I, S) :- S1 is S+X*I, S1 =< 10, I1 is I+1, check2(Xs, I1, S1).


count(_,[], 0).
count(X, [Y|Ys], N) :- (X=Y) -> count(X,Ys,N1), N is N1+1 ; count(X,Ys,N).
    

/*
vymyslite lepsi algoritmus, ktory najde riesenie...
?- solve([6,2,1,0,0,0,1,0,0,0]so).
Yes
*/
