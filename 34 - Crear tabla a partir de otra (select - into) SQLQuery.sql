/********************************Crear tabla a partir de otra (select - into)********************************/
--Podemos crear una tabla e insertar datos en ella en una sola sentencia consultando otra tabla (o varias) con esta sintaxis:
select CAMPOSNUEVATABLA
		into NUEVATABLA
		from TABLA
  where CONDICION;

--Es decir, se crea una nueva tabla y se inserta en ella el resultado de una consulta a otra tabla.

--Tenemos la tabla "libros" de una librer�a y queremos crear una tabla llamada "editoriales" que contenga los nombres de las editoriales.

--La tabla "editoriales", que no existe, contendr� solamente un campo llamado "nombre". La tabla libros contiene varios registros.

--Podemos crear la tabla "editoriales" con el campo "nombre" consultando la tabla "libros" y en el mismo momento insertar la informaci�n:
select distinct editorial as nombre
		into editoriales
	from libros;

/*
La tabla "editoriales" se ha creado con el campo "nombre" seleccionado del campo "editorial" de "libros".

Los campos de la nueva tabla tienen el mismo nombre, tipo de dato y valores almacenados que los campos listados de la tabla consultada; 
si se quiere dar otro nombre a los campos de la nueva tabla se deben especificar alias.

Entonces, luego de la lista de selecci�n de campos de la tabla a consultar, se coloca "into" seguido del nombre de la nueva tabla y se sigue con la consulta.

Podemos emplear "group by", funciones de agrupamiento y "order by" en las consultas. Tambi�n podemos emplear "select... into" con combinaciones, 
para crear una tabla que contenga datos de 2 o m�s tablas.

*/
