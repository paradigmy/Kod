%--- +hranica Ukraine-Romania, opravila DasaK
mapa([
            susedia(portugal,Portugal,[Spain]),
            susedia(spain,Spain,[Portugal,Andorra,France]),
            susedia(andorra,Andorra,[Spain,France]),
            susedia(france,France,[Spain,Andorra,Monaco,Italy,Switzerland,Germany,Luxembourg,Belgium,United_kingdom]),
            susedia(united_kingdom,United_kingdom,[France,Belgium,Netherlands,Denmark,Norway,Iceland,Ireland]),
            susedia(ireland,Ireland,[United_kingdom,Iceland]),
            susedia(monaco,Monaco,[France]),
            susedia(italy,Italy,[France,Greece,Albania,Montenegro,Croatia,Slovenia,Austria,Switzerland,San_marino]),
            susedia(san_marino,San_marino,[Italy]),
            susedia(switzerland,Switzerland,[France,Italy,Austria,Germany,Liechtenstein]),
            susedia(liechtenstein,Liechtenstein,[Switzerland,Austria]),
            susedia(germany,Germany,[France,Switzerland,Austria,Czech_republic,Poland,Sweden,Denmark,Netherlands,Belgium,Luxembourg]),
            susedia(belgium,Belgium,[France,Luxembourg,Germany,Netherlands]),
            susedia(netherlands,Netherlands,[Belgium,Germany,United_kingdom]),
            susedia(luxembourg,Luxembourg,[France,Germany,Belgium]),
            susedia(austria,Austria,[Italy,Slovenia,Hungary,Slovakia,Czech_republic,Germany,Switzerland,Liechtenstein]),
            susedia(slovenia,Slovenia,[Italy,Croatia,Hungary,Austria]),
            susedia(croatia,Croatia,[Italy,Montenegro,Bosnia,Serbia,Hungary,Slovenia]),
            susedia(bosnia,Bosnia,[Croatia,Montenegro,Serbia]),
            susedia(montenegro,Montenegro,[Croatia,Italy,Albania,Serbia,Bosnia]),
            susedia(albania,Albania,[Italy,Greece,Macedonia,Serbia,Montenegro]),
            susedia(greece,Greece,[Italy,Cyprus,Bulgaria,Macedonia,Albania]),
            susedia(cyprus,Cyprus,[Greece]),
            susedia(macedonia,Macedonia,[Albania,Greece,Bulgaria,Serbia]),
            susedia(bulgaria,Bulgaria,[Macedonia,Greece,Romania,Serbia]),
            susedia(serbia,Serbia,[Montenegro,Albania,Macedonia,Bulgaria,Romania,Hungary,Croatia,Bosnia]),
            susedia(romania,Romania,[Serbia,Bulgaria,Hungary,Moldova, Ukraine]),
            susedia(hungary,Hungary,[Slovenia,Croatia,Serbia,Romania,Slovakia,Austria,Ukraine]),
            susedia(slovakia,Slovakia,[Austria,Hungary,Poland,Czech_republic,Ukraine]),
            susedia(czech_republic,Czech_republic,[Germany,Austria,Slovakia,Poland]),
            susedia(poland,Poland,[Germany,Czech_republic,Slovakia,Sweden,Ukraine,Lithuania,Belarus]),
            susedia(denmark,Denmark,[United_kingdom,Germany,Sweden,Norway]),
            susedia(sweden,Sweden,[Norway,Denmark,Germany,Poland,Finland]),
            susedia(norway,Norway,[United_kingdom,Denmark,Sweden,Finland,Iceland]),
            susedia(finland,Finland,[Sweden,Norway]),
            susedia(iceland,Iceland,[Ireland,United_kingdom,Norway]),
            susedia(ukraine,Ukraine,[Slovakia,Moldova,Poland,Belarus,Hungary, Romania]),
            susedia(moldova,Moldova,[Ukraine,Romania]),
            susedia(belarus,Belarus,[Poland,Ukraine,Lithuania,Latvia]),
            susedia(lithuania,Lithuania,[Poland,Belarus,Latvia]),
            susedia(estonia,Estonia,[Latvia]),
            susedia(latvia,Latvia,[Estonia,Belarus,Lithuania])
        ]).



colors([green,red,blue,yellow]).

members([],_).
members([X|Xs],Ys):-member(X,Ys), members(Xs,Ys).

colorMap([],_).
colorMap([susedia(_,Color,Neighbors)|Xs],Colors) :-
	delete(Color,Colors,Colors1),
	members(Neighbors,Colors1),
	colorMap(Xs,Colors).

colorit :- mapa(M), colors(Cols), colorMap(M,Cols), write(M),nl.

