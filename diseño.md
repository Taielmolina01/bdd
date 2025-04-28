Dada una relación R(A), una **dependencia funcional** X → Y, con X, Y ⊂ A es una restricción sobre las posibles tuplas de R que implica que dos tuplas con igual valor del conjunto de atributos X deben también tener igual valor del conjunto de atributos Y.

    ∀s, t ∈ R : s[X] = t[X] → s[Y] = t[Y]
    
Cuando Y ⊂ X decimos que X → Y es trivial.

Las dependencias funcionales se definen a partir de la semántica de los datos. ¡No es posible inferirlas viendo los datos!

Las **formas normales** son una serie de estructuras con las que un esquema de base de datos puede cumplir ó no.

- Primera forma normal (1FN) (E. Codd, 1970)
- Segunda forma normal (2FN) (E. Codd, 1971)
- Tercera forma normal (3FN) (E. Codd, 1971)
- Forma normal Boyce-Codd (FNBC) (R. Boyce E. Codd, 1974)
- Cuarta forma normal (4FN) (R. Fagin, 1977)
- Quinta forma normal (5FN) (R. Fagin, 1979)

Cada forma normal es más fuerte que las anteriores –en el orden en que las hemos introducido–. Entonces:

S está en 5FN → S está en 4FN → ... S está en 2FN → S está en 1FN.

En 1972 E. Codd propuso el concepto de **normalización** como el proceso a través del cual se convierte un esquema de base de datos en uno equivalente (i.e., que preserva toda la información) y que cumple con una determinada forma normal.

El objetivo es:
- Preservar la información
- Eliminar la redundancia
- Evitar las anomalías de ABM

Decimos que un esquema de base de datos relacional está en **primera forma normal (1FN)** cuando los dominios de todos sus atributos sólo permiten valores atómicos (es decir, indivisibles) y monovaluados.

[Profesores](profesores.png)

Observemos que nombre_dpto no depende de la clave primaria completa, sino sólo de una parte. Decimos que la dependencia PK → nombre_dpto es una **dependencia funcional parcial**.
Esto es así porque nombre_dpto solo depende de cual sea el valor de la columna asignatura.

Una **dependencia funcional** X → Y es **parcial** cuando existe un subconjunto propio A ⊂ X, A != X para el cual A → Y.

Una **dependencia funcional** X → Y es **completa** si y sólo si no es parcial.

**Atributo primo de una relación**: Es aquel que es parte de alguna clave candidata de la relación.

Decimos que una relación está en **segunda forma normal (2FN)** cuando todos sus atributos no primos tienen dependencia funcional completa de las claves candidatas.

Resolviendo la situación del ejemplo:

- DocenteAsignatura(nombre_profesor, asignatura)
- AsignaturaDepartamento(asignatura, nombre_dpto)

Una **dependencia funcional** X → Y es **transitiva** cuando existe un conjunto de atributos Z que satisface dependencias X → Z y Z → Y, siendo Z → Y no trivial, X → Y no trivial y Z !→ X.

Ejemplo: Ventas

[Ventas](ventas.png)

{nro_factura, nro_item} determinan cod_producto y a su vez cod_producto determina el nombre_producto

Uno de los atributos no primos puede deducirse a través de otro atributo no primo.

Observación: toda dependencia funcional parcial no trivial es transitiva.

Decimos que una relación está en **tercera forma normal (3FN)** cuando no existen dependencias transitivas CK_i → Y de atributos no primos (i.e Y !⊂ U_i CK_i) con CK_i clave candidata.

Una definición equivalente es que para toda dependencia funcional no trivial X -> Y, o bien X es superclave, o bien Y - X contiene solo atributos primos.

**Forma normal Boyce-Codd (FNBC)**

alumno; materia; profesor

Cada materia es dictada por muchos profesores pero un estudiante solo cursa con uno de ellos. La universidad tiene la restricción de que un profesor solo puede dictar una materia.

Dependencias funcionales no triviales

P -> M
AM -> P

(
innecesaria pero tmb existe
AP -> M
)

CC = <AM>; <AP>

Todo esto está en 3FN porque 

P no es superclave pero M - P = M es atributo primo, cumple con 3FN
AM es CC, cumple con 3FN
AP es CC, cumple con 3FN

La **FNBC** impide que suceda la redundancia de tener los profesores y materia repetidos, ya que por cada alumno sabiendo con que profesor cursó, podemos deducir qué materia cursó tmb. Al revés no se cumple porque las materias están dadas por más de un profesor.

{profesor, alumno} -> profesor -> materia

Una relación está en **FNBC** cuando no existen dependencias transitivas CK -> Y, con CK clave candidata.

Una relación está en **FNBC** cuando para toda dependencia funcional no trivial X -> Y, X es superclave.

Descomponemos en dos tablas que sean <AP> y <PM>

Dependencia multivaluada

Decimos que X ->> Y (X determina de forma multivaluada a Y) cuando un mismo X siempre se asocia con el mismo conjunto de valores Y.

## Resumen
 
### Formas normales

#### 2FN

No hay dependencia parcial para atributos no primos sobre las claves candidatas

#### 3FN 

Para toda depedencia X -> Y no trivial, o X es superclave o Y - X son atributos primos

#### FNBC

Para toda dependencia X -> Y no trivial, X es superclave de R

**Atributo primo** Pertenece al menos a una clave candidata

Equivalencia de conjuntos de dependencias

Buscamos tener un conjunto de dependencias minimal

Dos conjuntos F y G son equivalentes cuando cada uno de ellos es cubierto por el otro. 

## Algoritmos

### Algoritmo para conseguir conjunto minimal (Fmin)

- PASO 1: Busco que todo lado derecho tenga un único atributo (desdoblas las deps de la derecha)
- PASO 2: Quitar atributos innecesarios del lado izquierdo: busco clausuras sacando de a un atributo en aquellas clausulas que tengan >= 2 atributos del lado izquierdo; in other words, busco por cada conjunto de N atributos, cada subconjunto de N-1 atributos (hasta N-1=1) del lado izquierdo hacia que otros atributos llego)
- PASO 3:

Ejemplo:

R(A, B, C, D, E, F, G)
F = {AB -> C, C -> A, BC -> D, ACD -> B, D -> EG, BE -> C, CG -> BD, CE -> AG}

Paso 1: 
F1 = {AB -> C, 
    C -> A, 
    BC -> D, 
    ACD -> B,
    D -> E, 
    D -> G, 
    BE -> C, 
    CG -> B, 
    CG -> D,
    CE -> A, 
    CE -> G}

Paso 2:
A^{+}_{F} = {A}
B^{+}_{F} = {B}
C^{+}_{F} = {AC}
E^{+}_{F} = {E}
G^{+}_{F} = {G}
AC^{+}_{F} = {AC}
AD^{+}_{F} = {ADEG} (con D solo llego a E y también llego a G)
CD^{+}_{F} = {ABCDEG} (acá veo que con CD ya llego a B) EN ESTE MOMENTO, ya cambio la clausura original de ACD -> B. AHORA me fijo si con D sola llego a B, ya que con C sé que no
D^{+}_{F} = {DEG}

F2 = {AB -> C, 
    C -> A, 
    BC -> D, 
    CD -> B,
    D -> E, 
    D -> G, 
    BE -> C, 
    CG -> B, 
    CG -> D,
    C -> A, 
    CE -> G}
    
PASO 3: Eliminar DFs redundantes

Temporalmente sacamos dep a dep y sobre el conjunto sin esa dep nos fijamos la clausura de esa misma dep a ver si llegamos a lo de la derecha

F2 = {AB -> C, 
    C -> A, 
    BC -> D, 
    CD -> B,
    D -> E, 
    D -> G, 
    BE -> C, 
    CG -> B, 
    CG -> D,
    CE -> G}

saco AB -> C y calculo AB^{F}_{aux} = {AB} La dep es necesaria
saco C -> A y calculo C^{F}_{aux} = {C} La dep es necesaria
saco BC -> D y calculo BC^{F}_{aux} = {ABC} La dep es necesaria
saco CD -> B y calculo CD^{+}_{aux} = {ABCDEG}. Saco esta dep porque ya podia determinar sin CD->B que efectivamente CD determina B. EN ESTE MOMENTO SACO LA DF 

F2 = {AB -> C, 
    C -> A, 
    BC -> D, 
    D -> E, 
    D -> G, 
    BE -> C, 
    CG -> B, 
    CG -> D,
    CE -> G}
    
saco D -> E y calculo D^{F}_{aux} = {DG} La dep es necesaria
saco D -> G y calculo D^{F}_{aux} = {DE} La dep es necesaria
saco BE -> C y calculo BE^{F}_{aux} = {BE} La dep es necesaria
saco CG -> B y calculo CG^{F}_aux = {ACDEG} La dep es necesaria, nos podríamos haber dado cuenta desde un inicio porque B no estaba en ninguna otra dep a la derecha
saco CG -> D y calculo CG^{F}_{aux} = {ABCDG} La dep NO es necesaria, saco esta dep

F2 = {AB -> C, 
    C -> A, 
    BC -> D, 
    D -> E, 
    D -> G, 
    BE -> C, 
    CG -> B, 
    CE -> G}
    
saco CE -> G y calculo CE^{F}_{aux} = {ACE} La dep es necesaria

RTA FINAL

Fmin = {AB -> C, 
    C -> A, 
    BC -> D, 
    D -> E, 
    D -> G, 
    BE -> C, 
    CG -> B, 
    CE -> G}
    
### Algoritmo de búsqueda de claves candidatas

Si tengo un subconjunto de tam N-1 es CC NO tengo que probar ningun subconjunto de tam N o >N porque ya se que NO va ser CC porque no va cumplir que sea minimal

Teniendo un Fmin los atributos pueden
    - No estar en ninguna DF. Está en todas las CCs (porque nadie lo determina). Es un atributo independiente.
    - Estar solamente en lados izquierdos. Está en todas las CCs (porque nadie lo determina tampoco). Es un atributo independiente.
    - Estar solamente en lados derechos. No está en ninguna clave candidata. Es 100% dependiente
    - Estar tanto en lados izquierdos como derechos. Puede estar o no en alguna clave
    
Ejemplo:

R(A,B,C,D,E,F,G,H,I,J)

Fmin = {AB -> C, A-> D, A->E, B->F, F->H, D->I, D->J, B->A, H->G}
    
| A | B | C | D | E | F | G | H | I | J |
|---|---|---|---|---|---|---|---|---|---|
| I | I |   | I |   | I |   | I |   |   |
| D |   | D | D | D | D | D | D | D | D |

B está en todas las claves candidatas
C,E,G,I,J no están en ninguna clave candidata

Calculamos clausura de las que están en todas las CCs

B ={ABDEFGHIJ} Incluye a todos los atributos de R. B es CC. NO hay forma de hacer otro conjunto q incluya a B y que sea minimal. JOSE MARÍA LISTORTI

Si no probaba todos los conjuntos que tengan a B y que incluyan a las que sean I, D

Segundo ejemplo

R(A,B,C,D,E,F,G)

Fmin={AB->F,D->A,E->D,D->E,CF->B,B->C}

E->D y D->E, son atributos equivalentes. reemplazo uno de los dos por el otro

Raux(A,B,C,D,F,G)
Fminaux={AB->F, D->A, CF->B, B->C}

| A | B | C | D | F | G |
|---|---|---|---|---|---|
| I | I | I | I | I |   | 
| D | D | D |   | D |   |

G es un atributo independiente => está en todas las CCs
D no es determinado por nadie => está en todas las CCs
A,B,C,F pueden o no estar

{DG}^{+}_{aux} = {ADG} no es CC
{ADG}^{+}_{aux} = {ADG} no es CC
{BDG}^{+}_{aux} = {ABCDFG} **es CC**
{CDG}^{+}_{aux} = {ACDG} no es CC
{FDG}^{+}_{aux} = {ADFG} no es CC

NO INCLUYO A BDG PORQUE YA SE QUE ES CC

{ACDG}^{+}_{aux} = {ACDG} no es CC
{ADFG}^{+}_{aux} = {ADFG} no es CC
{CDFG}^{+}_{aux} = {ABCDFG} **es CC**

SIEMPRE BUSCAMOS TODAS LAS CLAVES CANDIDATAS

## DescomposiciÓn

Sea R(A,B,C,D,E,G) y Fmin = {AB->C, C->B, E->D, D->G, G->E, C->G}

### Calcular CCs

E->D, D->G, G->E, son equivalentes.

Sea Raux(A,B,C,D) y Fauxmin= {AB->C, C->B, C->D}

| A | B | C | D |
|---|---|---|---|
| I | I | I |   |
|   | D | D | D |

A en todas las CC
B y C pueden o no
D en ninguna

A^{+}_{aux} = {A} no es CC

AB^{+}_{aux} = {ABCD} es CC
AC^{+}_{aux} = {ABCD} es CC

Raux tiene 2 CCs {AB} y {AC}
R original tambien


### Pasar a 3FN

Sea R(A,B,C,D,E,G) y 
Fmin = {AB->C, C->B, E->D, D->G, G->E, C->G}
CCs {AB} y {AC}

Para esto necesitamos tener un FMIN

Primer paso: armar un Ri con todos los atributos de cada DF

R1(ABC)
R2(CB)
R3(ED)
R4(DG)
R5(GE)
R6(CG)

Segundo paso: fijarme si alguna CC está totalmente contenida en algun R_i

Si ninguna CC está contenida completamente contenida en algun R_i, TENGO QUE AGREGAR UN NUEVO R_I con una de las CCs

Tercer paso: si una relación está COMPLETAMENTE incluida en otra, quito la de menos cosas

R1(ABC)
R3(ED)
R4(DG)
R5(GE)
R6(CG)

Cuarto paso: por cada R_i, calcular sus CCs

R1(ABC) AB -> C, C -> B
R3(ED) E -> D, D -> E
R4(DG) D -> G, G -> D
R5(GE) G -> E, E -> G
R6(CG) C -> G

Agregar aquellas donde solo hayan atributos pertenecientes al R_i y dsp mirar si se pueden agregar otras DFs

Quinto paso: ver las CCs

R1(ABC) CCs {AB} {AC}
R3(ED) CCs {E} {D}
R4(DG) CCs {D} {G}
R5(GE) CCs {G} {E}
R6(CG) CCs {C}

Sexto paso: si tengo CCs repetidas las junto las relaciones

R1(ABC) CCs {AB} {AC}
R3(EDG) CCs {D} {E} {G}
R5(CG) {C}

### Pasar a FNBC

Sea R(A,B,C,D,E,G) y Fmin = {AB->C, C->B, E->D, D->G, G->E, C->G}
CCs {AB} y {AC}

Ejemplo:

                                ABCDEG
                        descompongo por C ->B 
    BCDEG                                           AC

de lado izquierdo me fijo a todo lo que puedo llegar, de lado derecho queda C U lo que no quedo del lado izquierdo

ahora veo que dependencias funcionales hay de cada lado

                                ABCDEG
                        descompongo por C ->B 
    BCDEG                                           AC
C -> B                                              ni A -> C, ni C -> A, NO hay DFs, CC={AC}
E -> D
D -> G
G -> E
C -> G
CCs = {C}

E -> D, D->G y G->E violan FNBC

Elijo una DF entre estas

                                                    ABCDEG
                                            descompongo por C ->B 
                        BCDEG                                           AC
                descompongo por E->D
            DEG                 BCE
    
    E -> D                      C -> B
    D -> G                      C -> E (implícito)
    G -> E
    
CCs = {E} {D} {G}               CCs = {C}

Los tres estan en FNBC porque todo lo de la izquierda son CCs

Las relaciones con las que me quedo son son las HOJAS de este árbol

R1(DEG) con E -> D, D -> G, G -> E; CCs {E} {D} {G}
R2(BCE) con C -> B, C -> E; CCs {C}
R3(AC) sin DFs; CCs {AC}

¿Se perdieron DFs? SÍ, AB -> C pero NO hay pérdida de información


