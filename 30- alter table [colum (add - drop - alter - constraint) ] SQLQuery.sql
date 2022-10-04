/*****************************Agregar y eliminar campos ( alter table - add - drop)**************************/
--"alter table" permite modificar la estructura de una tabla.
--Podemos utilizarla para agregar, modificar y eliminar campos de una tabla.

--sintaxis
alter table NOMBRETABLA
		add NOMBRENUEVOCAMPO DEFINICION;

--En el siguiente ejemplo agregamos el campo "cantidad" a la tabla "libros", de tipo tinyint, que acepta valores nulos:
alter table libros
		add cantidad tinyint;

--SQL Server no permite agregar campos "not null" a menos que se especifique un valor por defecto:
alter table libros
		add autor varchar(20) not null default 'Desconocido';

--Al agregar un campo puede especificarse que sea "identity" (siempre que no exista otro campo identity).

--Para eliminar campos de una tabla
alter table NOMBRETABLA
		drop column NOMBRECAMPO;

--No pueden eliminarse los campos que son usados por un índice o tengan restricciones. No puede eliminarse un campo si es el único en la tabla.

--Podemos eliminar varios campos en una sola sentencia:
alter table libros
		drop column editorial,edicion;

/*************************************Alterar campos (alter table - alter)**********************************/
alter --ademas de modificar una tabla, puede ser usado para alterar un campo existente
--sintaxis
alter table NOMBRETABLA
		alter column CAMPO NUEVADEFINICION;

--ejemplo practico
--Modificamos el campo "titulo" extendiendo su longitud y para que NO admita valores nulos:
alter table libros
		alter column titulo varchar(40) not null;

--En el siguiente ejemplo alteramos el campo "precio" de la tabla "libros" que fue definido "decimal(6,2) not null" para que acepte valores nulos:
alter table libros
		alter column precio decimal(6,2) null;

/*SQL Server tiene algunas excepciones al momento de modificar los campos. No permite modificar:

- campos de tipo text, image, ntext y timestamp.

- un campo que es usado en un campo calculado.

- campos que son parte de índices o tienen restricciones, a menos que el cambio no afecte al índice o a la restricción, por ejemplo, se puede ampliar la longitud de un campo de tipo caracter.

- agregando o quitando el atributo "identity".

- campos que afecten a los datos existentes cuando una tabla contiene registros (ejemplo: un campo contiene valores nulos y se pretende redefinirlo como "not null"; un campo int guarda un valor 300 y se pretende modificarlo a tinyint, etc.).
*/
/************************************Agregar campos y restricciones (alter table)****************************/
--Podemos agregar un campo a una tabla y en el mismo momento aplicarle una restricción.

--sintaxis
alter table TABLA
		add CAMPO DEFINICION
		constraint NOMBRERESTRICCION TIPO;

--Agregamos a la tabla "libros", el campo "titulo" de tipo varchar(30) y una restricción "unique" con índice agrupado:
alter table libros
		add titulo varchar(30) 
		constraint UQ_libros_autor unique clustered;

--Agregamos a la tabla "libros", el campo "codigo" de tipo int identity not null y una restricción "primary key" con índice no agrupado:

 alter table libros
		add codigo int identity not null
		constraint PK_libros_codigo primary key nonclustered;

--Agregamos a la tabla "libros", el campo "precio" de tipo decimal(6,2) y una restricción "check":
alter table libros
		add precio decimal(6,2)
		constraint CK_libros_precio check (precio>=0);
