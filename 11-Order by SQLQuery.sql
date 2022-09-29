/*Order by
se puedo ordenar el resultado de un "select" para que los registros se muestren ordenados por algún campo
*/

--sintaxis
select * from NOMBRETABLA
  order by CAMPO; --ejemplo, recuperamos los registros de la tabla "libros" ordenados por el título:

select * from libros
	order by titulo; --Aparecen los registros ordenados alfabéticamente por el campo especificado.

 select titulo,autor,precio
  from libros order by 3; -- También podemos colocar el número de orden del campo por el que queremos que se ordene en lugar de su nombre, 
  --es decir, referenciar a los campos por su posición en la lista de selección. Por ejemplo, queremos el resultado del "select" ordenado por "precio":

/*Por defecto, si no aclaramos en la sentencia, los ordena de manera ascendente (de menor a mayor).
Podemos ordenarlos de mayor a menor, para ello agregamos la palabra clave "desc"*/
 select * libros
  order by editorial desc;

--También podemos ordenar por varios campos, por ejemplo, por "titulo" y "editorial"
select * from libros
  order by titulo,editorial;

--Incluso, podemos ordenar en distintos sentidos, por ejemplo, por "titulo" en sentido ascendente y "editorial" en sentido descendente
select * from libros
  order by titulo asc, editorial desc;

/*
Debe aclararse al lado de cada campo, pues estas palabras claves afectan al campo inmediatamente anterior.

Es posible ordenar por un campo que no se lista en la selección.

Se permite ordenar por valores calculados o expresiones.

La cláusula "order by" no puede emplearse para campos text, ntext e image.

*/