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
/*******************************************Combinación interna (inner join)********************************/
/*
--Un join es una operación que relaciona dos o más tablas para obtener un resultado que incluya datos (campos y registros) de ambas; 
--las tablas participantes se combinan según los campos comunes a ambas tablas.

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
  join editoriales -- especificamos los campos que aparecerán en el resultado en la lista de selección; --- combinamos esa tabla con "join" y el nombre de la otra tabla ("editoriales");
  on codigoeditorial=editoriales.codigo; -- se especifica qué tablas se van a combinar y cómo; -- claves primarias y externas.

--Si una de las tablas tiene clave primaria compuesta, al combinarla con la otra, en la cláusula "on" se debe hacer referencia a la clave completa, es decir, la condición referenciará a todos los campos clave que identifican al registro.

--Se puede incluir en la consulta join la cláusula "where" para restringir los registros que retorna el resultado; también "order by", "distinct", etc..

--Se emplea este tipo de combinación para encontrar registros de la primera tabla que se correspondan con los registros de la otra, es decir, que cumplan la condición del "on". Si un valor de la primera tabla no se encuentra en la segunda tabla, el registro no aparece.

--Para simplificar la sentencia podemos usar un alias para cada tabla:

 select l.codigo,titulo,autor,nombre
  from libros as l
  join editoriales as e
  on l.codigoeditorial=e.codigo;

/***********************************Combinación externa izquierda (left join)*******************************/
--Vimos que una combinación interna (join) encuentra registros de la primera tabla que se correspondan con los registros de la segunda, es decir, que cumplan la condición del "on" y si un valor de la primera tabla no se encuentra en la segunda tabla, el registro no aparece.

--Si queremos saber qué registros de una tabla NO encuentran correspondencia en la otra, es decir, no existe valor coincidente en la segunda, necesitamos otro tipo de combinación, "outer join" (combinación externa).

--Las combinaciones externas combinan registros de dos tablas que cumplen la condición, más los registros de la segunda tabla que no la cumplen; es decir, muestran todos los registros de las tablas relacionadas, aún cuando no haya valores coincidentes entre ellas.

--Este tipo de combinación se emplea cuando se necesita una lista completa de los datos de una de las tablas y la información que cumple con la condición. Las combinaciones externas se realizan solamente entre 2 tablas.

--Hay tres tipos de combinaciones externas: "left outer join", "right outer join" y "full outer join"; se pueden abreviar con "left join", "right join" y "full join" respectivamente.

--Vamos a estudiar las primeras

--Se emplea una combinación externa izquierda para mostrar todos los registros de la tabla de la izquierda. Si no encuentra coincidencia con la tabla de la derecha, el registro muestra los campos de la segunda tabla seteados a "null".

--En el siguiente ejemplo solicitamos el título y nombre de la editorial de los libros:
select titulo,nombre
		from editoriales as e
		left join libros as l
		on codigoeditorial = e.codigo; --El resultado mostrará el título y nombre de la editorial; las editoriales de las cuales no hay libros, es decir, cuyo código de editorial no está presente en "libros" aparece en el resultado, pero con el valor "null" en el campo "titulo".

--Es importante la posición en que se colocan las tablas en un "left join", la tabla de la izquierda es la que se usa para localizar registros en la tabla de la derecha.

--Entonces, un "left join" se usa para hacer coincidir registros en una tabla (izquierda) con otra tabla (derecha); si un valor de la tabla de la izquierda no encuentra coincidencia en la tabla de la derecha, se genera una fila extra (una por cada valor no encontrado) con todos los campos correspondientes a la tabla derecha seteados a "null". La sintaxis básica es la siguiente:
select CAMPOS
		from TABLAIZQUIERDA
		left join TABLADERECHA
		on CONDICION;
/***********************************Combinación externa derecha (right join)*******************************/
--Una combinación externa derecha ("right outer join" o "right join") opera del mismo modo sólo que la tabla derecha es la que localiza los registros en la tabla izquierda.

--En el siguiente ejemplo solicitamos el título y nombre de la editorial de los libros empleando un "right join":
select titulo,nombre
		from libros as l
		right join editoriales as e
		on codigoeditorial = e.codigo;
--El resultado mostrará el título y nombre de la editorial; las editoriales de las cuales no hay libros, es decir, cuyo código de editorial no está presente en "libros" aparece en el resultado, pero con el valor "null" en el campo "titulo".

--Es FUNDAMENTAL tener en cuenta la posición en que se colocan las tablas en los "outer join". En un "left join" la primera tabla (izquierda) es la que busca coincidencias en la segunda tabla (derecha); en el "right join" la segunda tabla (derecha) es la que busca coincidencias en la primera tabla (izquierda).

--En la siguiente consulta empleamos un "left join" para conseguir el mismo resultado que el "right join" anterior":
select titulo,nombre
		from editoriales as e
		left join libros as l
		on codigoeditorial = e.codigo;
--Note que la tabla que busca coincidencias ("editoriales") está en primer lugar porque es un "left join"; en el "right join" precedente, estaba en segundo lugar.

--Un "right join" hace coincidir registros en una tabla (derecha) con otra tabla (izquierda); si un valor de la tabla de la derecha no encuentra coincidencia en la tabla izquierda, se genera una fila extra (una por cada valor no encontrado) con todos los campos correspondientes a la tabla izquierda seteados a "null". La sintaxis básica es la siguiente:
select CAMPOS
		from TABLAIZQUIERDA
		right join TABLADERECHA
		on CONDICION;

--Un "right join" también puede tener cláusula "where" que restringa el resultado de la consulta considerando solamente los registros que encuentran coincidencia en la tabla izquierda:
select titulo,nombre
		from libros as l
		right join editoriales as e
		on e.codigo=codigoeditorial
  where codigoeditorial is not null;
--Mostramos las editoriales que NO están presentes en "libros", es decir, que NO encuentran coincidencia en la tabla de la derecha empleando un "right join":

 select titulo,nombre
  from libros as l
  right join editoriales as e
  on e.codigo=codigoeditorial
  where codigoeditorial is null;
/***********************************Combinación externa completa (full join)*******************************/
--Una combinación externa completa ("full outer join" o "full join") retorna todos los registros de ambas tablas. Si un registro de una tabla izquierda no encuentra coincidencia en la tabla derecha, las columnas correspondientes a campos de la tabla derecha aparecen seteadas a "null", y si la tabla de la derecha no encuentra correspondencia en la tabla izquierda, los campos de esta última aparecen conteniendo "null".
--Ejemplo:
select titulo,nombre
		from editoriales as e
		full join libros as l
		on codigoeditorial = e.codigo;
--La salida del "full join" precedente muestra todos los registros de ambas tablas, incluyendo los libros cuyo código de editorial no existe en la tabla "editoriales" y las editoriales de las cuales no hay correspondencia en "libros".
/***********************************Combinaciones cruzadas (cross join)*******************************/
--1) combinaciones internas (join), 2) combinaciones externas (left, right y full join) y 3) combinaciones cruzadas.

--Las combinaciones cruzadas (cross join) muestran todas las combinaciones de todos los registros de las tablas combinadas. Para este tipo de join no se incluye una condición de enlace. Se genera el producto cartesiano en el que el número de filas del resultado es igual al número de registros de la primera tabla multiplicado por el número de registros de la segunda tabla, es decir, si hay 5 registros en una tabla y 6 en la otra, retorna 30 filas.

--sintaxis básica
select CAMPOS
		from TABLA1
		cross join TABLA2;

--Veamos un ejemplo. Un pequeño restaurante almacena los nombres y precios de sus comidas en una tabla llamada "comidas" y en una tabla denominada "postres" los mismos datos de sus postres.

--Si necesitamos conocer todas las combinaciones posibles para un menú, cada comida con cada postre, empleamos un "cross join":

select c.nombre as 'plato principal', p.nombre as 'postre'
		from comidas as c
		cross join postres as p;
--La salida muestra cada plato combinado con cada uno de los postres.

--Como cualquier tipo de "join", puede emplearse una cláusula "where" que condicione la salida.

/*****************************************Autocombinacion**************************************************
--es posible combinar una tabla consigo misma.
*/
--Ejemplo
/*
Un pequeño restaurante tiene almacenadas sus comidas en una tabla llamada "comidas" que consta de los siguientes campos:

- nombre varchar(20),
- precio decimal (4,2) y
- rubro char(6)-- que indica con 'plato' si es un plato principal y 'postre' si es postre.

Podemos obtener la combinación de platos empleando un "cross join" con una sola tabla:
*/
--Ejemplo practico
select c1.nombre as 'plato principal',
		c2.nombre as postre,
		c1.precio+c2.precio as total
		from comidas as c1
		cross join comidas as c2; -- En la consulta anterior aparecen filas duplicadas, para evitarlo debemos emplear un "where":

select c1.nombre as 'plato principal',
  c2.nombre as postre,
  c1.precio+c2.precio as total
  from comidas as c1
  cross join comidas as c2
  where c1.rubro='plato' and --En la consulta anterior se empleó un "where" que especifica que se combine "plato" con "postre"
  c2.rubro='postre';

--En una autocombinación se combina una tabla con una copia de si misma. Para ello debemos utilizar 2 alias para la tabla. Para evitar que aparezcan filas duplicadas, debemos emplear un "where".

--También se puede realizar una autocombinación con "join":

 select c1.nombre as 'plato principal',
  c2.nombre as postre,
  c1.precio+c2.precio as total
  from comidas as c1
  join comidas as c2
  on c1.codigo<>c2.codigo
  where c1.rubro='plato' and
  c2.rubro='postre';

--Para que no aparezcan filas duplicadas se agrega un "where".