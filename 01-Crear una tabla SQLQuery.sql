/*
	una base de datos es una recopilaci�n organizada de informaci�n o datos estructurados, almacenados de forma electr�nica en tablas por uno o mas sistema inform�tico 
	
	una tabla es una estructura de datos que organiza los datos en columnas y filas; cada columna es un campo (o atributo) y cada fila, un registro. 
	La intersecci�n de una columna con una fila, contiene un dato espec�fico, un solo valor.
	
*/
Create Database test_db

use test_db

--La sintaxis b�sica de una tabla:

create table nombre_table(--nombre de la tabla que la identifique y con el cual accederemos a ella
	id int,
	nombre_campo varchar(50)
	);

/*Si intentamos crear una tabla con un nombre ya existente (existe otra tabla con ese nombre), mostrar� un mensaje indicando que ya hay un objeto llamado 'usuarios' en la base de datos y la sentencia no se ejecutar�.*/


drop table nombre_table --Para eliminar una tabla usamos "drop table"
--Si intentamos eliminar una tabla que no existe, aparece un mensaje de error indicando tal situaci�n y la sentencia no se ejecuta. Para evitar este mensaje podemos agregar a la instrucci�n lo siguiente:
if object_id('nombre_table') is not null
  drop table nombre_table;

--ejemplo 01
if object_id('nombre_table') is not null
  drop table nombre_table;

create table nombre_table(
	id int,
	nombre_campo varchar(50)
	);