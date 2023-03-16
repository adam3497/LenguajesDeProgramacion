/* Tarea Programada 1 - Lenguajes de Programación
   Desarrollo de un derivador en Prolog
   Estudiante: Adrián Amador Ávila
*/

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

/* Caso 6: la derivada del sen(x): (sin(x))' = cos(x) */
d(sin(Fx), X, cos(Fx)*Dfx) :-
    !,
    d(Fx, X, Dfx).

/* Caso 7: la derivada del cos(x): (cos(x))' = -sen(x) */
d(cos(Fx), X, -sin(Fx)*Dfx) :-
    !,
    d(Fx, X, Dfx).