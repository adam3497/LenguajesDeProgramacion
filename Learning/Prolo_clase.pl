hijo(juan, pablo).
hijo(pedro, pablo).
hijo(judas, juan).

nieto(X,Y) :-
    hijo(X,Z),
    hijo(Z,Y).

hermanos(X,Y) :-
    hijo(X,Z),
    hijo(Y,Z),
    Y \= X.

sobrino(X,Y) :-
    hijo(X,Z),
    hermanos(Z,Y).

tio(X,Y) :-
    hijo(Y,Z),
    hermanos(Z,X).

/*
  miembro(X, lista)
     if null lista False
     else if X = head(lista) then True
     else miembro(X, tail(lista))
 */
miembro(X, [X|_]).
miembro(X, [_|Y]) :-
    miembro(X,Y).

concat([], L, L).
concat([H|T], L, [H|Resto]) :-
    concat(T, L, Resto).

p([],[]) :- !.
p(Lista,[H|Resto]) :-
    concat(X,[H|Y], Lista),
    concat(X,Y,Z),
    p(Z,Resto).

esta(X, nodo(X,_,_)).
esta(X, nodo(Y,Izq,_)) :-
    X < Y,
    esta(X,Izq).
esta(X, nodo(Y,_,Der)) :-
    X > Y,
    esta(X, Der).

genereArbol(Lista, Arbol) :-
    genereArbol(Lista, _, Arbol).

genereArbol([], Arbol, Arbol) :- !.
genereArbol([X|Resto], Arbol, Resultado) :-
    esta(X, Arbol),
    genereArbol(Resto, Arbol, Resultado).

alreves([],[]) :- !.
alreves([H|T], Alreves) :-
    alreves(T,Reves),
    concat(Reves, [H], Alreves).

alberes(A,B) :-
    alberes(A,[],B).
alberes([],Acum,Acum) :- !.
alberes([H|T], Acum, Resultado) :-
    alberes(T, [H|Acum], Resultado).

inorder(null, []) :- !.
inorder(nodo(X,Izq,Der), Lista) :-
    inorder(Izq, LIzq),
    inorder(Der, LDer),
    concat(LIzq, [X|LDer], Lista).

preorder(null, []) :- !.
preorder(nodo(X,Izq,Der), [X|Hijos]) :-
    preorder(Izq, LIzq),
    preorder(Der, LDer),
    concat(LIzq, LDer, Hijos).

preord(Arbol, Lista) :- preord(Arbol, [], Lista).
preord(null, Lista, Lista) :- !.
preord(nodo(X,Izq,Der), Lista, [X|Hijos]) :-
    preord(Der, Lista, LDer),
    preord(Izq, LDer, Hijos).

inord(Arbol, Lista) :- inord(Arbol, [], Lista).
inord(null, Lista, Lista) :- !.
inord(nodo(X,Izq,Der), Lista, Resultado) :-
    inord(Der, Lista, LDer),
    inord(Izq, [X|LDer], Resultado).

partaX(X, [X|Resto], [], Resto) :- !.
partaX(X, [Y|Resto], [Y|Izq], Der) :-
    partaX(X, Resto, Izq, Der).

partaN(0, Lista, [], Lista) :- !.
partaN(N, [H|T], [H|Izq], Der) :-
    N1 is N-1,
    partaN(N1, T, Izq, Der).

largo([],0) :- !.
largo([_|Cola], Res) :-
    largo(Cola, N),
    Res is N+1.

/* hagaArbol(ListaPreOrder, ListaInOrder, Arbol) */
hagaArbol([], [], null) :- !.
hagaArbol([Raiz|Hijos], InOrd, nodo(Raiz, Izq, Der)) :-
    partaX(Raiz, InOrd, IInOrd, DInOrd),
    largo(IInOrd, N),
    partaN(N, Hijos, IPreOrd, DPreOrd),
    hagaArbol(IPreOrd, IInOrd, Izq),
    hagaArbol(DPreOrd, DInOrd, Der).

/* Versión de hagaArbol con listas auxiliares
   
   haga un trace y liste los pasos de llamadas y valor de 
   variables para la siguiente llamada
   
   ?- makeTree([3,4,5,1,2], [4,5,3,2,1], A).
 */

makeTree(PreOrd, InOrd, Arbol) :- makeTree(PreOrd, InOrd, [], [], Arbol).
makeTree(A,B,A,B,null) :- !.
makeTree([Raiz|Pre], In, PreOut, InOut, nodo(Raiz, Izq, Der)) :-
    makeTree(Pre, In, PreDer, [Raiz|InDer], Izq),
    makeTree(PreDer, InDer, PreOut, InOut, Der).

/* Derivador */
/* Caso 0. derivada de x con respecto a x */
d(X,X,1) :- !.

/* Caso 1. una constante K */
d(K,X,0) :- atom(K), !, K \= X.
d(N,_,0) :- number(N), !.

/* Caso 2. (f(x)+g(x))' = f'(x) + g'(x) */
d(Fx+Gx, X, Dfx+Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).
d(Fx-Gx, X, Dfx-Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

/* Caso 3. (f(x)*g(x))' = f'(x)g(x) + f(x)g'(x) */
d(Fx*Gx, X, Dfx*Gx + Fx*Dgx) :-
    !,
    d(Fx, X, Dfx),
    d(Gx, X, Dgx).

/* Caso 4. (x^n)' = nx^(n-1) */
d(X^N, X, N*X^N1) :-
    number(N), !,
    N1 is N-1.
d(X^N, X, N*X^N1) :-
    number(N), !,
    N1 = N-1.

/* Caso 5. cos(f(x))' = sin(f(x))f(x)' */
d(sin(Fx), X, cos(Fx)*Dfx) :-
    !, d(Fx, X, Dfx).
d(cos(Fx), X, -sin(Fx)*Dfx) :-
    !, d(Fx, X, Dfx).

/* enliste(expresion -> Lista) */
enliste(X, X) :- atom(X), !.
enliste(N, N) :- number(N), !.
enliste(A+B, [+, EA, EB]) :-
    enliste(A, EA),
    enliste(B, EB).

aplaste([+,A,B],[+,A,B]) :-
    simple(A),
    simple(B).

aplaste([+,A,B],[+|Parametros]) :-
    !,
    aplaste(A, AA),
    aplaste(B, AB),
    combine(AA, AB, Parametros).
aplaste(X,X) :- !.

combine([+|A],[+|B], Resultado) :-
    !,
    append(A,B,Resultado).
combine([+|A],B, [B|A]) :- !.
combine(A,[+|B], [A|B]) :- !.
combine(A,B,[A,B]) :- !.

simple(A) :- atom(A).
simple(A) :- number(A).


/* Granjero Pollo Zorra Maiz */
/* (G,P,Z,M) */

otro_lado(izquierda, derecha).
otro_lado(derecha, izquierda).
resolver(Estados, Acciones) :-
    resolver((izquierda, izquierda, izquierda, izquierda), [], Estados, Acciones).

resolver((derecha, derecha, derecha, derecha), Trayecto, Resultado, []) :-
    Resultado = [(derecha, derecha, derecha, derecha) | Trayecto], !.

resolver(Estado, Trayecto, Resultado, [Accion|Acciones]) :-
    pase(Estado, ProxEstado, Accion),
    \+ se_comen(ProxEstado),
    \+ member(ProxEstado, Trayecto),
    resolver(ProxEstado, [Estado|Trayecto], Resultado, Acciones).

/* Casos de pase */
/* pasa el granjero con el pollo */
pase((Lado, Lado, Zorra, Grano), (OtroLado, OtroLado, Zorra, Grano), [pase, OtroLado, con, pollo]) :-
    otro_lado(Lado, OtroLado).
/* pasa el granjero con la zorra */
pase((Lado, Pollo, Lado, Grano), (OtroLado, Pollo, OtroLado, Grano), [pase, OtroLado, con, zorra]) :-
    otro_lado(Lado, OtroLado).
/* pasa el granjero con el grano */
pase((Lado, Pollo, Zorra, Lado), (OtroLado, Pollo, Zorra, OtroLado), [pase, OtroLado, con, grano]) :-
    otro_lado(Lado, OtroLado).
/* pasa el granjero solo */
pase((Lado, Pollo, Zorra, Grano), (OtroLado, Pollo, Zorra, Grano), [pase, OtroLado, solo]) :-
    otro_lado(Lado, OtroLado).


se_comen((OtroLado, Lado, _, Lado)) :- otro_lado(Lado, OtroLado).
se_comen((OtroLado, Lado, Lado, _)) :- otro_lado(Lado, OtroLado).
