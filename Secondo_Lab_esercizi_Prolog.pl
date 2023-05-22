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
%l'ordine invertito funziona, ma non comprendo per bene perchè sia necessario (ho continuato a fare prove su prove, il risultato ottenuto è stato fatto tramite brute force)
dropLast(X, [H | Xs], [H | L]) :- dropLast(X, Xs, L), !.
dropLast(X, [X | T], T).
%esercizio 10: dropAll
%quando sono nel caso in cui ho ancora una lista con elementi , ma sono arrivato a quello che desidero togliere, prima passo alla drop successiva, e in seguito con il cut tolgo altre strade successive
dropAll(X, [H], [H]).
dropAll(X, [X | T], L) :- dropAll(X, T, L), !.
dropAll(X, [H | Xs], [H | L]) :- dropAll(X, Xs, L).
%esercizio 11: fromList
%crea un grafico da una lista
fromList([_], []) .
fromList([H1, H2 | T], [e(H1, H2) | L]) :- fromList([H2 | T], L).
%esercizio 12: fromCircleList
%creo il caso base in cui ho solo una lista con un singolo elemento H, che restituisce un lista con un solo elemento e(H, H)
fromCircleList([H], [e(H, H)]).
%da qui creo una versione con un supporter, che tiene sempre in mente il primissimo elemento della lista appena chiamo questa funzione
fromCircleList([H1, H2 | T], [e(H1, H2) | L]) :- fromCircleList([H2 | T], H1, L).
%qui sotto abbiamo casi: il primo che ho scritto è quando siamo arrivati in fondo alla lista di N elementi, quindi aggiungiamo un ultimo e[H, Primissimo Elemento della lista]
%il secondo caso è quando sto ancora scorrendo la lista, perciò inserisco nella lista da restituire la coppia e[H1, H2], per poi passare all'elemento successivo
fromCircleList([H], H3, [e(H, H3)]).
fromCircleList([H1, H2 | T], H3, [e(H1, H2) | L]) :- fromCircleList([H2 | T], H3, L).
%esercizio 13: outDegree
%il caso base verifica quando sono arrivato alla fine della lista, in tal caso il numero di "edges" che portano al nodo N è pari a 0
outDegree([], N, 0).
%nei due casi successivi, verifico che a partire dal nodo che sto andando a cercare, l'elemento in testa sia o meno uno degli edges (lo verifico se il valore H che controllo e il primo valore
%di e(H, H2) siano uguali, in tal caso scorro la riga e dirò che il numero da restituire N corrisponderà al numero ottenuto dal lavoro fatto sul resto della lista aumentato di 1
outDegree([e(H1, H2) | T], H1, N) :- outDegree(T, H1, N2), N is N2 + 1.
outDegree([e(H1, H2) | T], H3, N) :- outDegree(T, H3, N2), N is N2.
%esercizio 14: dropNode
dropNode(G, N, OG) :- dropAll(e(N, _), G, G2), dropAll(e(_, N), G2, OG).
%esercizio 15: reaching
%a partire da un nodo, devo vedere quanti diversi altri nodi posso raggiungere con un solo passo
reaching([], N, []).
reaching([e(N, H) | T], N, [H | L]) :- reaching(T, N, L), !.
reaching([e(H1, H2) | T], N, L) :- reaching(T, N, L), !.
%esercizio 16: nodes, l'inverso di fromList
%fromList([_], []) .
%fromList([H1, H2 | T], [e(H1, H2) | L]) :- fromList([H2 | T], L).
nodes([], []).
nodes([e(H1, H2) | T], [H2 | L]) :- member(H1, L), nodes(T, L), !.
%nodes([e(H1, H2) | T], [H1 | L]) :- member(H2, L), nodes(T, L), !.
%nodes([e(H1, H2) | T], [H2 | L]) :- member(H1, L), nodes(T, L), !.
%esercizio 17: anyPath
%trova tutti i possibili path che vanno da un nodo H1 fino ad un nodo H2