:- lib(ic).

solve(All) :-
    All = [Limo, Burger, Pivo],
    All :: [-3000..3000],
    3*Limo #= 30,
    Limo + 2*Burger #= 20,
    Burger + 4*Pivo #= 9,
    labeling(All),		% generovanie moznosti
    writeln(All),	% vypis riesenia
    writeln(Burger+Pivo*Limo).	% vypis riesenia
    
