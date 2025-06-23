# No-SQL

Buscan ser SGBD distruibidos mejorando la performance de los SGBD relacionales comunes.

Buscan aumentar la velocidad de procesamiento y la capacidad de almacenar información, explorando las ventajas que brindan las redes de computadoras y en particular Internet.

Existen distintos tipos:

- Bases de datos clave-valor
- Bases de datos orientadas a documentos
- Bases de datos wide column
- Bases de datos basadas en grafos

En cada uno de ellos cambia la definición de agregado, es decir, de cómo conjuntos de objetos relacionados se agrupan en colecciones para ser tratados como unidad y ser almacenados en un mismo lugar. 

Las bases de datos relacionales y las basadas en grafos carecen de la noción de agregado.

La **fragmentación** es la tarea de dividir un conjunto de agregados entre un conjunto de nodos.

Se realiza con dos objetivos:

- Almacenar conjuntos muy grandes de datos que de lo contrario no podrían caber en un único nodo.
- Paralelizar el procesamiento, permitiendo que cada nodo ejecute una parte de las consultas para luego integrar los resultados.

Existen dos formas de fragmentar:

- Fragmentación horizontal: los agregados se reparten entre los nodos, de manera que cada nodo almacena un subconjunto de agregados. Generalmente se asigna el nodo a partir del valor de algunos de los atributos del agregado.
- Fragmentación vertical: distintos nodos guardan un subconjunto de atributos de cada agregado. Todos suelen compartir los atributos que conforman la clave.

Muchas veces se utiliza una combinación de ambas.

La **replicación** es el proceso por el cual se almacenan múltiples copias de un mismo dato en distintos nodos del sistema.

Nos brinda varias ventajas:

- Es un **mecanismo de backup**: permite recuperar el sistema en caso de fallas de disco.
- Permite repartir la carga de procesamiento si permitimos que las réplicas respondan consultas o actualizaciones.
- Garantiza cierta **disponibilidad** del sistema aún si se caen algunos nodos.

Cuando solo funcionan como backup se les llama **réplicas secundarias**. Cuando también pueden hacer procesamiento se las conoce como **réplicas primarias**.

El problema que genera la replicación es la **consistencia** de los datos.

## Bases de datos clave-valor

Las claves son únicas y el unico requisito sobre su dominio es que sea comparable por igual.

Algunos ejemplos de key-value stores son:

- Berkeley DB
- Dynamo (key-value store de Amazon)
- Redis

Contiene las operaciones:

- put
- delete
- update
- get

No se define un esquema, no hay restricciones de integridad ni de dominio. El agregado es mínimo y está limitado al par.

El objetivo es guardar y consultar grandes cantidades de datos, pero no de interrelaciones entre los datos.

Dynamo utiliza un método de lookup denominado **hashing consistente** que reduce la cantidad de movimientos de pares necesarios cuando cambia la cantidad de nodos S.

Si mientras fueramos aumentando la cantidad de nodos S, vamos cambiando por consecuencia el modulo que le aplicamos al resultado de nuestro hashing, deberiamos por cada entrada de hash S rehashear los S-1 nodos previos.

El hashing consistente lo que hace entonces es agregar los agregados en el nodo cuya función de hashing es inmediatamente mayor igual a la de nuestro agregado. 

### Consistencia

Hablamos de cuantos estados distintos tiene la base de datos. Si consulto distintos nodos, tengo resultados distintos ? similar idea con la cache en compus multiprocesadores.

Decimos que hay una **consistencia secuencial** cuando el resultado de cualquier ejecución concurrente de los procesos es equivalente al de alguna ejecución secuencial en que las instrucciones de los procesos se ejecutan una después de otra.

Esto no quiere decir que los procesos se ejecuten uno después de otro, sino que una instrucción no comienza hasta que otra no haya terminado de aplicarse en todas las réplicas.

Notación

R(X)a indica que el proceso leyó el valor de item X.
W(x)b indica que el proceso escribió el valor b en el ítem X.

Si no encontramos una forma de acomodar globalmente el orden de las lecturas/escrituras "sumando" la de distintos procesos de la misma BDD, entonces no tiene consistencia secuencial. 

Garantizar consistencia secuencial es costoso.

El modelo de **consistencia causal** busca capturar eventos que puedan estar causalmente relacionados. Si un evento b fue influenciado por un evento a, la causalidad requiere que todos vean al evento a antes que al evento b.

Toda consistencia secuencial es causal pero no toda consistencia causal es secuencial.

Dos eventos que no están causalmente correlacionados se dicen concurrentes, y no es necesario que sean vistos por todos en el mismo orden.

Dos escrituras que están potencialmente causalmente relacionadas deben ser vistas por todos en el mismo orden.

Dynamo usa **consistencia eventual**. Se tolera un cierto grado de inconsistencia.

Hay consistencia eventual si en el sistema no se producen modificaciones por un tiempo suficientemente grande, entonces eventualmente todos los procesos verán los mismos valores. En otras palabras, eventualmente todas las réplicas llegarán a ser consistentes.

Se definen dos parámetros adicionales:

- W <= N: Quorum de escritura

Un nodo puede devolver un resultado de escritura exitosa luego de recibir la confirmación de escritura de otros W-1 nodos del listado de preferencia. W=2 es un nivel de replicación mínimo. El nodo se queda esperando a que el resto de nodos confirmen que ya escribieron

- R <= N: Quorum de lectura. Un nodo puede devolver el valor de una clave leída luego de disponer de la lectura de R nodos distintos. En muchas situaciones R=1 es ya suficiente. Valores de R mayores brindan tolerancia a fallas como corrupción de datos o ataques externos, pero hacen más lenta la lectura.

## Bases de datos orientadas a documentos

Un **documento** es la unidad estructural de información que almacena datos bajo una cierta estructura. Generalmente, un documento se define como un conjunto de pares clave-valor que representan los atributos del documento y sus valores. Se admiten atributos multivaluados, y también se admite que el valor de un atributo sea a su vez un documento.

La estructura de un documento se describe como lenguaje de intercambio de datos: HTML, XML, JSON, YAML.

Este tipo de bases de datos comparten algunas características con las bases de datos relacionales, como hacer consultas de selección o agregar datos. Algunos ejemplos son: MongoDB, RethinkDB, CouchDB, RavenDB.

### MongoDB

Se basa en hashes para identificar a los objetos. Los documentos tiene un formato JSON. Almacena por clave-valor. Desarollada en C++. Su implementación de la operación de junta es limitada. Organiza los datos de una base de datos en **colecciones** que contienen documentos.

| Modelo relacional | MongoDB       |
|-------------------|---------------|
| Esquema           | Base de datos |
| Relación          | Colección     |
| Tupla             | Documento     |
| Atributo          | Campo         |

Las claves en JSON son siempre strings. Los valores pueden ser de distintos tipos: strings, numeros, vectores, booleanos, objetos JSON o NULL.

Los documentos dentro de una colección se identifican a través de un campo _id. EL hash asegura que no se pueda insertar dos veces el mismo documento en una colección. Cuando hacemos insert obtenemos una lista de los hashes de los documentos creados.

Las consultas se realizan con la función find() sobre una colección. El resultado es un cursor que debe ser iterado.

Se puede tener documentos **referenciados** dentro de otro, es decir que vemos su hash dentro del otro. También podemos ver documentos embebidos, es decir que directamente están guardados dentro de otro documento, estando aninados.

Si debemos acceder muy frecuentemente al documento referenciado, se suele utilizar tenerlo embebebido. Genera redundancia y normalización, pero ganamos velocidad para las consultas.

La función **aggregate** opera a partir d un vector de documentos JSON, en donde cada documento describe una operación (wj group o match) del pipeline.

El pipeline de agregación de MongoDB ofrece las siguientes operaciones:

- match: filtrado de resultados
- group: agrupamiento de los resultados por uno o más atributos aplicando funciones de agregación
- sort
- limit
- sample: seleccion aleatoria de resultados
- unwind: deconstrucción de un atributo de tipo vector -> genera documentos distintos por cada valor del vector

**Sharding** es el modelo distribuido de procesamiento. Se basa en el particionamiento horizontal de las colecciones en _chunks_ que se distribuyen en nodos denominados **shards**. 

Un **sharding cluster** de MongoDB está formado por distintos tipos de nodos de ejecución:

- Los shards: nodos en los que distribuyen los chunks de las colecciones. Cada shard corre un proceso denominado mongod.
- Los routers: son los nodos servidores que reciben las consultas desde las aplicaciones clientes, y las resuelven comunicandose con los shards. Corren un proceso denominado _mongos_.
- Los servidores de configuración: almacenan la configuración de los routers y los shards.

insert imagen

El particionado de las colecciones se realiza a partir de un **shard key**, que es un atributo o conjunto de atributos de la colección que se escoge al momento de constuir el sharded cluster.

La asignación de documentos a shards se hace dividiendo en rangos los valores de la shard key (_range-based sharding_) o bien a partir de una función de hash aplicada sobre su valor.

En este contexto, es posible tener algunas colecciones sharded y otras unsharded. Las colecciones unsharded de una base de datos se almacenarán en un shard particular del cluster, que será el shard primario para esa base de datos. 

La realización de un sharding sobre una colección posee las siguientes restricciones:

1. Es conveniente que la shard key esté definida en todos los documentos de la colección.
2. La colección deberá tener un índice que comience con la shard key.
3. Desde MongoDB 5.0, una vez realizado el sharding se puede cambiar la shard key y desde la versión 4.2 se puede cambiar su valor.
4. No es posible defragmentar una colección que ya fue fragmentada.

El sharding permite:

- disminuir el tiempo de respuesta en sistema con alta carga de consultas.
- ejecutar consultas sobre conjuntos de datos muy grandes que no podrían caber en un único servidor.

El objetivo es que la bdd sea escalable para poder procesar Big Data.

insert 2da imagen

El esquema de réplicas es de master-slave:

- cada shard pasa a tener un servidor mong primario y uno o más servidores mongod secundarios (slaves). El conjunto de datos de réplicas de un shard se denomina **réplica set**.
- las réplicas eligen inicialmente un master a través de un algoritmo distribuido.
- cuando el master falla, los slaves eligen entre sí a un nuevo master.

También los servidores de configuración se implementan como replica sets. Todas las operaciones de escritura sobre el shard se realizan en el master. Los slaves solo sirven de respaldo.

Los clientes pueden especificar una read preference para que las lecturas sean enviadas a nodos secundarios de los shards.

## Bases de datos wide column

Son una evolución de las bdd clave-valor, ya que agrupan los pares vinculados a una misma entidad como columnas asociadas a una misma calve primaria. 

Un valor particular de la clave primaria junto con todas sus columnas asociadas forma un agregado análogo a la fila de una tabla. Además, estas bases permiten agregar conjuntos de columnas en forma dinámica a una fila, convirtiendola en un agregado llamado fila ancha.

Esta dinámica podría representar las interrelaciones de la entidad con otra entidad.

Las más conocidas son: Google BigTable, Apache HBase, Apache Cassandra.

| SGBD's relacionales | Cassandra         |
|---------------------|-------------------|
| Esquema             | *Keyspace*        |
| Tabla               | *Column family*   |
| Fila                | Fila              |
| -                   | *Wide row*        |

Cada keyspace puede estar distribuido en varios nodos de nuestro cluster.

Sí hace uso de PK!

insert imagen3

La estructura de Cassandra es un poco más compleja. La idea es que las columnas de una fila puedan variar dinámicamente en función de las necesidades. Ej: si un cliente nos compra libros, quisieramos agregar por cada libro comprado el ISBN y el nombre. Se define un listado de columnas que cada fila puede instanciar muchas veces.

Esto se resuelve seleccionando a una o más de las columnas como parte de la clave.

Cuando en una fila las columnas se repiten identificadas por el valor que toman las columnas clave, se dice que la fila se convirtió en una **wide row**.

Cada fila ahora se distingue por la clave de partición (el id "real") y una clave de clustering (la que otorga esta clave que puede ser instancia multiples veces)

A su vez, las columnas que no van a variar (siempre están asociadas a la misma PK), son llamadas **estáticas**.

CREATE COLUMNFAMILY clientes (
    nro_cliente int,
    nombre text static,
    ISBN bigint,
    nombre_libro text,
    primary key ((nro_cliente), ISBN);
)

Ambas partes de la clave primaria pueden ser a su vez simples o compuestas. Al igual en que en las bases relacionales, la clave primaria permita identificar a la fila.

Además la clave de particionado por si sola debe alcanzar para identificar a la wide-row.

No siempre vamos a pedir que la clave sea  minimal, podemos agregar atributos necesarios para las busquedas que tengamos que hacer.

La clave de particionado determina el/los nodo/s del cluster en que se guardará la wide-row.

Toda la wide-row se almacenará contigua en disco, y la clave de clustering nos determina el ordenamiento interno de las columnas dentro de ella.

Restricciones de consultas:

- las columnas que forman parte de la partition key **deben** ser comparadas por igual contra valores constantes en los predicados.
- Si una columna que forma parte de la clustering key es utilizada en un predicado, también deben ser utilizadas todas las restantes columnas que son parte de la clustering key. Si mi clustering key es <A1,A2,A3> y quisiera saber algo de A1, debo consultar por los valores de A2 y A3 también.
- Si una columna que forma parte de una clustering key es comparada por rango en un predcicado, entonces todas las columnas restantes de la CK que la preceden deben ser comparadas por igual, y las posteriores no deben ser utilizadas.

Cassandra permite trabajar con colecciones como tipos de dato: set, list y map.

No existe el concepto de junta! se debe manejar a nivel aplicación.

No existe el concepto de integridad referencial, también debe ser manejado desde el nivel de aplicación.

Diagrama de tablas:

insert imagen4

Para modelar las column family en Cassandra hay que:

- Definir el workflow: cuales son nuestras necesidades y qué consultas queremos responder. Supongamos que para una base de datos de una bibilioteca, queremos responder las siguientes consultas:

    - Q1: buscar libro por género.
    - Q2: buscar libro por nombre.
    - Q3: buscar libro por ISBN.
    - Q4: ver información de un libro.
    - Q5: ver información de un socio.
    - Q6: ver ejemplares disponibles de un libro.
    - Q7: asignar ejemplar a un socio.
    - Q8: consultar ejemplares que posee un socio.
    - Q9: encontrar socios morosos (con préstamos vencidos).
    
insert imagen workflow

Por cada consulta idearemos una column family que resuelva:

insert imagen column family

Cassandra está optimizado para altas tasas de escritura, utilizando un LSM-tree que mantiene parte de sus datos en memoria, para diferir los cambios sobre el índice en disco.

Se busca acceder en forma secuencial a disco, para mejorar el trade-off entre el costo de hacer un disk seek y el costo de un buffer en memoria.




