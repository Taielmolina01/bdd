(Usuario: username)-[:PUNTUA : puntaje]-(publicacion: titulo, id, contenido)

MATCH (u1:Usuario)-[p1:PUNTUA]-(p:publicacion)-[p2:PUNTUA]-(u2:usuario)
WHERE p1 >= 8 AND p2 >= 8 AND u1.username > u2.username
WITH u1, u2, p, COUNT(*) AS cantidad_publicaciones

WHERE cantidad_publicaciones >= 5 AND NOT EXISTS {
    MATCH (u1)-[p3:PUNTUA]-(p:publicacion)-[p4:PUNTUA]-(u2)
    WHERE (p3.puntaje >= 8 AND p4.puntaje <= 7) OR (p3.puntaje <= 7 AND p4.puntaje >= 8)
}
RETURN u1.username, u2.username



(NoSQL - MongoDB) El sitio de publicaciones cientificas Paper View guarda en una base de
datos Mongo los datos de los papers publicados con la siguiente estructura de documento:

PAPERS
{
    "_id"
    "titulo"
    "autores"
    "categoria"
    "puntaje"
}

Lo que buscan es obtener información sobre los autores de papers que pertenezcan a la
categoría “Informática”: para cada autor que haya publicado al menos 10 de esos papers,
quieren conocer la cantidad de esos papers publicados y el promedio de puntaje entre ellos,
con la siguiente estructura :

{
    autor 
    cantidad
    promedio_puntaje
}

a) Escriba una consulta en MongoDB que devuelva el listado según las condiciones indicadas.
b) Explique por qué atributos puede shardearse la colección de papers para que la resolución de la consulta 
sea lo más distribuida posible. En caso de que haya atributos por los que shardear haga la resolución menos distribuida,
indique cuales son con una breve explicación del por qué.

db.papers.aggregate([
    {
        $match: { "categoria": "Informática” }
    },
    {   
        $unwind: "$autores"
    },
    {
        $group: {
            _id: "$autores.autor", 
            count : {$sum: 1}
            puntaje: {$avg: "$puntaje"}
        }
    },
    {
        $match: {"count": {$gte: 10}}
    },
    {
        $project: {
            _id: 0,
            autor: "$_id",
            cantidad: "$count",
            promedio_puntaje: "$puntaje"
        }
    }
])

