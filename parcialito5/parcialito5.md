# Parcialito Concurrencia y Recuperación

1) Para las siguientes planificaciones:

a.​ Dibujar los grafos de precedencia
b.​ Listar los conflictos
c.​ Determinar cuales son serializables (justificando)

1.1) bT1; bT2; bT3; rT1(A); wT3(A); rT2(B); wT2(A); rT3(B); wT1(B); cT3; cT2; cT1;
                              X               X               X
                              
a.  

    T3 -> T2 (A), 
    
    T3 -> T1 (B), 
    
    T1 -> T3 (A), 
    
    T2 -> T1 (B), 
    
    T1 -> T2 (A)

b.  

    (rT1(A), wT3(A))
    
    (rT1(A), wT2(A))
    
    (wt2(A), wT3(A))
    
    (rT2(B), wT1(B))
    
    (rt3(B), wt1(B))
    
c. Como el grafo de precedencias no es un DAG, entonces la planificación no es serializable.
    
1.2) bT1; bT2; rT1(X); wT2(X); cT2; bT3; rT3(X); wT1(Y); rT3(Y); wT3(Z); cT3; wT1(Z); cT1;
                        X                         X                 X           X       
a.  

    T1 -> T2 (X)
    
    T2 -> T3 (X)
    
    T1 -> T3 (Y)
    
    T3 -> T1 (Z)
    
b.  
    
    (rT1(X), wT2(X))
    
    (wT2(X), rT3(X))
    
    (wT1(Y), rT3(Y))
    
    (wT3(Z), wT1(Z))

c. No es serializable porque el grafo de precedencias no es un DAG.
    
1.3) bT1; bT2; bT3; bT4; RT2(B); WT2(B); RT1(A); WT1(A); RT4(A); WT4(A); cT2; RT3(C); WT3(C); RT4(B); WT4(B); RT1(C); WT1(C); cT4; RT3(A); WT3(A); cT1; cT3;
                                    X               X               X                   X               X               X                   x
                                    
a.  
    
    T1 -> T4 (A)
    
    T4 -> T3 (A)
    
    T3 -> T1 (C)
    
    como T2 lee y escribe en B pero commitea antes de que alguien acceda a B, no genera conflictos
    
b. 
    
    (rT1(A), wT4(A))
    
    (wT1(A), rT4(A))
    
    (wT1(A), WT4(A))
    
    (wT4(A), rT3(A))
    
    (wT4(A), WT3(A))
    
    (rt4(A), wT3(A))
    
    (wT3(C), rT1(C))
    
    (wT3(C), wT1(C))
    
    (rT3(C), wT1(C))

c. No es serializable porque el grafo de precedencias no es un DAG.

2. bT1; bT2; bT3; RT1(X); RT2(Z); WT1(Y); RT3(A); WT2(X); RT3(Z); WT3(Z); WT3(Y); cT1; cT2; cT3;
                                    X               X               X        X
a.​ Explique si es posible que este solapamiento ocurra utilizando el protocolo de lock de dos fases (2PL). Para ello, intente colocar locks L() y unlocks U() respetando el protocolo, y analice si ello es factible.

LT1(X, Y), RT1(X), LT2(Z), RT2(Z), WT1(Y), UT1(X, Y), LT3(A), RT3(A), LT2(X), WT2(X), UT2(X, Z), LT3(Z,Y), RT3(Z), WT3(Z), WT3(Y), UT3(Z, Y, A)

b.​ Indique si el solapamiento es serializable, justificando su respuesta.

Como se cumple el protocolo 2PL, es condición suficiente para afirmar que el solapamiento es serializable.

c.​ Indique si el solapamiento es recuperable, justificando su respuesta.

Es recuperable porque en ningun momento se lee un item que haya sido modificado previamente por otra transacción. De no pasar esto, tendria que ver si todas las transacciones que modificaron un dato D hayan commiteado **antes** que una transacción distinta lea al dato D (ya modificado)

3. LOG

1.​ <START T1>

2.​ <T1, P, 5, 50>

3.​ <START T2>

4.​ <T2, Q, 10, 60>

5.​ <T1, R, 15, 55>

6.​ <T2, S, 20, 70>

7.​ <START CKPT(T1,T2)>

8.​ <T1, U, 60, 30>

9.​ <T2, T, 25, 90>

10.​<COMMIT T1>

11.​<T2, Q, 60, 85>

12.​<START T3>

13.​<T3, U, 30, 95>

14.​<T2, S, 70, 100>

15.​<COMMIT T2>

16.​<T3, V, 35, 105>

17.​<T3, S, 100, 110>

19.​<T4, R, 55, 115>

20.​<END CKPT>

21.​<T4, W, 210, 125>

22.​<COMMIT T3>

23.​<COMMIT T4>

El formato del log es: ​ <Transacción, Recurso, V Viejo, V Nuevo>

Supongamos el siguiente log de un sistema que usa undo/redo logging. ¿Cuál es el valor de los ítems P, Q, R, S, T, U, V, W en disco después de la recuperación si la falla se produce en las siguientes situaciones:
a.​ Justo antes de la línea 18.

// Arranco recorriendo de adelante hacia atrás

S <- 100

V <- 35

U <- 30

// vi commit de t1 y t2, ahora recorro de atras hacia adelante

P <- 50

Q <- 60

R <- 55

S <- 70

U <- 30

T <- 90

Q <- 85

S <- 100

T3 no commiteo, escribo en el log ABORT (T3)

b.​ Justo antes de la línea 22.

// Arranco recorriendo de adelante hacia atrás

W <- 210

R <- 55

S <- 100

V <- 35

U <- 30

// vi commit de t1 y t2, ahora recorro de atras hacia adelante

P <- 50

Q <- 60

R <- 55

S <- 70

U <- 30

T <- 90

Q <- 85

S <- 100

ABORT (T3) ABORT (T4)

c.​ Después de la línea 23.

Están todas commiteadas asique arranco viendo de atrás hacia adelante.

P <- 50

Q <- 60

R <- 55

S <- 70

U <- 95

T <- 90

Q <- 85

S <- 100

V <- 105

S <- 110

R <- 115

W <- 125


