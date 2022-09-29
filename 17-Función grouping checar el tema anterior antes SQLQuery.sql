/*Función grouping
La función "grouping" se emplea con los operadores "rollup" y "cube" para distinguir los valores de detalle y de resumen en el resultado. Es decir, permite diferenciar si los valores "null" que aparecen en el resultado son valores nulos de las tablas o si son una fila generada por los operadores "rollup" o "cube".

Con esta función aparece una nueva columna en la salida, una por cada "grouping"; retorna el valor 1 para indicar que la fila representa los valores de resumen de "rollup" o "cube" y el valor 0 para representar los valores de campo.

Sólo se puede emplear la función "grouping" en los campos que aparecen en la cláusula "group by"
*/
/*Si tenemos una tabla "visitantes" con los siguientes registros almacenados:
Nombre		sexo	ciudad
-------------------------------
Susana Molina	f	Cordoba
Marcela Mercado	f	Cordoba
Roberto Perez	f	null
Alberto Garcia	m	Cordoba
Teresa Garcia	f	Alta Gracia
*/
--y contamos la cantidad agrupando por ciudad (note que hay un valor nulo en dicho campo) empleando "rollup":
select ciudad,
		count(*) as cantidad
		from visitantes
		group by ciudad
		with rollup;
--aparece la siguiente salida:
/*
ciudad		cantidad
-------------------------
NULL		1
Alta Gracia	1
Cordoba		3
NULL		5
*/

--La última fila es la de resumen generada por "rollup", pero no es posible distinguirla de la primera fila, en la cual "null" es un valor del campo. Para diferenciarla empleamos "grouping":
select ciudad,
		count(*) as cantidad,
		grouping(ciudad) as resumen
		from visitantes
		group by ciudad
		with rollup;
--aparece la siguiente salida:
/*
ciudad		cantidad	resumen
---------------------------------------
NULL		1		0
Alta Gracia	1		0
Cordoba		3		0
NULL		5		1
*/

--La última fila contiene en la columna generada por "grouping" el valor 1, indicando que es la fila de resumen generada por "rollup"; la primera fila, contiene en dicha columna el valor 0, que indica que el valor "null" es un valor del campo "ciudad"