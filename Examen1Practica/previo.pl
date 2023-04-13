previo(N, nodo(N, hoja, hoja), nil) :- !.
previo(_, hoja, nil) :- !.
previo(N, nodo(Valor, hoja, hoja), Valor) :- 
    N > Valor, !.
previo(N, nodo(Valor, Izq, _), X) :-
    N < Valor,
    previo(N, Izq, X1), !,
    (X1 \= nil ->
        X = X1;
        X = nil).
previo(N, nodo(Valor, _, Der), X) :-
    N > Valor,
    previo(N, Der, X1),
    (X1 \= nil ->
        X = X1;
        X = Valor).