
%naprogramuj K prvkove variacie s opakovanim mnoziny Base
% vso(K, Base, V)

/*
setof(K, vso(3,[a,b,c,d,e], K), List), length(List,Len).
125 = 5*5*5
bagof(K, vso(3,[a,b,c,d,e], K), List), length(List,Len).
125 = 5*5*5
*/

%naprogramuj K prvkove variacie bez opakovania mnoziny Base
%vbo(K, Base, V)

/*
setof(K, vbo(3,[a,b,c,d,e], K), List), length(List,Len).
60 = 5*4*3
bagof(K, vbo(3,[a,b,c,d,e], K), List), length(List,Len).
60 = 5*4*3
*/


%naprogramuj K prvkove kombinacie bez opakovania mnoziny Base
%kbo(K, Base, V)

/*
n nad k, teda 5 nad 2  je 10...
bagof(K, kbo(2,[a,b,c,d,e], K), List), length(List, Len).
10
setof(K, kbo(2,[a,b,c,d,e], K), List), length(List, Len).
10
*/

%naprogramuj K prvkove kombinacie s opakovani mnoziny Base
%kso(K, Base, V)

/*
n+k-1 nad k = n+k-1 nad n-1 =  5+3-1 nad 3, co je 7 nad 3 =  7*6*5/6 = 35
?- bagof(K, kso(3,[a,b,c,d,e], K), List), length(List, Len).
35
?- setof(K, kso(3,[a,b,c,d,e], K), List), length(List, Len).
35
*/
