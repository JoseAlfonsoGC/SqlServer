/*podemos usar "GROUP BY" y las FUNCIONES DE AGRUPAMIENTO con COMBINACIONES DE TABLAS
Ejemplo en el cual pudiera a plicar
Para ver la cantidad de libros de cada editorial consultando la tabla "libros" y "editoriales", tipeamos:

 select nombre as editorial,
  count(*) as cantidad
  from editoriales as e
  join libros as l --Note que las editoriales que no tienen libros no aparecen en la salida porque empleamos un "join".
  on codigoeditorial=e.codigo
  group by e.nombre;
*/

--Empleamos otra función de agrupamiento con "left join". Para conocer el mayor precio de los libros de cada editorial usamos la función "max()", hacemos un "left join" y agrupamos por nombre de la editorial:

select nombre as editorial,
		max(precio) as 'mayor precio'
		from editoriales as e
		left join libros as l
		on codigoeditorial=e.codigo
		group by nombre;
		--En la sentencia anterior, mostrará, para la editorial de la cual no haya libros, el valor "null" en la columna calculada.
