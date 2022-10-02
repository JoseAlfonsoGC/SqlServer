/******************************************* Trabajar con varias tablas **************************************/
/*Es normal que se tenga que trabajar con mas de una sola tabla, aumentando las posibilidades de un diagrama de base de datos
****posibles mejoras*****
--validacion de datos
--consultas menos redundantes
--ahorro de almacenamiento **repetir informacion que ya es conocida para un grupo de datos a los que hace referencia 
*/
--en ateriores capitulos se trabajo con la tabla "libros" se podria separar en 2 tablas en (libros) y (editoriales) 
--ya que muchos libros pueden pertenecer a una sola editorial, la referencia la haremos en la tabla libros y 
--de esa forma no tener que agregar la editorial cada que se ingrese un libro y solo se llamaria al registros en la tabla editorial 
--Ejemplo

create table libros(
		codigo int identity,
		titulo varchar(40) not null,
		autor varchar(30) not null default 'Desconocido',
		codigoeditorial tinyint not null,
		precio decimal(5,2),
	primary key (codigo)
);

create table editoriales(
		codigo tinyint identity,
		nombre varchar(20) not null,
	primary key(codigo)
);
--Al obtener informacion se realiza con un join (combinacion)
--Ejemplo
select * from libros
		join editoriales
		on libros.codigoeditorial=editoriales.codigo; --A continuacion se explica 
/*******************************************Combinaci�n interna (inner join)********************************/
/*
--Un join es una operaci�n que relaciona dos o m�s tablas para obtener un resultado que incluya datos (campos y registros) de ambas; 
--las tablas participantes se combinan seg�n los campos comunes a ambas tablas.

--Hay tres tipos de combinaciones:

1-combinaciones internas (inner join o join),
2-combinaciones externas y
3-combinaciones cruzadas.
*/
--sintaxis
select CAMPOS
  from TABLA1
  join TABLA2
  on CONDICIONdeCOMBINACION;

--Ejemplo
select * from libros -- indicamos el nombre de la tabla luego del "from" ("libros");
  join editoriales -- especificamos los campos que aparecer�n en el resultado en la lista de selecci�n; --- combinamos esa tabla con "join" y el nombre de la otra tabla ("editoriales");
  on codigoeditorial=editoriales.codigo; -- se especifica qu� tablas se van a combinar y c�mo; -- claves primarias y externas.

--Si una de las tablas tiene clave primaria compuesta, al combinarla con la otra, en la cl�usula "on" se debe hacer referencia a la clave completa, es decir, la condici�n referenciar� a todos los campos clave que identifican al registro.

--Se puede incluir en la consulta join la cl�usula "where" para restringir los registros que retorna el resultado; tambi�n "order by", "distinct", etc..

--Se emplea este tipo de combinaci�n para encontrar registros de la primera tabla que se correspondan con los registros de la otra, es decir, que cumplan la condici�n del "on". Si un valor de la primera tabla no se encuentra en la segunda tabla, el registro no aparece.

--Para simplificar la sentencia podemos usar un alias para cada tabla:

 select l.codigo,titulo,autor,nombre
  from libros as l
  join editoriales as e
  on l.codigoeditorial=e.codigo;

/***********************************Combinaci�n externa izquierda (left join)*******************************/
--Vimos que una combinaci�n interna (join) encuentra registros de la primera tabla que se correspondan con los registros de la segunda, es decir, que cumplan la condici�n del "on" y si un valor de la primera tabla no se encuentra en la segunda tabla, el registro no aparece.

--Si queremos saber qu� registros de una tabla NO encuentran correspondencia en la otra, es decir, no existe valor coincidente en la segunda, necesitamos otro tipo de combinaci�n, "outer join" (combinaci�n externa).

--Las combinaciones externas combinan registros de dos tablas que cumplen la condici�n, m�s los registros de la segunda tabla que no la cumplen; es decir, muestran todos los registros de las tablas relacionadas, a�n cuando no haya valores coincidentes entre ellas.

--Este tipo de combinaci�n se emplea cuando se necesita una lista completa de los datos de una de las tablas y la informaci�n que cumple con la condici�n. Las combinaciones externas se realizan solamente entre 2 tablas.

--Hay tres tipos de combinaciones externas: "left outer join", "right outer join" y "full outer join"; se pueden abreviar con "left join", "right join" y "full join" respectivamente.

--Vamos a estudiar las primeras

--Se emplea una combinaci�n externa izquierda para mostrar todos los registros de la tabla de la izquierda. Si no encuentra coincidencia con la tabla de la derecha, el registro muestra los campos de la segunda tabla seteados a "null".

--En el siguiente ejemplo solicitamos el t�tulo y nombre de la editorial de los libros:
select titulo,nombre
		from editoriales as e
		left join libros as l
		on codigoeditorial = e.codigo; --El resultado mostrar� el t�tulo y nombre de la editorial; las editoriales de las cuales no hay libros, es decir, cuyo c�digo de editorial no est� presente en "libros" aparece en el resultado, pero con el valor "null" en el campo "titulo".

--Es importante la posici�n en que se colocan las tablas en un "left join", la tabla de la izquierda es la que se usa para localizar registros en la tabla de la derecha.

--Entonces, un "left join" se usa para hacer coincidir registros en una tabla (izquierda) con otra tabla (derecha); si un valor de la tabla de la izquierda no encuentra coincidencia en la tabla de la derecha, se genera una fila extra (una por cada valor no encontrado) con todos los campos correspondientes a la tabla derecha seteados a "null". La sintaxis b�sica es la siguiente:
select CAMPOS
		from TABLAIZQUIERDA
		left join TABLADERECHA
		on CONDICION;
/***********************************Combinaci�n externa derecha (right join)*******************************/
--Una combinaci�n externa derecha ("right outer join" o "right join") opera del mismo modo s�lo que la tabla derecha es la que localiza los registros en la tabla izquierda.

--En el siguiente ejemplo solicitamos el t�tulo y nombre de la editorial de los libros empleando un "right join":
select titulo,nombre
		from libros as l
		right join editoriales as e
		on codigoeditorial = e.codigo;
--El resultado mostrar� el t�tulo y nombre de la editorial; las editoriales de las cuales no hay libros, es decir, cuyo c�digo de editorial no est� presente en "libros" aparece en el resultado, pero con el valor "null" en el campo "titulo".

--Es FUNDAMENTAL tener en cuenta la posici�n en que se colocan las tablas en los "outer join". En un "left join" la primera tabla (izquierda) es la que busca coincidencias en la segunda tabla (derecha); en el "right join" la segunda tabla (derecha) es la que busca coincidencias en la primera tabla (izquierda).

--En la siguiente consulta empleamos un "left join" para conseguir el mismo resultado que el "right join" anterior":
select titulo,nombre
		from editoriales as e
		left join libros as l
		on codigoeditorial = e.codigo;
--Note que la tabla que busca coincidencias ("editoriales") est� en primer lugar porque es un "left join"; en el "right join" precedente, estaba en segundo lugar.

--Un "right join" hace coincidir registros en una tabla (derecha) con otra tabla (izquierda); si un valor de la tabla de la derecha no encuentra coincidencia en la tabla izquierda, se genera una fila extra (una por cada valor no encontrado) con todos los campos correspondientes a la tabla izquierda seteados a "null". La sintaxis b�sica es la siguiente:
select CAMPOS
		from TABLAIZQUIERDA
		right join TABLADERECHA
		on CONDICION;

--Un "right join" tambi�n puede tener cl�usula "where" que restringa el resultado de la consulta considerando solamente los registros que encuentran coincidencia en la tabla izquierda:
select titulo,nombre
		from libros as l
		right join editoriales as e
		on e.codigo=codigoeditorial
  where codigoeditorial is not null;
--Mostramos las editoriales que NO est�n presentes en "libros", es decir, que NO encuentran coincidencia en la tabla de la derecha empleando un "right join":

 select titulo,nombre
  from libros as l
  right join editoriales as e
  on e.codigo=codigoeditorial
  where codigoeditorial is null;
/***********************************Combinaci�n externa completa (full join)*******************************/
--Una combinaci�n externa completa ("full outer join" o "full join") retorna todos los registros de ambas tablas. Si un registro de una tabla izquierda no encuentra coincidencia en la tabla derecha, las columnas correspondientes a campos de la tabla derecha aparecen seteadas a "null", y si la tabla de la derecha no encuentra correspondencia en la tabla izquierda, los campos de esta �ltima aparecen conteniendo "null".
--Ejemplo:
select titulo,nombre
		from editoriales as e
		full join libros as l
		on codigoeditorial = e.codigo;
--La salida del "full join" precedente muestra todos los registros de ambas tablas, incluyendo los libros cuyo c�digo de editorial no existe en la tabla "editoriales" y las editoriales de las cuales no hay correspondencia en "libros".
/***********************************Combinaciones cruzadas (cross join)*******************************/
--1) combinaciones internas (join), 2) combinaciones externas (left, right y full join) y 3) combinaciones cruzadas.

--Las combinaciones cruzadas (cross join) muestran todas las combinaciones de todos los registros de las tablas combinadas. Para este tipo de join no se incluye una condici�n de enlace. Se genera el producto cartesiano en el que el n�mero de filas del resultado es igual al n�mero de registros de la primera tabla multiplicado por el n�mero de registros de la segunda tabla, es decir, si hay 5 registros en una tabla y 6 en la otra, retorna 30 filas.

--sintaxis b�sica
select CAMPOS
		from TABLA1
		cross join TABLA2;

--Veamos un ejemplo. Un peque�o restaurante almacena los nombres y precios de sus comidas en una tabla llamada "comidas" y en una tabla denominada "postres" los mismos datos de sus postres.

--Si necesitamos conocer todas las combinaciones posibles para un men�, cada comida con cada postre, empleamos un "cross join":

select c.nombre as 'plato principal', p.nombre as 'postre'
		from comidas as c
		cross join postres as p;
--La salida muestra cada plato combinado con cada uno de los postres.

--Como cualquier tipo de "join", puede emplearse una cl�usula "where" que condicione la salida.