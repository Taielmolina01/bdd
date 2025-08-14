```
db.platos.aggregate([
	{
		$unwind: "$puntajes"
	}, 
	{
		$group: {
			_id: {
				plato: "$puntajes.plato",
				barrio: "$barrio"
			},
			puntajes: { $push: "$puntajes.puntuacion"},
			votantes: { $sum: 1}
		}
	},
	{
		$group: {
			_id:  "$_id.plato",
			puntuacion_promedio: { $avg: "$puntajes" },
			barrios: {$push: {barrio: "$_id.barrio", cantidad_votantes: "$votantes"}}
		}
	},
	{
		$project: {
			_id: 0,
			plato: "$_id",
			puntuacion_promedio: 1,
			barrios: 1
		}
	}
])
```
