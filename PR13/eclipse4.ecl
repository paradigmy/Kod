:- lib(ic).

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
