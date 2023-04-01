/* Tarea Programada 1 - Lenguajes de Programación
   Desarrollo de un derivador en Prolog
   Estudiante: Adrián Amador Ávila
*/

/* Función principal que hace uso de las demás funciones para simplificar la expresión */
derivar(A, B, 0) :- tolist(A, La), not(member(B,La)), !.
derivar(A,B,R) :-
    !,
    d(A,B,Df),
    derivar_aux(Df, R1),
    derivar_aux(R1, R), !.
    

derivar_aux(Expression, Resultexp) :-
    tolist(Expression, Ldf),
    reduce(Ldf, Rdf),
    to_expression(Rdf, Resultexp).

/* Caso 1: derivar X con respecto a X */
d(X, X, 1) :- !.

/* Caso 2: derivar una constante K debería dar 0 */
d(K,X,0) :- atom(K), K \= X, !. 
d(N,_,0) :- number(N), !.

/* Caso 3: la derivada de la suma y resta[f(x) +- g(x)]' = f'(x) +- g'(x) */
d(N1+N2, _, 0) :-
    number(N1),number(N2),
    !.
d(N1*Fx+N2*Fx, X, N3*Dfx) :-
    number(N1),number(N2),
    d(Fx, X, Dfx),
    N3 is N1+N2.
d(Fx+Gx, X, Dfx+Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

d(N1-N2, _, 0) :-
    number(N1),number(N2),
    !.
d(N1*Fx-N2*Fx, X, N3*Dfx) :-
    number(N1),number(N2),
    d(Fx, X, Dfx),
    N3 is N1-N2.
d(Fx-Gx, X, Dfx-Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

/* Caso 4: la derivada de la multiplicación: (f(x)*g(x))' = f'(x)g(x) + f(x)g'(x) */
d(Fx*Gx, _, 0) :- 
    number(Fx),number(Gx),
    !.
d(Fx*Gx, X, Dfx*Gx + Fx*Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

/* Caso 5: la derivada de una potencia: (x^n)' = n*x^(n-1) */
d(X^N, X, N*X^N1) :-
    number(N), !,
    N1 is N-1.
d(X^N, X, N*X^N1) :-
    not(number(N)), !,
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
tolist(X, X) :- X = cos(_), !.
tolist(X, X) :- X = -cos(_), !.
tolist(X, X) :- X = sin(_), !.
tolist(X, X) :- X = -sin(_), !.

/* tolist de expresiones con suma */
tolist((A)+(B), [+,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

/* tolist de expresiones con resta */
tolist((A)-(B), [-,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

/* tolist de expresiones con multiplicación */
tolist((A)*(B), [*,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

/* tolist de expresiones con división */
tolist((A)/(B), [/,LA,LB]) :-
    tolist(A, LA),
    tolist(B, LB).

tolist(A^F, [^,LA,LF]) :-
    tolist(A, LA),
    tolist(F, LF).

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
        combine(LA, LB, Parameters)
    ;
        Parameters = [LA,LB]).

/* Reducción de la resta */
reduce([-,A,B], [-,A,B]) :-
    simple(A),
    simple(B).

reduce([-,A,B], [-|Parameters]) :-
    !,
    reduce(A, LA),
    reduce(B, LB),
    ((member(-,LA)) ->
        combine(LA, LB, Parameters)
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
        combine(LA, LB, Parameters)
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
        combine(LA, LB, Parameters)
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

/* Función para verificar si A es trigonométrico */
istrig(A) :-
    not(atom(A)),
    not(number(A)),
    (A = cos(_); A = sin(_); A = -cos(_); A = -sin(_)),
    !.

/* Funciones para pasar una lista a una expresión */
to_expression([H|T], Result) :-
    to_expression_aux(T, H, Result).

to_expression_aux(L, Operator, Expression) :-
    Operator = '+', !,
    sum_expression(L, Expression).

to_expression_aux(L, Operator, Expression) :-
    Operator = '-', !,
    reverse(L, Rl),
    sub_expression(Rl, Expression).

to_expression_aux(L, Operator, Expression) :-
    Operator = '*', !,
    times_expression(L, Expression).

to_expression_aux(L, Operator, Expression) :-
    Operator = '/', !,
    div_expression(L, Expression).

to_expression_aux(L, Operator, Expression) :-
    Operator = '^', !,
    pow_expression(L, Expression).

/* Funciones para encontrar la cantidad de elementos iguales al elemento dentro de la lista */
elements_in([], _, 0):- !.
elements_in([Element], Element, 1):- !.
elements_in([H|T], Element, Amount):-
    (Element = H),
    elements_in(T, Element, Amount1), 
    Amount is Amount1+1.
elements_in([H|T], Element, Amount):-
    Element \= H,
    elements_in(T, Element, Amount).

/* Funciones para simplificar elementos repetidos */
simplest_sum(A, K, X) :-
    number(A), !,
    K1 is K+1,
    X is K1*A.

simplest_sum(A, K, X) :-
    (atom(A);not(number(A))),
    K \= 0, !,
    K1 is K+1,
    X = K1*A.

simplest_sum(A, K, X) :-
    (atom(A);not(number(A))),
    K = 0, !,
    X = A.

solve_sub(A, 1, A) :- (atom(A); number(A); istrig(A)), !.
solve_sub(A, K, X) :-
    number(A),
    K1 is K-1,
    solve_sub(A, K1, X1),
    X is X1-A, !.

solve_sub(A, K, X) :-
    (atom(A);istrig(A)),not(number(A)),
    K1 is K-1,
    solve_sub(A, K1, X1),
    ((A = X1, -Y \= X1, -Y \= A, !, X = 0);
     (X1 = 0, !, X = -A);
     (X1 \= 0, -Y = X1, Y = A, !, X = -2*A);
     (X1 \= 0, -Y = X1, -Y = A, !, X = 0);
     (X1 \= 0, N*Y = X1, -Y = A, !, N1 is N+1, X = N1*Y);
     (X1 \= 0, N*Y = X1, Y = A, !, N1 is N-1, X = N1*Y);
     (X1 \= 0, N*Y = A, -Y = X1, !, N1 is N-1, X = N1*Y);
     (X1 \= 0, N1*Y = X1, N2*Y = A, !, N3 is N1-N2, X = N3*Y);
     (X = X1)
    ), !.

simplest_sub(A, K, X) :-
    number(A), !,
    K \= 0,
    solve_sub(A, K, X).

simplest_sub(A, K, X) :-
    (atom(A);istrig(A);not(number(A))),
    K \= 0, !,
    solve_sub(A, K, X).

simplest_sub(A, K, X) :-
    (atom(A);number(A);istrig(A)),
    K = 0, !,
    X = A.

simplest_times(A, K, X) :-
    number(A), !,
    K1 is K+1,
    X is A^K1.

simplest_times(A, K, X) :-
    (atom(A);istrig(A);not(number(A))),
    K \= 0, !,
    K1 is K+1,
    X = A^K1.

simplest_times(A, K, X) :-
    (atom(A);istrig(A);not(number(A))),
    K = 0, !,
    X = A.

solve_div(A, 0, A) :- !.
solve_div(A, K, R) :-
    number(A),
    K1 is K-1,
    solve_div(A, K1, R1),
    R is R1/A, !.

solve_div(A, K, R) :-
    (atom(A);istrig(A),not(number(A))),
    K1 is K-1,
    solve_div(A, K1, R1),
    ((R1 = A, R = 1);
     (R1 \= A, R = R1/A)
    ), !.

simplest_div(A, K, X) :-
    number(A), !,
    solve_div(A, K, X).

simplest_div(A, 0, A) :- 
    (atom(A);number(A);istrig(A)), !.

simplest_div(A, K, X) :-
    (atom(A);istrig(A);not(number(A))),
    K \= 0, !,
    solve_div(A, K, X).

/* Funciones para transformar y simplificar una lista de suma en expresión */
pow_expression([], 0) :- !.
pow_expression([A], A) :- !.
pow_expression([X,N], Pot) :-
    number(X),number(N), !,
    Pot is X^N.
pow_expression([X,N], Pot) :-
    (atom(X);istrig(X);not(is_list(X))), number(N), !,
    ((N = 1) ->
        Pot = X;
        Pot = X^N
    ).

sum_expression([], 0) :- !.
sum_expression([A], A) :- !.
sum_expression(L, Expression) :-
    sum_list(L, L1),
    sum_expression_aux(L1, Expression), !.

sum_expression_aux(A, A) :- (number(A);atom(A);istrig(A)), !.
sum_expression_aux([],0) :- !.
sum_expression_aux([H|T], Expression) :-
    (number(H);atom(H);istrig(H);(compound(H),not(is_list(H)))),
    elements_in(T, H, Amount),
    delete(T, H, Td),
    simplest_sum(H, Amount, Sh),
    sum_expression_aux(Td, Expression1),
    ((Expression1 \= 0) ->
        Expression = Sh + Expression1;
        Expression = Sh
    ), !.

sum_expression_aux([H|T], Expression) :-
    is_list(H),
    reduce(H, Rh),
    to_expression(Rh, Expression1),
    sum_expression_aux(T, Expression2),
    ((Expression2 \= 0) ->
        Expression = Expression1 + Expression2;
        Expression = Expression1
    ), !.

/* Funciones para transformar y simplificar una lista de división en expresión */
div_expression([], 1) :- !.
div_expression([A], A) :- !.
div_expression(L, Expression) :-
    div_list(L, L1),
    ((number(L1)) -> 
        Expression = L1;
        div_expression_aux(L1, Expression)),
    !.

div_expression_aux([], 1) :- !.
div_expression_aux(A, A) :- (number(A);atom(A);istrig(A)), !.
div_expression_aux([H|T], Expression) :-
    (number(H);atom(H);istrig(H);(compound(H),not(is_list(H)))),
    elements_in(T, H, Amount),
    delete(T, H, Td),
    simplest_div(H, Amount, Sh),
    div_expression_aux(Td, Expression1),
    ((Expression1 \= 1) ->
        Expression = Sh / Expression1;
        Expression = Sh
    ), !.

div_expression_aux([H|T], Expression) :-
    is_list(H),
    reduce(H, Rh),
    to_expression(Rh, Expression1),
    div_expression_aux(T, Expression2),
    ((Expression2 \= 1) ->
        Expression = Expression1 / Expression2;
        Expression = Expression1
    ), !.

/* Funciones para transformar y simplificar una lista de suma en expresión */
sub_expression([], 0) :- !.
sub_expression([A], A) :- !.
sub_expression(L, Expression) :-
    sub_list(L, L1),
    sub_expression_aux(L1, Expression), !.

sub_expression_aux([], 0) :- !.
sub_expression_aux(A, A) :- (number(A);atom(A);istrig(A)), !.
sub_expression_aux([H|T], Expression) :-
    (number(H);atom(H);istrig(H);(compound(H),not(is_list(H)))),
    elements_in([H|T], H, Amount),
    delete(T, H, Td),
    simplest_sub(H, Amount, Sh),
    sub_expression_aux(Td, Expression1),
    ((Expression1 \= 0) ->
        Expression = Sh - Expression1;
        Expression = Sh
    ), !.

sub_expression_aux([H|T], Expression) :-
    is_list(H),
    reduce(H, Rh),
    to_expression(Rh, Expression1),
    sub_expression_aux(T, Expression2),
    ((Expression2 \= 0) ->
        Expression = Expression1 - Expression2;
        Expression = Expression1
    ), !.

/* Funciones para transformar y simplificar una lista de multiplicación en expresión  */
times_expression([], 1) :- !.
times_expression([A], A) :- !.
times_expression(L, Expression) :-
    times_list(L, L1),
    ((number(L1)) -> 
        Expression = L1;
        times_expression_aux(L1, Expression)),
    !.

times_expression_aux([], 1) :- !.
times_expression_aux(A, A) :- (number(A);atom(A);istrig(A)), !.
times_expression_aux([H|T], Expression) :-
    (number(H);atom(H);istrig(H);(compound(H),not(is_list(H)))),
    elements_in(T, H, Amount),
    delete(T, H, Td),
    simplest_times(H, Amount, Sh),
    times_expression_aux(Td, Expression1),
    ((Expression1 \= 1, Sh \= 0, Expression1 \= 0, !,
        ((number(Sh), N1*Y = Expression1, !, N2 is Sh*N1, Expression = N2*Y);
         (number(Expression1), N1*Y = Sh, !, N2 is Expression1*N1, Expression = N2*Y);
         (number(Sh), (atom(Expression1);istrig(Expression1)), !, Expression = Sh * Expression1);
         (number(Expression1), (atom(Sh);istrig(Sh)), !, Expression = Expression1 * Sh);
         (number(Sh),number(Expression1), !, Expression = Expression1*Sh);
         (Expression = Sh*Expression1))
     );
     ((Sh = 0;Expression1 = 0), !, Expression = 0); 
     (Expression = Sh)
    ), !.

times_expression_aux([H|T], Expression) :-
    is_list(H),
    reduce(H, Rh),
    to_expression(Rh, Expression1),
    times_expression_aux(T, Expression2),
    ((Expression2 \= 1) ->
        Expression = Expression1 * Expression2;
        Expression = Expression1
    ), !.

/* Funciones para sumar todos los elementos que son un número dentro de la lista, devuelve una lista con
    un elemento que representa la suma de todos los números y todos los otros elementos que no son números */
sum_list([],0) :- !.
sum_list(L, Result) :-
    sum_aux(L, [], 0, Result).

sum_aux([],[],0,0) :- !.
sum_aux([],Res,0,Res) :- !.
sum_aux([],[],Rsum,Rsum) :- !.
sum_aux([],Res,Rsum,Result) :-
    !,
    append([Rsum],Res, Res1),
    Result = Res1.

sum_aux([H|T], Res, Rsum, Result) :-
    number(H),
    Rsum1 is H+Rsum,
    sum_aux(T, Res, Rsum1, Raux),
    Result = Raux.

sum_aux([H|T], Res, Rsum, Result) :-
    (atom(H);(not(atom(H)),not(number(H)))),
    append(Res, [H], Res1),
    sum_aux(T, Res1, Rsum, Raux),
    Result = Raux.

/* Funciones para restar elementos que son números dentro de la lista */
sub_list([],0) :- !.
sub_list(L, Result) :-
    sub_aux(L, 0, [], 0, Result).

sub_aux([],_,[],0,0) :- !.
sub_aux([],_,Res,0,Res) :- !.
sub_aux([],_,[],Rsub,Rsub) :- !.
sub_aux([],_,Res,Rsub,Result) :-
    !,
    append([Rsub], Res, Res1),
    Result = Res1.

sub_aux([H|T], Index, Res, Rsub, Result) :-
    number(H),
    ((Rsub = 0) ->
        ((Index = 0) ->
            Rsub1 is H;
            Rsub1 is Rsub - H
        );
        Rsub1 is Rsub - H
    ), 
    Index1 is Index+1,
    sub_aux(T, Index1, Res, Rsub1, Raux),
    Result = Raux, !.

sub_aux([H|T], Index, Res, Rsub, Result) :-
    (atom(H);(not(atom(H)),not(number(H)))),
    Index1 is Index+1,
    sub_aux(T, Index1, [H|Res], Rsub, Raux),
    Result = Raux, !.

/* Funciones para multiplicar elementos que son números dentro de la lista */
times_list([],0) :- !.
times_list(L, Result) :-
    times_aux(L, [], 1, Result).

times_aux([],[],1,1) :- !.
times_aux([],Res,1,Res) :- !.
times_aux([],[],Rtimes,Rtimes) :- !.
times_aux([],Res,Rtimes,Result) :-
    !,
    append([Rtimes],Res, Res1),
    Result = Res1.

times_aux([H|T], Res, Rtimes, Result) :-
    number(H),
    Rtimes1 is H*Rtimes,
    times_aux(T, Res, Rtimes1, Raux),
    Result = Raux.

times_aux([H|T], Res, Rtimes, Result) :-
    (atom(H);(not(atom(H)),not(number(H)))),
    append(Res, [H], Res1),
    times_aux(T, Res1, Rtimes, Raux),
    Result = Raux.

/* Funciones para dividir elementos que son números dentro de la lista */
div_list([],0) :- !.
div_list(L, Result) :-
    div_aux(L, [], 1, Result).

div_aux([],[],1,1) :- !.
div_aux([],Res,1,Res) :- !.
div_aux([],[],Rdiv,Rdiv) :- !.
div_aux([],Res,Rdiv,Result) :-
    append([Rdiv], Res, Res1),
    Result = Res1.

div_aux([H|T], Res, Rdiv, Result) :-
    (atom(H);(not(atom(H)),not(number(H)))),
    append(Res, [H], Res1),
    div_aux(T, Res1, Rdiv, Raux),
    Result = Raux.

div_aux([H|T], Res, Rdiv, Result) :-
    number(H),
    Rdiv1 is Rdiv/H,
    div_aux(T, Res, Rdiv1, Raux),
    Result = Raux.