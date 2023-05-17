/*
    Tarea corta 3 
    Lenguajes de Programación Gr 40
    Escuela de Computación - Instituto Tecnológico de Costa Rica
    I Semestre 2023, Centro Académico de San José
    Profesor: José Rafael Castro Mora
    Estudiante: Adrián Amador Ávila
*/

/* Funcion union de conjuntos */
union([], [], []) :- !.
union([], List2, List2) :- !.
union([H|T], List2, List3) :-
    (member(H, List2)) -> 
        union(T, List2, List3)
    ;
        List3 = [H|Res],
        union(T, List2, Res).

/* Función intersección de conjuntos */
intersec([], [], []) :- !.
intersec([], _, []) :- !.
intersec([H|T], List2, List3) :-
    (member(H, List2)) ->
        List3 = [H|Res], 
        intersec(T, List2, Res)
    ;
        intersec(T, List2, List3).

/* Función diferencia de conjuntos 
    Esta función le resta a la Lista 1, la Lista 2*/
diferencia([], [], []) :- !.
diferencia([], _, []) :- !.
diferencia(List1, [], List1) :- !.
diferencia([H|T], List2, List3) :-
    (member(H, List2)) ->
        diferencia(T, List2, List3)
    ;
        List3 = [H|Res],
        diferencia(T, List2, Res).
