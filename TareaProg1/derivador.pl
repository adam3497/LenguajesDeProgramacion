/* Tarea Programada 1 - Lenguajes de Programación
   Desarrollo de un derivador en Prolog
   Estudiante: Adrián Amador Ávila
*/

/* Función principal que hace uso de las demás funciones para simplificar la expresión */
derivar(A,B,R) :-
    d(A,B,Df), print(Df),
    tolist(Df, Ldf), print(Ldf),
    reduce(Ldf, R).

/* Caso 1: derivar X con respecto a X */
d(X, X, 1) :- !.

/* Caso 2: derivar una constante K debería dar 0 */
d(K,X,0) :- atom(K), K \= X, !. 
d(N,_,0) :- number(N), !.

/* Caso 3: la derivada de la suma y resta[f(x) +- g(x)]' = f'(x) +- g'(x) */
d(Fx+Gx, X, Dfx+Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

d(Fx-Gx, X, Dfx-Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

/* Caso 4: la derivada de la multiplicación: (f(x)*g(x))' = f'(x)g(x) + f(x)g'(x) */
d(Fx*Gx, X, Dfx*Gx + Fx*Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

/* Caso 5: la derivada de una potencia: (x^n)' = n*x^(n-1) */
d(X^N, X, N*X^N1) :-
    number(N), !,
    N1 is N-1.
d(X^N, X, N*X^N1) :-
    number(N), !,
    N1 = N-1.

/* Caso 5: la derivada de la división: (f(x)/g(x))' = (f'(x)g(x) - f(x)g'(x))/f^2(x) */
d(Fx/Gx, X, (Dfx*Gx - Fx*Dgx)/Fxsqrt) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx),
    Fxsqrt = Fx^2.

/* Caso 6: la derivada del sen(x) con cadena: (sin(f(x)))' = cos(f(x))*f'(x) */
d(sin(Fx), X, cos(Fx)*Dfx) :-
    !,
    d(Fx, X, Dfx).

/* Caso 7: la derivada del cos(x) con cadena: (cos(f(x)))' = -sen(f(x))*f'(x) */
d(cos(Fx), X, -sin(Fx)*Dfx) :-
    !,
    d(Fx, X, Dfx).

/* Caso 8: la derivada del logarítmo: log'(f(x)) = (1/f(x))*f'(x) */
d(log(Fx), X, (1/Fx)*Dfx) :-
    !,
    d(Fx, X, Dfx).

/* Funciones para convertir expresiones en listas en preorden */

/* tolist(expression -> list) */
tolist(X, X) :- atom(X), !.
tolist(N, N) :- number(N), !.

/* tolist de expresiones con suma */
tolist(A+B, [+,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

/* tolist de expresiones con resta */
tolist(A-B, [-,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

/* tolist de expresiones con multiplicación */
tolist(A*B, [*,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

/* tolist de expresiones con división */
tolist(A/B, [/,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

/* Funciones para reducir la salida de tolist */
simple(A) :- atom(A), !.
simple(A) :- number(A), !.

/* Reducción de la suma */
reduce([+,A,B], [+,A,B]) :-
    simple(A),
    simple(B). 

reduce([+,A,B], [+|Parameters]) :-
    !,
    reduce(A, LA),
    reduce(B, LB),
    ((member(+,LA)) ->
        combine(LA, LB, Parameters), print(Parameters)
    ;
        Parameters = [LA,LB]).

/* Reducción de la resta */
reduce([-,A,B], [-,A,B]) :-
    simple(A),
    simple(B).

reduce([-,A,B], [-|Parameters]) :-
    !,
    reduce(A, LA), print(LA) ,
    reduce(B, LB), print(LB) ,
    ((member(-,LA)) ->
        combine(LA, LB, Parameters), print(Parameters)
    ;
        Parameters = [LA,LB]).

/* Reducción de la multiplicación */
reduce([*,A,B], [*,A,B]) :-
    simple(A),
    simple(B).

reduce([*,A,B], [*|Parameters]) :-
    !,
    reduce(A, LA),
    reduce(B, LB),
    ((member(*,LA)) ->
        combine(LA, LB, Parameters), print(Parameters)
    ;
        Parameters = [LA,LB]).

/* Reducción de la división */
reduce([/,A,B], [/,A,B]) :-
    simple(A),
    simple(B).

reduce([/,A,B], [/|Parameters]) :-
    !,
    reduce(A, LA),
    reduce(B, LB),
    ((member('/',LA)) ->
        combine(LA, LB, Parameters), print(Parameters)
    ;
        Parameters = [LA,LB]).

reduce(X, X) :- !.

/* Funciones para combinar listas con mismo operador */

/* Combine con suma */
combine([+|A], [+|B], Result) :-
    !,
    append(A,B, Result).
combine([+|A],B, [B|A]) :- !.
combine(A,[+|B], [A|B]) :- !.

/* Combine con resta */
combine([-|A],[-|B], Result) :-
    !,
    append(A,B, Result).
combine([-|A],B, [B|A]) :- !.
combine(A,[-|B], [A|B]) :- !.

/* Combine con multiplicación */
combine([*|A],[*|B], Result) :-
    !,
    append(A,B, Result).
combine([*|A],B, [B|A]) :- !.
combine(A,[*|B], [A|B]) :- !.

/* Combine con división */
combine([/|A], [/|B], Result) :-
    !,
    append(A,B, Result).
combine([/|A],B, [B|A]) :- !.
combine(A,[/|B], [A|B]) :- !.

/* Combinación de dos elementos en general */
combine(A,B,[A,B]) :- !.

/* Funciones para simplificar la lista en preorden */
simplify([+,A,B], Result) :-
    number(A),
    number(B),
    Result is A+B.

/* Funciones de suma de elementos de una lista */
sumlist([X],X) :- !.
sumlist([H|T], S) :- 
    sum(T,X), 
    S is H+X.

