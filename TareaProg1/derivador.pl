/* Tarea Programada 1 - Lenguajes de Programación
   Desarrollo de un derivador en Prolog
   Estudiante: Adrián Amador Ávila
*/

/* Función principal que hace uso de las demás funciones para simplificar la expresión */
derivar(A,B,R) :-
    !,
    d(A,B,Df), print(Df),
    tolist(Df, Ldf), print(Ldf),
    reduce(Ldf, Rdf),
    simplify(Rdf, R).

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
isoperator(H) :-
    (H = '+';H = '-';H = '*';H = '/';H = '^').

simplify([],[]) :- !.

simplify([H|T], [H|Res_sim]) :-
    isoperator(H),
    simplify(T, Res_sim).

simplify([H|T], Result) :-
    print('H is '= H),
    (not(isoperator(H)),not(number(H)),not(atom(H))),
    simplify_aux(H, Resaux),
    simplify(T, Res_sim),
    append(Resaux, Res_sim, Result).

simplify([H|T], [H|Res_sim]) :-
    (not(isoperator(H)),(atom(H);number(H))),
    simplify(T, Res_sim).

simplify_aux([+,A,B], Result) :-
    simplify_sum([A,B], Res1),
    Result = Res1.

simplify_aux([-,A,B], Result) :-
    simplify_sub([A,B], Res1),
    Result = Res1.

simplify_aux([*,A,B], Result) :-
    simplify_times([A,B], Res1),
    Result = Res1.

simplify_aux([/,A,B], Result) :-
    simplify_div([A,B], Res1),
    Result = Res1.

simplify_aux([^,A,B], Result) :-
    simplify_pow([A,B], Res1),
    Result = Res1.

/*Funciones para simplificar listas de la manera ['operador', A, B] en listas con una sola expresión */
/* [+,A,B]*/
istrig(A) :-
    not(atom(A)),not(number(A)), !.

simplify_sum([A,B], [Result]) :-
    number(A),number(B),
    Result is A+B, !.

simplify_sum([A,B], [A,B]) :-
    ((atom(A),number(B));(number(A),atom(B))), !.

simplify_sum([A,B], [A,B]) :-
    atom(A),atom(B), !.

simplify_sum([A,B], [2*A]) :-
    istrig(A),istrig(B),
    A = B, !.

simplify_sum([A,B], [A,B]) :-
    istrig(A),istrig(B),
    A \= B, !.

/* [-,A,B] */
simplify_sub([A,B], [Result]) :-
    number(A),number(B),
    Result is A-B, !.

simplify_sub([A,B], [A,-B]) :-
    ((atom(A),number(B));(number(A),atom(B))), !.

simplify_sub([A,B], [0]) :-
    atom(A),atom(B), 
    A = B, !.

simplify_sub([A,B], [A, -B]) :-
    atom(A),atom(B), 
    A \= B, !.

simplify_sub([A,B], [0]) :-
    istrig(A),istrig(B),
    A = B, !.

simplify_sub([A,B], [A, -B]) :-
    istrig(A),istrig(B),
    A \= B, !.

simplify_sub([A,B], [A, -B]) :-
    istrig(A),(number(B);atom(B)), !.

simplify_sub([A,B], [B, -A]) :-
    istrig(B),(number(A);atom(A)), !.

/* [*,A,B] */
simplify_times([A,B], [Result]) :-
    number(A),number(B),
    Result is A*B, !.

simplify_times([A,B], [0]) :-
    (atom(A),number(B)), B = 0, !.

simplify_times([A,B], [B*A]) :-
    (atom(A),number(B)), B \= 0, !.

simplify_times([A,B], [0]) :-
    (number(A),atom(B)), A = 0, !.

simplify_times([A,B], [A*B]) :-
    (number(A),atom(B)), !.

simplify_times([A,B], [A^2]) :-
    atom(A),atom(B), 
    A = B,
    !.

simplify_times([A,B], [A*B]) :-
    atom(A),atom(B), 
    A \= B,
    !.

simplify_times([A,B], [2*A]) :-
    istrig(A),istrig(B),
    A = B, !.

simplify_times([A,B], [A*B]) :-
    istrig(A),istrig(B),
    A \= B, !.

simplify_times([A,B], [B*A]) :-
    istrig(A),(number(B);atom(B)), B \= 0, !.

simplify_times([A,B], [0]) :-
    istrig(A),(number(B);atom(B)), B = 0, !.

simplify_times([A,B], [0]) :-
    istrig(B),(number(A);atom(A)), A = 0, !.

simplify_times([A,B], [A*B]) :-
    istrig(B),(number(A);atom(A)), A \= 0, !.

/* ['/',A,B] */
simplify_div([A,B], [Result]) :-
    number(A),number(B),
    Result is A/B, !.

simplify_div([A,B], [(B/A)]) :-
    (atom(A),number(B)), !.

simplify_div([A,B], [(0)]) :-
    (number(A),atom(B)), A = 0, !.

simplify_div([A,B], [(A/B)]) :-
    (number(A),atom(B)), A \= 0, !.

simplify_div([A,B], [1]) :-
    atom(A),atom(B), 
    A = B,
    !.

simplify_div([A,B], [(A/B)]) :-
    atom(A),atom(B), 
    A \= B,
    !.

simplify_div([A,B], [1]) :-
    istrig(A),istrig(B),
    A = B, !.

simplify_div([A,B], [(A/B)]) :-
    istrig(A),istrig(B),
    A \= B, !.

simplify_div([A,B], [A/B]) :-
    istrig(A),(number(B);atom(B)), !.

simplify_div([A,B], [0]) :-
    istrig(B),(number(A);atom(A)), A = 0, !.

simplify_div([A,B], [A/B]) :-
    istrig(B),(number(A);atom(A)), A \= 0, !.

/* [^,A,N] */
simplify_pow([A,N], [A]) :-
    number(N),
    N = 1, !.

simplify_pow([_,N], [1]) :-
    number(N),
    N = 0, !.

simplify_pow([A,Fx], [A^Fx]) :-
    atom(Fx), !.

simplify_pow([A, Fx], [A^(R1)]) :-
    not(atom(Fx)),not(number(Fx)),
    print('Fx is'=Fx),
    reduce(Fx, Rfx),
    print('Rfx is'=Rfx),
    simplify(Rfx, R1).

/* Funciones para pasar una lista a una expresión */
to_expression([H|T], Result) :- 
    to_expression_aux(T, H, Result).

to_expression_aux(L, Operator, Expression) :-
    Operator = '+', !,
    sum_expression(L, Expression).

to_expression_aux(L, Operator, Expression) :-
    Operator = '-', !,
    sub_expression(L, Expression).

to_expression_aux(L, Operator, Expression) :-
    Operator = '*', !,
    times_expression(L, Expression).

to_expression_aux(L, Operator, Expression) :-
    Operator = '/', !,
    div_expression(L, Expression).

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

simplest_sub(A, K, X) :-
    number(A), !,
    K1 is K+1,
    X is K1*A.

simplest_sub(A, K, X) :-
    (atom(A);not(number(A))),
    K \= 0, !,
    K1 is K+1,
    X = K1*A.

simplest_sub(A, K, X) :-
    (atom(A);not(number(A))),
    K = 0, !,
    X = A.

simplest_times(A, K, X) :-
    number(A), !,
    K1 is K+1,
    X is A^K1.

simplest_times(A, K, X) :-
    (atom(A);not(number(A))),
    K \= 0, !,
    K1 is K+1,
    X = A^K1.

simplest_times(A, K, X) :-
    (atom(A);not(number(A))),
    K = 0, !,
    X = A.

/* Funciones para transformar y simplificar una lista de suma en expresión */
sum_expression([], 0) :- !.
sum_expression([A], A) :- !.
sum_expression(L, Expression) :-
    sum_list(L, L1),
    sum_expression_aux(L1, Expression), !.

sum_expression_aux([H|T], Expression) :-
    elements_in(T, H, Amount), print('Amount'=Amount),
    delete(T, H, Td), print("Trimmed list"=Td),
    simplest_sum(H, Amount, Sh), print("Simplest"=Sh),
    sum_expression(Td, Expression1),
    ((Expression1 \= 0) ->
        Expression = Sh + Expression1
    ;
        Expression = Sh), !.

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

/* Funciones para transformar y simplificar una lista de suma en expresión */
sub_expression([], 0) :- !.
sub_expression([A], A) :- !.
sub_expression(L, Expression) :-
    sub_list(L, L1),
    sub_expression_aux(L1, Expression), !.

sub_expression_aux([H|T], Expression) :-
    elements_in(T, H, Amount), print('Amount'=Amount),
    delete(T, H, Td), print("Trimmed list"=Td),
    simplest_sub(H, Amount, Sh), print("Simplest_sub"=Sh),
    sub_expression(Td, Expression1),
    ((Expression1 \= 0) ->
        Expression = Sh - Expression1
    ;
        Expression = Sh), !.

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
    Result = Res1, print("Res1 is "=Res1).

sub_aux([H|T], Index, Res, Rsub, Result) :-
    number(H), print("H is "=H),
    ((Rsub = 0) ->
        ((Index = 0) ->
            Rsub1 is H
        ;
            Rsub1 is Rsub - H)
    ;
        Rsub1 is Rsub - H), 
    print("Rsub1 is "=Rsub1),
    Index1 is Index+1,
    sub_aux(T, Index1, Res, Rsub1, Raux),
    Result = Raux, print("Raux is "=Raux), !.

sub_aux([H|T], Index, Res, Rsub, Result) :-
    (atom(H);(not(atom(H)),not(number(H)))),print("H is "=H),
    Index1 is Index+1,
    sub_aux(T, Index1, [H|Res], Rsub, Raux),
    Result = Raux, print("Raux is "=Raux), !.

/* Funciones para transformar y simplificar una lista de multiplicación en expresión  */
times_expression([], 1) :- !.
times_expression([A], A) :- !.
times_expression(L, Expression) :-
    times_list(L, L1),print("Times list is"=L1),
    ((number(L1)) -> 
        Expression = L1
    ;
        times_expression_aux(L1, Expression)),
    !.

times_expression_aux([H|T], Expression) :-
    elements_in(T, H, Amount), print('Amount'=Amount),print('H is'=H),
    delete(T, H, Td), print("Trimmed list"=Td),
    simplest_times(H, Amount, Sh), print("Simplest"=Sh),
    times_expression(Td, Expression1),
    ((Expression1 \= 1) ->
        Expression = Sh * Expression1
    ;
        Expression = Sh), !.

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
    Rtimes1 is H*Rtimes,print("Rtimes1 is "=Rtimes1),
    times_aux(T, Res, Rtimes1, Raux),
    Result = Raux.

times_aux([H|T], Res, Rtimes, Result) :-
    (atom(H);(not(atom(H)),not(number(H)))),
    append(Res, [H], Res1),
    times_aux(T, Res1, Rtimes, Raux),
    Result = Raux.

/* Verificador si una expresión ya está en su forma más simple posible */
is_simple_exp(List) :-
    length(List,3),
    simple_list(List), !.

simple_list([]) :- true, !.
simple_list([H|T]) :-
    (atom(H);number(H);H = cos(_);H = sin(_);H = -cos(_);H = -sin(_)),
    simple_list(T).