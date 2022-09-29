--++++++++++++++++Funciones de conteo++++++++++ 
/*contar registros(count - count_big) agrupamiento o agregado (count - sum - min - max -avg) agrupar ( group by )*/
--en SQL Server funciones que nos permiten contar registros, calcular sumas, promedios, obtener valores máximos y mínimos

/********************Count()***********************/
--count: se puede emplear con cualquier tipo de dato.
select count(*)
  from libros; --La función "count()" cuenta la cantidad de registros de una tabla, incluyendo los que tienen valor nulo

--También podemos utilizar esta función junto con la cláusula "where" para una consulta más específica. Queremos saber la cantidad de libros de la editorial "Planeta":
select count(*)
  from libros
  where editorial='Planeta';
--Para contar los registros que tienen precio (sin tener en cuenta los que tienen valor nulo), usamos la función "count()" y en los paréntesis colocamos el nombre del campo que necesitamos contar:
select count(precio)
  from libros;
/*******************Count_big()**********************/
--Es muy parecido a count, solo que "count_big" retorna un valor "bigint" y "count", un "int".

--"count_big(*)" cuenta la cantidad de registros de una tabla, incluyendo los valores nulos y duplicados.
--Ejemplo
select count_big(*) --Averiguemos la cantidad de libros usando la función "count_big()"
  from libros;
  where editorial='planeta';--se puede usar where

--"count_big(CAMPO)" retorna la cantidad de registros cuyo valor en el campo especificado entre paréntesis no es nulo.
--Ejemplo
select count_big(precio) --Contamos los registros que tienen precio (sin tener en cuenta los que tienen valor nulo)
  from libros;
---"count_big(distinct CAMPO)" retorna la cantidad de registros cuyo valor en el campo especificado no es nulo, sin considerar los repetidos.
--Ejemplo
select count_big(distinct editorial) --Contamos las editoriales (sin repetir)
  from libros;
/**************************sum***************************/
--sum: sólo en campos de tipo numérico

--La función "sum()" retorna la suma de los valores que contiene el campo especificado. Si queremos saber la cantidad total de libros que tenemos disponibles para la venta, debemos sumar todos los valores del campo "cantidad":
select sum(cantidad)
		from libros;

/***************************max**************************/
--Para averiguar el valor máximo o mínimo de un campo usamos las funciones "max()" y "min()" respectivamente. Queremos saber cuál es el mayor precio de todos los libros:
select max(precio)
		from libros;
/***************************avg**************************/
--avg: sólo en campos de tipo numérico
--La función "avg()" retorna el valor promedio de los valores del campo especificado. Queremos saber el promedio del precio de los libros referentes a "PHP":
select avg(precio)
		from libros
		where titulo like '%PHP%';
/*************************group by**********************/
-- si queremos saber la cantidad de libros de cada editorial, podemos tipear la siguiente sentencia:
select count(*) from libros
		where editorial='Planeta';
--y repetirla con cada valor de "editorial":
select count(*) from libros
  where editorial='Emece';
 select count(*) from libros
  where editorial='Paidos';
 ...

--es mas sencillo usar 
 select editorial, count(*)
  from libros
  group by editorial;
--La instrucción anterior solicita que muestre el nombre de la editorial y cuente la cantidad agrupando los registros por el campo "editorial". 
--Como resultado aparecen los nombres de las editoriales y la cantidad de registros para cada valor del campo
-- sintaxis 
select CAMPO, FUNCIONDEAGREGADO
  from NOMBRETABLA
  group by CAMPO;
--También se puede agrupar por más de un campo, en tal caso, luego del "group by" se listan los campos, separados por comas. Todos los campos que se especifican en la cláusula "group by" deben estar en la lista de selección.
 select CAMPO1, CAMPO2, FUNCIONDEAGREGADO
  from NOMBRETABLA
  group by CAMPO1,CAMPO2;

select editorial, count(precio)--sin contar los que tienen precio nulo. podemos usar (max, , min, suma, avg)
  from libros
  group by editorial;

select editorial, count(*)
  from libros
  where precio<30 --se puede hacer uso de where
  group by editorial;

