:- lib(ic).

s(Digits) :-
    Digits = [A,B,C,D,E,F,G,H,J],
    Digits :: [0..9],		% obor hodnot
    alldifferent(Digits),	% vsetky prvky zoznamu musia byt rozne
    A #\= 0,			
    H #\= 0,
    F #\= 0,
    B #\= 0,
    E #\= 0,
    G #\= 0,
    (100*A + 10*C + H) - (10*H + J)	#= 100*F + 10*D + H,
    (B) * (10*A + E)	#= 100*E + 10*H + B,
    (10*B + A) + (10*G + D)	#= 100*E + 10*E + F,
    (10*B + A) * B	#= 100*A + 10*C + H,
    (10*A + E) + (10*G +D)	#= 10*H + J,
	(100*E + 10*H + B) + (100*E + 10*E +F)	#= 100*F + 10*D + H,
    labeling(Digits),		% generovanie moznosti
    writeSolution(Digits),
	fail.	% vypis riesenia
    
writeSolution([A,B,C,D,E,F,G,H,J]) :-    
                write(A),write(C),write(H), write('-'),write(H),write(J),write('='),write(F),write(D),write(H),nl,
    write('  '),write(B),write('*'),write(A),write(E),write('='),write(E),write(H),write(B),nl,
    write(' '),write(B),write(A),write('+'),write(G),write(D),write('='),write(E),write(E),write(F),nl.
