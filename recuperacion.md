# Recuperable

Nos interesa asegurar que una vez que una transacción commiteó, la misma no deba ser deshecha.

Un solapamiento es **recuperable** si y solo si ninguna transacción T realiza el commit hasta tanto todas las transacciones que escribieron datos antes de que T los leyera hayan commiteado.

Un SGBD no debería JAMAS permitir la ejecución de un solapamiento que no sea recuperable.

Para deshacer los efectos de una transacción Tj que hay que abortar, sin afectar la serializabilidad de las transacciones restantes:

- si las modificaciones hechas por Tj no fueron leídas por nadie, entonces hacemos rollback y listo.

- si una transacción Ti leyó un dato modificado por Tj, entonces será necesario hacer el rollback de Ti para volver a ejecutar.

**Resultado**: si un solapamiento de transacciones es recuperable, entonces nunca será necesario deshacer transacciones que ya hayan commiteado.

Que un solapamiento sea recuperable, no implica que no sea necesario tener que hacer rollbacks en cascada de transacciones que aún no commitearon.

Para evitar los rollbacks en cascada es necesario que una transacción no lea los valores que aún no fueron commiteados.

Evitas cascadas de rollbacks -> recuperabilidad.

PROHIBIDO ENTONCES (WTi(X);RTj(X)) sin que en el medio haya un commit.

## Protocolo de 2PL estricto

Una transacción no puede adquirir un lock luego de haber liberado un lock que había adquirido, y además los locks de escritura solo pueden ser liberados después de haber commiteado la transacción.

## Protocolo de R2PL

Los locks solo pueden ser liberados después del commit.

S2PL y R2PL garantizan que todo solapamiento sea no solo serializable, sino también recuperable, y que no se producirán cascadas de rollbacks al deshacer una transacción.

## Control de concurrencia basado en timestamps

Para garantizar la recuperabilidad se puede escoger entre varias opciones:

- no hacer el commit de una transacción hasta que todas aquellas transacciones que modificaron datos que ella leyó hayan hecho su commit. Garantiza recuperabilidad.
- Bloquear a la transacción lectora hasta tanto la escritora haya hecho su commit. Esto evita rollbacks en cascada.
- Hacer todas las escrituras durante el commit, manteniendo una copia paralela de cada ítem para cada transacción. Para esto, la escritura de los ítems en el commit deberá ser centralizada y ser atómica.

# Recuperación

Los sistemas reales sufren múltiples tios de falla:

- De sistema: por errores de software o hardware que detienen la ejecución de un programa (división por cero)
- De aplicación: Aquellas que provienen desde la aplicación que utiliza la base de datos. Por ejemplo, la cancelación o vuelta atrás de una transacción.
- De dispositivos: Daño físico en dispositivos como discos rígidos o memoria.
- Naturales externas: caidas de tensión, terremotos, incendios.

En situaciones catastróficas como las últimas dos, es necesario contar con mecanismos de backup para recuperar la información.

Para garantizar las propiedades ACID en situaciones no catastróficas como 1 y 2 veremos las sugientes formas de resolverlo.

Si en algun momento ocurre una falla, el sistema se reinicia y la base de datos deberá ser llevada al estado inmediato anterior al comienzo de la transacción. 

Para ello, es necesario mantener información en el log acerca de los cambiós que la transacción fue ralizando.

Para cada instrucción de escritura:

X -> Buffer en memoria -> Disco

Existen dos técnicas:

- Inmmediate update: datos se guardan en disco lo antes posible y necesariamente antes del commit de la transacción.

- Deferred update: los datos se guardan en disco después del commit de la transacción.

El **gestor de recuperación** del SGBD es gracias a quien se puede recuperar de fallas, guardando la información en un _log_.

Almacena los sigueintes registros:

- (BEGIN, Tid): indica que la transacción Tid comenzó.
- (WRITE, Tid, X, Xold, Xnew): indica que la transacción Tid escribió el item X, cambiando su viejo valor Xold por un nuevo valor Xnew.
- (READ, Tid, X): indica que la transacción Tid leyó el item X.
- (COMMIT, Tid): Indica que la transacción Tid commiteó.
- (ABORT, Tid): Indica que la transacción Tid abortó.

El gestor de logs se guía por dos reglas básicas:

- WAL (Write Ahead Log): indica que antes de guardar un ítem modificado en disco, se debe escribir el registro de log correspondiente, en disco.
- FLC (Force Log at Commit): indica que antes de realizar el commit el log debe ser volcado a disco.

Existen 3 algoritmos distintos que permiten recuperar una bdd:

- UNDO
- REDO
- UNDO/REDO

En los tres **se asume** que los solapamientos de transacciones son:

- Recuperables
- Evitan rollbacks en cascada

Procedimiento del UNDO:

- Cuando una transacción Ti modifica el ítem X reemplazando un valor Vold por V, se escribe (WRITE, Ti, X, Vold) en el log, y se hace flush del log a disco.
- El registro debe ser escrito en el log en disco antes de escribir el nuevo valor de X en disco
- Todo item modificado debe ser guardado en disco antes de hacer commit.
- Cuando Ti hace commit, se escribe (COMMIT, Ti) en el log y se hace flush del log a disco (FLC).

Cuando el sistema reinicia:

- Se recorre el log de adelante hacia atrás, y por cada transacción de la que no se encuentra el COMMIT se aplica cada uno de los WRITE para restaurar el valor anterior a la misma en disco.
- Luego por cada transacción de la que no se encontró el COMMIT se escribe (ABORT, T) en el log y se hace flug del log a disco.

Procedimiento del REDO:

- Cuando una transacción Ti modifica el item X reemplazando un valor Vold por V, se escribe (WRITE, Ti, X, v) en el log.
- Cuando Ti hace commit, se escribe (COMMIT, Ti) en el log y se hace flush del log a disco (FLC). Recién ahí se escribe el nuevo valor en disco.

Si la transacción falla antes del commit no será necesario deshcaer nada. Si en cambio falla despues de haber escrito el COMMIT en disco, la transacción será rehecha al iniciar.

Cuando el sistema reinicia se siguen los siguientes pasos:

1. Se analiza cuáles son las transacciones de las que está registrado el COMMIT.
2. Se recorre el log de atrás hacia adelante volviendo a aplicar cada uno de los WRITE de las transacciones que commitearon, para asegurar que quede actualziado el valor de cada item.
3. Luego por cada transacción de la que no se encontró el COMMIT se escribe (ABORT, T) en el log y se hace flush del log a disco.

Procedimiento del UNDO/REDO:

1. Cuando una transacción T_i modifica el item X reemplazando valor Vold por v, se escribe (WRITE, Ti, X, Vold, V) en el log.
2. El registro (WRITE, Ti, X, Vold, V) debe ser escrito en el log en disco antes de escribir el nuevo valor de X en disco.
3. Cuando Ti hace commit, se escribe (COMMIT, Ti) en el log y se hace flug del log a disco.
4. Los items modificados pueden ser guardados en disco antes o despues de hacer commit.

Cuando el sistema reinicia se siguen los siguientes pasos:

1. Se recorrer el log de adelante hacia atrás, y por cada transacción de la que no se encuentra el COMMIT se aplica cada uno de los WRITE para restaurar el valor anterior a la misma en disco.
2. Luego se recorre de atrás hacia adelante volviendo a aplicar cada uno de los WRITE de las transacciones que commitearon, para asegurar que quede asignado el nuevo valor de cada item.
3. Finalmente, por cada transacción de la que no se encontró el COMMIT se escribe (ABORT, Ti) en el log y se hace flush del log a disco.

Se utilizan checkpoints para no recorrer todo el archivo de log (si se muere una bdd dsp de 5 años me voy a querer matar).

Un checkpoint es un registro especial en el archivo de log que indica que todos los items modificados hasta ese punto han sido almacenados en disco.

Los **checkpoints inactivos** tiene un único tipo de registro. Implica la suspensión momentánea de todas las transacciones para hacer el volcado de todos los buffers en memoria al disco. Los **checkpoints activos** utiliza dos registros (BEGIN CKPT, t act) y (END CKPT) en donde t act es un listado de todas las transacciones que se encuentran activas (que aun no hicieron commit).

En el algoritmo UNDO, el procedimiento de chekpointing inactivo se realiza de la siguiente manera:

1. Dejar de aceptar nuevas transacciones.
2. Esperar a que todas las transacciones hagan su commit.
3. Escribir CKPT en el log y volcarlo a disco.

En el algoritmo UNDO, el procedimiento de chekpointing activo se realiza de la siguiente manera:

1. Escribir un registro (BEGIN CKPT, Tact) con el listado de todas las transacciones activas hasta el momento.
2. Esperar a que todas esas transacciones activas hagan su commit (sin dejar por eso de recibir nuevas transacciones).
3. Escribir (END CKPT) en el log y volcarlo a disco.

En la recuperación, al hacer el rollback se dan dos situaciones:

- Encontrar primero un registro (END CKPT). En ese caso, solo debemos retroceder hasta el (BEGIN CKPT) durante el rollback porque ninguna transacción incompleta puede haber comenzado antes.

- Encontrar primero un registro (BEGIN CKPT). Esto implica que el sistema cayó sin asegurar los commits del listado de transacciones. Deberemos volver hacia atrás pero solo hasta el inicio de la más antigua del listado.

En el algoritmo REDO, el procedimiento de chekpointing activo se realiza de la siguiente manera:

1. Escribir un registro (BEGIN CKPT, Tact) con el listado de todas las transacciones activas hasta el momento y volcar el log a disco.
2. Hacer el volcado a disco de todos los items que hayan sido modificados por transacciones que ya commitearon.
3. Escribir (END CKPT) en el log y volcarlo a disco.

En la recuperación, hay nuevamente dos situaciones:

- Que encontremos primero un (END CKPT). En ese caso debemos retroceder hasta el (BEGIN, Tx) más antiguo del listado que figure en el (BEGIN CKPT) para rehacer todas las transacciones que commitearon. Escribir (ABORT, Ty) para aquellas que no hayan commiteado.

- Que encontremos primero un registro (BEGIN CKPT). Si el checkpoint llego solo hasta este punto no nos sirve y entonces debemos ir a buscar un checkpoint anterior en el log.

En UNDO/REDO con checkpointing activo el procedimiento es:

1. Escribir un registro (BEGIN CKPT, Tact) con el listado de todas las transacciones activas hasta el momento y volcar el log a disco.
2. Hacer el volcado a disco de todos los ítems que hayan sido modificados antes del (BEGIN CKPT)
3. Escribir (END CKPT) en el log y volcarlo a disco.

En la recuperación es posible que debamos retroceder hasta el inicio de la transacción más antigua en el listado de transacciones, para deshacerla en caso de que no haya commiteado, o para rehacer sus operaciones posteriores al BEGIN CKPT, en caso de que haya commiteado.
