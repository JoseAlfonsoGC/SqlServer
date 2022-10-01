/*****************************************************Indice******************************************/
/*
Los índices se emplean para facilitar la obtención de información de una tabla. El indice de una tabla desempeña la misma función que el índice de un libro: 
permite encontrar datos rápidamente; en el caso de las tablas, localiza registros.

Una tabla se indexa por un campo (o varios).

Un índice posibilita el acceso directo y rápido haciendo más eficiente las búsquedas. Sin índice, SQL Server debe recorrer secuencialmente toda la tabla para encontrar un registro.

La desventaja es que consume espacio en el disco y genera costo de mantenimiento (tiempo y recursos).

Los índices más adecuados son aquellos creados con campos que contienen valores únicos.

SQL Server permite crear dos tipos de índices: 
1) agrupados  
2) no agrupados.
*/
/*****************************Indices agrupados y no agrupados (clustered y nonclustered)********************/
/*
1) Un INDICE AGRUPADO es similar a una guía telefónica, los registros con el mismo valor de campo se agrupan juntos. Un índice agrupado determina la secuencia de almacenamiento de los registros en una tabla.
Se utilizan para campos por los que se realizan busquedas con frecuencia o se accede siguiendo un orden.
Una tabla sólo puede tener UN índice agrupado.
El tamaño medio de un índice agrupado es aproximadamente el 5% del tamaño de la tabla.
*/
/*
2) Un INDICE NO AGRUPADO es como el índice de un libro, los datos se almacenan en un lugar diferente al del índice, los punteros indican el lugar de almacenamiento de los elementos indizados en la tabla.
Un índice no agrupado se emplea cuando se realizan distintos tipos de busquedas frecuentemente, con campos en los que los datos son únicos.
Una tabla puede tener hasta 249 índices no agrupados.

Si no se especifica un tipo de índice, de modo predeterminado será no agrupado.

Los campos de tipo text, ntext e image no se pueden indizar.
*/

--Es recomendable crear los índices agrupados antes que los no agrupados, porque los primeros modifican el orden físico de los registros, ordenándolos secuencialmente.

--La diferencia básica entre índices agrupados y no agrupados es que los registros de un índice agrupado están ordenados y almacenados de forma secuencial en función de su clave.

--SQL Server crea automaticamente índices cuando se crea una restricción "primary key" o "unique" en una tabla.
--Es posible crear índices en las vistas.

--Resumiendo, los índices facilitan la recuperación de datos, permitiendo el acceso directo y acelerando las búsquedas, consultas y otras operaciones que optimizan el rendimiento general.
/************************************************Create Index (Índice)************************************************/
--sintaxis basica
create TIPODEINDICE index NOMBREINDICE --"TIPODEINDICE" indica si es agrupado (clustered) o no agrupado (nonclustered). Si no especificamos crea uno No agrupado. Independientemente de si es agrupado o no, también se puede especificar que sea "unique", 
									   --es decir, no haya valores repetidos. Si se intenta crear un índice unique para un campo que tiene valores duplicados, SQL Server no lo permite.
		on TABLA(CAMPO);

--En el siguiente ejemplo se crea un índice agrupado único para el campo "codigo" de la tabla "libros":
create unique clustered index I_libros_codigo ----Para identificar los índices fácilmente, podemos agregar un prefijo al nombre del índice, por ejemplo "I" y luego el nombre de la tabla y/o campo.
		on libros(codigo);

--En el siguiente ejemplo se crea un índice no agrupado para el campo "titulo" de la tabla "libros":
create nonclustered index I_libros_titulo
		on libros(titulo);
--Un índice puede tener más de un campo como clave, son índices compuestos. Los campos de un índice compuesto tienen que ser de la misma tabla (excepto cuando se crea en una vista - tema que veremos posteriormente).

--Creamos un índice compuesto para el campo "autor" y "editorial":
create index I_libros_autoreditorial
		on libros(autor,editorial);

--SQL Server crea automáticamente índices cuando se establece una restricción "primary key" o "unique" en una tabla. Al crear una restricción "primary key", si no se especifica, el índice será agrupado (clustered) a menos que ya exista un índice agrupado para dicha tabla. Al crear una restricción "unique", si no se especifica, el índice será no agrupado (non-clustered).

--Ahora podemos entender el resultado del procedimiento almacenado "sp_helpconstraint" cuando en la columna "constraint_type" mostraba el tipo de índice seguido de las palabras "clustered" o "non_clustered".

--Puede especificarse que un índice sea agrupado o no agrupado al agregar estas restricciones.
--Agregamos una restricción "primary key" al campo "codigo" de la tabla "libros" especificando que cree un índice NO agrupado:
alter table libros
		add constraint PK_libros_codigo
		primary key nonclustered (codigo);

--Para ver los indices de una tabla:
exec sp_helpindex libros; --Muestra el nombre del índice, si es agrupado (o no), primary (o unique) y el campo por el cual se indexa.

--Todos los índices de la base de datos activa se almacenan en la tabla del sistema "sysindexes", podemos consultar dicha tabla tipeando:
select name from sysindexes;

--Para ver todos los índices de la base de datos activa creados por nosotros podemos tipear la siguiente consulta:
select name from sysindexes
  where name like 'I_%';
/*****************************************************Regenerar Índices**************************************/
--Empleando la opción "drop_existing" junto con "create index" permite regenerar un índice, con ello evitamos eliminarlo y volver a crearlo. La sintaxis es la siguiente
create TIPODEINDICE index NOMBREINDICE
		on TABLA(CAMPO)
		with drop_existing;

--También podemos modificar alguna de las características de un índice con esta opción, a saber:
/*
- tipo: cambiándolo de no agrupado a agrupado (siempre que no exista uno agrupado para la misma tabla). No se puede convertir un índice agrupado en No agrupado.

- campo: se puede cambiar el campo por el cual se indexa, agregar campos, eliminar algún campo de un índice compuesto.

- único: se puede modificar un índice para que los valores sean únicos o dejen de serlo.
*/

--En este ejemplo se crea un índice no agrupado para el campo "titulo" de la tabla "libros":
create nonclustered index I_libros
		on libros(titulo);

--Regeneramos el índice "I_libros" y lo convertimos a agrupado:
create clustered index I_libros
		on libros(titulo)
		with drop_existing;
--Agregamos un campo al índice "I_libros":
create clustered index I_libros
		on libros(titulo,editorial)
		with drop_existing;
--Esta opción no puede emplearse con índices creados a partir de una restricción "primary key" o "unique".

/*****************************************************Eliminar Índices***************************************/

--Los índices creados con "create index" se eliminan con "drop index"; la siguiente es la sintaxis básica:
drop index NOMBRETABLA.NOMBREINDICE; 

--Ejemplo plactico eliminamos el índice "I_libros_titulo":
drop index libros.I_libros_titulo;

--Los índices que SQL Server crea automáticamente al establecer una restricción "primary key" o "unique" no pueden eliminarse con "drop index", se eliminan automáticamente cuando quitamos la restricción.

--Podemos averiguar si existe un índice para eliminarlo, consultando la tabla del sistema "sysindexes":
if exists (select name from sysindexes
		where name = 'NOMBREINDICE')
		drop index NOMBRETABLA.NOMBREINDICE;

--Eliminamos el índice "I_libros_titulo" si existe:
if exists (select *from sysindexes
		where name = 'I_libros_titulo')
		drop index libros.I_libros_titulo;