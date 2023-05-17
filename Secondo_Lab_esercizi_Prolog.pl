%secondo laboratorio di Esercizi Prolog
%esercizio 1: rifai la search di due occorrenze consecutive, ma questa volta usando i built-in di list
%VECCHIA VERSIONE
search2(X, cons(X, cons(X, _))).
search2(X, cons(_, Xs)) :- search2(X, Xs).
%NUOVA VERSIONE
%questa volta cerco elemento E: il caso baso è quello dove i primi due elementi siano E, E
%dopo il caso base, vado a cercare il caso generale, dove vedo che la testa non è E, E, perciò continuo a scorrere sulla lista
new_search2(E, [E, E | _ ]).
new_search2(E, [_ | T]) :- new_search2(E, T).
%esercizio 2: rifai la search di due occorrenze con un elemento intermedio tra loro, ma questa volta con built-in
%VECCHIA VERSIONE
search3(X, cons(X, cons(_, cons(X,  _)))).
search3(X, cons(_, Xs)) :- search3(X, Xs).
%NUOVA VERSIONE
new_search3(E, [E, _, E| _]).
new_search3(E, [_ | T]) :- new_search3(E, T).
%esercizio 3: rifai size ma con built-in!
%VECCHIA VERSIONE
size(nil, zero).
size(cons(_, T), s(X)) :- size(T, X).
%NUOVA VERSIONE
new_size([], zero).
new_size([_ | T], s(X)) :- new_size(T, X).
%esercizio 4: rifai sum ma con built-in!
%VECCHIA VERSIONE CHE USAVA SUM
sum(zero, N, N).
sum(s(N), M, s(O)) :- sum(N, M, O).
sum_list(nil, zero).
sum_list(cons(H, T), X) :- sum(H, Xs, X), sum_list(T, Xs).
%NUOVA VERSIONE
%prima devo scorrere lungo la lista degli elementi, ogni volta dichiaro che il risultato corrisponde al valore della testa, più quello precedente che avevamo ottenuto
%es: sum[1,2,3] -> vado dentro sum[2,3] -> sum[3] -> sum[]= 0 -> ora torno indietro e dichiaro che X corrisponde al valore che mi ha restituito (0) sommato alla testa 3
%da qui tornando indietro ogni volta faccio la somma così -> X è la testa 2 di [2,3] sommato al risultato 3 ottenuto da prima -> X è testa 1 di [1,2,3] sommato a 5, il valore ottenuto dalla somma precedente
new_sum([], 0).
new_sum([H | T], X) :- new_sum(T, Xs), X is Xs+H.
%esercizio 5: rifai min-max con built-in!
%VECCHIA VERSIONE CHE USAVA GREATER
old_greater(s(_), zero).
old_greater(s(M), s(N)) :- old_greater(M, N).
min-max(cons(H, T), Min, Max) :- min-max(T, H, H, Min, Max).
min-max(nil, S, M, S, M).
min-max(cons(Tm, L), Tmin, Tmax, S, M) :- old_greater(Tm, Tmax), min-max(L, Tmin, Tm, S, M).
min-max(cons(Tm, L), Tmin, Tmax, S, M) :- old_greater(Tmin, Tm), min-max(L, Tm, Tmax, S, M).
min-max(cons(Tm, L), Tmin, Tmax, S, M) :- old_greater(Tm, Tmin), old_greater(Tmax, Tm), min-max(L, Tmin, Tmax, S, M).
%NUOVA VERSIONE
%devo per forza specificare H e T perchè dobbiamo usarlo, anche perchè dobbiamo inizializzare
new_min-max([H | T], Min, Max) :- new_min-max(T, H, H, Min, Max).
new_min-max([], S, M, S, M).
%la cosa più grossa che cambia è la scrittura, che in questo caso usa < e > poichè non ci serve greater
new_min-max([MaxH | T], Sm, Mm, S, M) :- MaxH>Mm, new_min-max(T, Sm, MaxH, S, M).
new_min-max([MinH | T], Sm, Mm, S, M) :- MinH<Sm, new_min-max(T, MinH, Mm, S, M).
new_min-max([H | T], Sm, Mm, S, M) :- H>Sm, H<Mm, new_min-max(T, Sm, Mm, S, M).
%esercizio 6: fai sublist con i built-in
%VECCHIA VERSIONE
search(X, cons(X, _)).
search(X, cons(_, Xs)) :- search(X, Xs).
sublist(nil, nil).
sublist(nil, cons(_, _)).
sublist(cons(H, T), N) :- search(H, N), sublist(T, N).
%NUOVA VERSIONE
%VERSIONE 1: USO FIND
%find([E |_], E).
%find([_ |T], E) :- find(T ,E).
%uso la funzione find
%new_sublist([], []).
%new_sublist([], [_ | _]).
%new_sublist([H | T], [Hn | Tn]) :- find([Hn | Tn], H), new_sublist(T, [Hn | Tn]).
%VERSIONE 2: USO BUILTIN MEMBER!!!
new_sublist([], []).
new_sublist([], [_ | _]).
%ho messo M al posto di [Hn | Tn] dato che si sa già che M è una lista e non sto facendo confronti tra teste e code di liste (mi basta solo sapere che H sia dentro lista M
new_sublist([H | T], M) :- member(H, M),  new_sublist(T, M).
%esercizio 7: dropAny
dropAny(X, [X | T], T).
dropAny(X, [H | Xs], [H | L]) :- dropAny(X, Xs, L).
%esercizio 8: dropFirst
%uso il precedente dropAny creato e dopo che questo si è risolto, uso il cut per evitare che vengano compiuti i casi successivi
%così facendo, tutti gli altri possibili drop esistenti vengono "tagliati via" dalla soluzione (pruned)
dropFirst(X, L, M) :- dropAny(X, L, M), !.
%esercizio 9: dropLast
dropLast(X, [H | Xs], [H | L]) :- !, dropAny(X, Xs, L).
%esercizio 10: dropAll
dropAll(X, [X | T], T) :- dropAll(X, T, T).
dropAll(X, [H | Xs], [H | L]) :- dropAll(X, Xs, L).