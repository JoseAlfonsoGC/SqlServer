--++++++++++++++++Funciones de conteo++++++++++ 
/*contar registros(count - count_big) agrupamiento o agregado (count - sum - min - max -avg) agrupar ( group by )*/
--en SQL Server funciones que nos permiten contar registros, calcular sumas, promedios, obtener valores m�ximos y m�nimos

/********************Count()***********************/
--count: se puede emplear con cualquier tipo de dato.
select count(*)
  from libros; --La funci�n "count()" cuenta la cantidad de registros de una tabla, incluyendo los que tienen valor nulo

--Tambi�n podemos utilizar esta funci�n junto con la cl�usula "where" para una consulta m�s espec�fica. Queremos saber la cantidad de libros de la editorial "Planeta":
select count(*)
  from libros
  where editorial='Planeta';
--Para contar los registros que tienen precio (sin tener en cuenta los que tienen valor nulo), usamos la funci�n "count()" y en los par�ntesis colocamos el nombre del campo que necesitamos contar:
select count(precio)
  from libros;
/*******************Count_big()**********************/
--Es muy parecido a count, solo que "count_big" retorna un valor "bigint" y "count", un "int".

--"count_big(*)" cuenta la cantidad de registros de una tabla, incluyendo los valores nulos y duplicados.
--Ejemplo
select count_big(*) --Averiguemos la cantidad de libros usando la funci�n "count_big()"
  from libros;
  where editorial='planeta';--se puede usar where

--"count_big(CAMPO)" retorna la cantidad de registros cuyo valor en el campo especificado entre par�ntesis no es nulo.
--Ejemplo
select count_big(precio) --Contamos los registros que tienen precio (sin tener en cuenta los que tienen valor nulo)
  from libros;
---"count_big(distinct CAMPO)" retorna la cantidad de registros cuyo valor en el campo especificado no es nulo, sin considerar los repetidos.
--Ejemplo
select count_big(distinct editorial) --Contamos las editoriales (sin repetir)
  from libros;
/**************************sum***************************/
--sum: s�lo en campos de tipo num�rico

--La funci�n "sum()" retorna la suma de los valores que contiene el campo especificado. Si queremos saber la cantidad total de libros que tenemos disponibles para la venta, debemos sumar todos los valores del campo "cantidad":
select sum(cantidad)
		from libros;

/***************************max**************************/
--Para averiguar el valor m�ximo o m�nimo de un campo usamos las funciones "max()" y "min()" respectivamente. Queremos saber cu�l es el mayor precio de todos los libros:
select max(precio)
		from libros;
/***************************avg**************************/
--avg: s�lo en campos de tipo num�rico
--La funci�n "avg()" retorna el valor promedio de los valores del campo especificado. Queremos saber el promedio del precio de los libros referentes a "PHP":
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
--La instrucci�n anterior solicita que muestre el nombre de la editorial y cuente la cantidad agrupando los registros por el campo "editorial". 
--Como resultado aparecen los nombres de las editoriales y la cantidad de registros para cada valor del campo
-- sintaxis 
select CAMPO, FUNCIONDEAGREGADO
  from NOMBRETABLA
  group by CAMPO;
--Tambi�n se puede agrupar por m�s de un campo, en tal caso, luego del "group by" se listan los campos, separados por comas. Todos los campos que se especifican en la cl�usula "group by" deben estar en la lista de selecci�n.
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

