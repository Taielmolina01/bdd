# Concurrencia

Una **transacción** es una _secuencia ordenada de instrucciones atómicas_.

Existe un scheduler que elige que transacción realizar en cada momento en el procesador. Por razones lógicas el scheduler no hace un switch durante una instrucción atómica.

La ejecución de transacciones por un SGBD debería cumplir con 4 propiedades deseables, conocidas como **propiedades ACID**:

- Atomicidad: o bien la transacción se realiza por completo o no se realiza.
- Consistencia: cada ejecución por sí misma debe preservar la consistencia de los datos. Por ejemplo si hago un insert grande y una de las filas que está siendo insertada rompe con alguna regla de la tabla/ de la base de datos, no se inserta ninguna de las filas.
- Aislamiento: el resultado de la ejecución concurrente de las transacciones debe ser el mismo que si las transacciones se ejecutaran en forma aislada una tras otra. La ejecución concurrente debe entonces ser equivalente a alguna ejecución serial.
- Durabilidad: una vez que el SGBD informa que la transacción se ha completado debe garantizarse la persistencia de la misma, independientemente de toda falla que pueda ocurrir. Por ejemplo si pagué algo y quedo en memoria y no se grabó en disco en la BDD, se tiene que garantizar que pase lo que pase, aun si se corta la luz donde está el server, esa transacción se realizó. Si me dijiste que la transacción se terminó, se terminó!

Para garantizar las propiedades ACID, los SGBD disponen de mecanismos de recuperación que permiten deshacer/rehacer una transacción en caso de que se produzca un error o falla.

Para ello es necesario agregar a la secuencia de instrucciones de cada transacción algunas instrucciones especiales:

- begin: indica el comienzo de la transacción.
- commit: indica que la transacción ha terminado exitosamente y se espera que su resultado haya persistido.
- abort: indica que se produjo algún error o falla, y que por lo tanto se debe hacer un roll back.

## Problemas

- Leer algo que está a punto de ser abortado: problema de **lectura sucia**.

- **Lost update**: ocurre cuando una transacción modifica un ítem que fue leído anteriormente por una transacción que aún no terminó. Si la primera transacción luego modifica y escribe el item que leyó, el valor escrito por la segunda se perderá.

Si en cambio la primera transacción volviera a leer el ítem luego de que la segunda lo escribiera, se encontraría con un valor distinto (**unrepeatable read**)

- **Dirty write**: ocurre cuando una transacción T2 escribe un ítem que ya había sido escrito por otra transacción T1 que luego se deshace.

- **Phantom**: ocurre cuando una transacción T1 observa un conjunto de ítems que cumplen determinada condición y luego dicho conjunto cambia porque algunos de sus items son modificados/creados/eliminados por otra transacción T2.

## Serializabilidad

- R_T(X): La transacción T lee el ítem X.
- W_T(X): La transacción T escribe el ítem X.
- b_T(X): Comienzo de la transacción T.
- c_T(X): La transacción T realiza el commit.
- a_T(X): Se aborta la transacción T.

Podemos escribir una transacción general T como una lista de instrucciones en donde m(T) representa la cantidad de instrucciones de T.

Un **solapamiento** entre dos transacciones T1 y T2 es una lsita de m(T1) + m(T2) en donde cada instrucción de T1 y T2 aparece una única vez, y las instrucciones de cada transacción conservan el orden entre ellas dentro del solapamiento.

Existen: [m(T1)+m(T2)]! / [m(T1)! * m(T2)!]

Cuantas ejecuciones seriales distintas existen entre n transacciones: n!

Un solapamiento de un conjunto de transacciones es **serializable** cuando la ejecución de sus instrucciones en dicho orden deja a la bdd en un estado **equivalente** al que la hubiera dejado alguna ejecución serial.

Nos interesa que los solapamientos producidos sean serializables, porque ellos garantizan la propiedad de **aislamiento** de las transacciones.

Existen distintas nociones de equivalencia:

- de resultados: dado un estado inicial particular, ambos órdenes de ejecución dejan a la bdd en el mismo estado.
- de conflictos: cuando ambos órdenes de ejecución poseen los mismos conflictos entre instrucciones.
- de vistas: cuando en cada órden de ejecución, cada lectura R T_i(X) lee el valor escrito por la misma transacción j, W T_j(X).

Dada un orden de ejecución, un **conflicto** es un par de instrucciones ejecutadas por dos transacciones distintas Ti y Tj, tales que ejecutan instrucciones sobre un mismo ítem X y al menos una de ellas implica una escritura.

La serializabilidad por conflictos puede ser evaluada a través del **grafo de precedencias**.

Dado un conjunto de transacciones T_i que acceden a determinados ítems X_j, el grafo de precedencias es un grafo dirigido simple que se construye como:

- nodo por cada transacción
- arista desde nodo T_i a T_j si y solo si existe algun conflicto entre ellas (siendo T_i el que _accede_ primero).

Si el resultado es un DAG, entonces no serializable.

Sí es serializable, realizando un topológico encontramos el orden de ejecución serial equivalente.

## Control de concurrencia basado en locks

El SGBD utiliza locks para bloquear a los recursos (ítems) y no permitir que más de una transacción los use en forma simultánea.

Los locks son insertados por el SGBD como instrucciones especiales en medio de la transacción.

Los locks son variables asociadas a determinados recursos, y que permiten regular el acceso a los mismos en los sistemas concurrentes.

Resuelven la mutual exclusion. Un lock debe disponer de las primitivas que permiten tomar y liberar el recurso

- Acquire(X) o Lock(X)
- Release(X) o Unlock(X)

Dichas primitivas tienen que ser atómicas.

En general, los SGBD implementan locks de varios tipos. Los dos tipos principales son:

- Locks de escritura (exclusive access)
- Locks de lectura (shared access)

Si alguien tiene un lock:

- shared: se puede otorgar otro de tipo shared pero no uno exclusive.
- exclusive: no se puede otorgar otro de tipo shared ni exclusive.

(in other words, podemos leer a la vez muchos pero si involucra escritura lockeamos).

El uso de locks por sí solo no basta, por lo cual se utiliza el **protocolo de lock de dos fases**: Una transacción no puede adquirir un lock luego de haber liberado un lock que había adquirido.

Osea: todos lockeos hasta el primer unlock (donde ya no puede volver a lockear!)

El cumplimiento de este protocolo es condición suficiente para garantizar que cualquier orden de ejecución de un conjunto de transacciones sea serializable.

Introduce otros dos problemas:

- deadlock
- livelock

Un deadlock se identifica con un grafo de recursos. Cuando identificamos un ciclo en él, hacemos un rollback de una de las transacción involucradas (de la transacción más vieja / la que menos operaciones hizo asi minimizamos el costo del rollback).

La **inanición** es una condición vinculada con el deadlock, y ocurre cuando una transacción no logra ejecutarse por un periodo de tiempo indefinido.

Se utiliza una queue de pedidos de locks para solucionar este problema. Las transacciones que esperan desde hace más tiempo por un recurso tengan prioridad en la adquisición de un lock.

A los locks que se aplican sobre los nodos de un índice del árbol de tipo B+ se los denomina **index locks**.

Se utiliza un protocolo para el acceso concurrente a estructuras de árbol, conocido como **protocolo del cangrejo**:

- Comenzar obteniendo un lock sobre el nodo raíz.
- Hasta llegar a el/los nodo/s deseado/s, adquirir un lock sobre el/los hijo/s que se quiere acceder y liberar el lock sobre el padre si los nodos hijos son seguros (el nodo hijo no está lleno si estamos haciendo una inserción ni está justo por la mitad en el caso de una eliminación)
- Una vez terminada la operación, liberamos todos los locks.

## Control de concurrencia basado en timestamps

Se asigna cada transacción Ti un timestamp TS(Ti). Los timestamps deben ser únicos y determinarán el orden serial respecto al cual el solapamiento deberá ser equivalente.

Se permite la ocurrencia de conflictos pero siempre que las transacciones de cada conflicto aparezcan de acuerdo al orden serial equivalente:

(WTi(X), RTj(X)) -> TS(Ti) < TS(Tj)

No emplea locks!

Se debe mantener en todo instante para cada item X, la siguiente información:

- read_TS(X): es el TS(T) correspondiente a la transacción más joven (de mayor TS(T)) que leyó el item X.
- write_TS(X): es el TS(T) correspondiente a la transacción más joven (de mayor TS(T)) que escribió el item X.

Funcionamiento:

- Cuando una transacción Ti quiere ejecutar un R(X):
    - Si una transacción posterior Tj modificó el ítem, Ti deberá ser abortada.
    - De lo contrario, actualiza read_TS(X) y lee.
- Cuando una transacción Ti quiere ejecutar un W(X):

La logica en el caso de ejecutar una escritura puede ser mejorada, utilizando la regla conocida como **Thomas's Write Rule**:

Si cuando Ti intenta escribir un ítem encuentra que una transacción posterior Tj ya lo escribió, entonces Ti puede descartar su actualización sin riesgos, siempre y cuando el ítem no haya sido leído por ninguna transacción posterior a Ti.

## Snapshot isolation

Cada transacción ve un snapshot de la base de datos correspondiente al instante de su inicio.

- Ventaja: permite un mayor solapamiento, ya que lecturas que hubieran sido bloqueadas utilizando locks, ahora pueden realizarse.

- Desventajas:
    - Requiere de mayor espacio en disco o memoria, al tener que mantener múltiples versiones de los mismos ítems.
    - Cuando ocurren conflictos de tipo WW entre transacciones, obliga a deshacer una de ellas.
    
Cuando dos transacciones intentan modificar un mismo ítem de datos, generalmente gana aquella que hace primero su commit, mientras que la otrá deberá ser abortada.

Soluciona el problema del fantasma!

## Niveles de aislamiento

De acuerdo con el nivel de aislamiento elegido, pueden producirse o no ciertas anomalías:

1. **Read Uncommitted**: Es la carencia total de aislamiento: No se emplean *locks*, y se accede a los ítems sin tomar ninguna precaución.
2. **Read Committed**: Evita la anomalía de lectura sucia.
3. **Repeatable Read**: Evita la lectura no repetible y la lectura sucia.
4. **Serializable**: Evita todas las anomalías, y asegura que el resultado de la ejecución de las transacciones es equivalente al de algún orden serial.

| Nivel de aislamiento | Lectura sucia | Lectura no repetible | Fantasma |
|----------------------|---------------|-----------------------|----------|
| READ UNCOMMITTED     | ❌            | ❌                    | ❌       |
| READ COMMITTED       | ✅            | ❌                    | ❌       |
| REPEATABLE READ      | ✅            | ✅                    | ❌       |
| SERIALIZABLE         | ✅            | ✅                    | ✅       |

Si bien la anomalía de dirty write no se menciona en el estándar, la misma debería ser proscripta en todos los niveles de aislamiento.
