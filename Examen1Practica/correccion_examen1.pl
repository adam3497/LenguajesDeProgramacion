aplaste([], []).

aplaste([H|T], FlatList) :-
    is_list(H),
    aplaste(H, FlatH),
    aplaste(T, FlatT),
    append(FlatH, FlatT, FlatList).

aplaste([H|T], [H|FlatT]) :-
    \+ is_list(H),
    aplaste(T, FlatT).


sublistas([], []).
sublistas([X|L], [X|S]) :-
    sublistas(L, S).
sublistas(L, [_|S]) :-
    sublistas(L, S).
