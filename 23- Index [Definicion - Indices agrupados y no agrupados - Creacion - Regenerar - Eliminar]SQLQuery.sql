/*****************************************************Indice******************************************/
/*
Los �ndices se emplean para facilitar la obtenci�n de informaci�n de una tabla. El indice de una tabla desempe�a la misma funci�n que el �ndice de un libro: 
permite encontrar datos r�pidamente; en el caso de las tablas, localiza registros.

Una tabla se indexa por un campo (o varios).

Un �ndice posibilita el acceso directo y r�pido haciendo m�s eficiente las b�squedas. Sin �ndice, SQL Server debe recorrer secuencialmente toda la tabla para encontrar un registro.

La desventaja es que consume espacio en el disco y genera costo de mantenimiento (tiempo y recursos).

Los �ndices m�s adecuados son aquellos creados con campos que contienen valores �nicos.

SQL Server permite crear dos tipos de �ndices: 
1) agrupados  
2) no agrupados.
*/
/*****************************Indices agrupados y no agrupados (clustered y nonclustered)********************/
/*
1) Un INDICE AGRUPADO es similar a una gu�a telef�nica, los registros con el mismo valor de campo se agrupan juntos. Un �ndice agrupado determina la secuencia de almacenamiento de los registros en una tabla.
Se utilizan para campos por los que se realizan busquedas con frecuencia o se accede siguiendo un orden.
Una tabla s�lo puede tener UN �ndice agrupado.
El tama�o medio de un �ndice agrupado es aproximadamente el 5% del tama�o de la tabla.
*/
/*
2) Un INDICE NO AGRUPADO es como el �ndice de un libro, los datos se almacenan en un lugar diferente al del �ndice, los punteros indican el lugar de almacenamiento de los elementos indizados en la tabla.
Un �ndice no agrupado se emplea cuando se realizan distintos tipos de busquedas frecuentemente, con campos en los que los datos son �nicos.
Una tabla puede tener hasta 249 �ndices no agrupados.

Si no se especifica un tipo de �ndice, de modo predeterminado ser� no agrupado.

Los campos de tipo text, ntext e image no se pueden indizar.
*/

--Es recomendable crear los �ndices agrupados antes que los no agrupados, porque los primeros modifican el orden f�sico de los registros, orden�ndolos secuencialmente.

--La diferencia b�sica entre �ndices agrupados y no agrupados es que los registros de un �ndice agrupado est�n ordenados y almacenados de forma secuencial en funci�n de su clave.

--SQL Server crea automaticamente �ndices cuando se crea una restricci�n "primary key" o "unique" en una tabla.
--Es posible crear �ndices en las vistas.

--Resumiendo, los �ndices facilitan la recuperaci�n de datos, permitiendo el acceso directo y acelerando las b�squedas, consultas y otras operaciones que optimizan el rendimiento general.
/************************************************Create Index (�ndice)************************************************/
--sintaxis basica
create TIPODEINDICE index NOMBREINDICE --"TIPODEINDICE" indica si es agrupado (clustered) o no agrupado (nonclustered). Si no especificamos crea uno No agrupado. Independientemente de si es agrupado o no, tambi�n se puede especificar que sea "unique", 
									   --es decir, no haya valores repetidos. Si se intenta crear un �ndice unique para un campo que tiene valores duplicados, SQL Server no lo permite.
		on TABLA(CAMPO);

--En el siguiente ejemplo se crea un �ndice agrupado �nico para el campo "codigo" de la tabla "libros":
create unique clustered index I_libros_codigo ----Para identificar los �ndices f�cilmente, podemos agregar un prefijo al nombre del �ndice, por ejemplo "I" y luego el nombre de la tabla y/o campo.
		on libros(codigo);

--En el siguiente ejemplo se crea un �ndice no agrupado para el campo "titulo" de la tabla "libros":
create nonclustered index I_libros_titulo
		on libros(titulo);
--Un �ndice puede tener m�s de un campo como clave, son �ndices compuestos. Los campos de un �ndice compuesto tienen que ser de la misma tabla (excepto cuando se crea en una vista - tema que veremos posteriormente).

--Creamos un �ndice compuesto para el campo "autor" y "editorial":
create index I_libros_autoreditorial
		on libros(autor,editorial);

--SQL Server crea autom�ticamente �ndices cuando se establece una restricci�n "primary key" o "unique" en una tabla. Al crear una restricci�n "primary key", si no se especifica, el �ndice ser� agrupado (clustered) a menos que ya exista un �ndice agrupado para dicha tabla. Al crear una restricci�n "unique", si no se especifica, el �ndice ser� no agrupado (non-clustered).

--Ahora podemos entender el resultado del procedimiento almacenado "sp_helpconstraint" cuando en la columna "constraint_type" mostraba el tipo de �ndice seguido de las palabras "clustered" o "non_clustered".

--Puede especificarse que un �ndice sea agrupado o no agrupado al agregar estas restricciones.
--Agregamos una restricci�n "primary key" al campo "codigo" de la tabla "libros" especificando que cree un �ndice NO agrupado:
alter table libros
		add constraint PK_libros_codigo
		primary key nonclustered (codigo);

--Para ver los indices de una tabla:
exec sp_helpindex libros; --Muestra el nombre del �ndice, si es agrupado (o no), primary (o unique) y el campo por el cual se indexa.

--Todos los �ndices de la base de datos activa se almacenan en la tabla del sistema "sysindexes", podemos consultar dicha tabla tipeando:
select name from sysindexes;

--Para ver todos los �ndices de la base de datos activa creados por nosotros podemos tipear la siguiente consulta:
select name from sysindexes
  where name like 'I_%';
/*****************************************************Regenerar �ndices**************************************/
--Empleando la opci�n "drop_existing" junto con "create index" permite regenerar un �ndice, con ello evitamos eliminarlo y volver a crearlo. La sintaxis es la siguiente
create TIPODEINDICE index NOMBREINDICE
		on TABLA(CAMPO)
		with drop_existing;

--Tambi�n podemos modificar alguna de las caracter�sticas de un �ndice con esta opci�n, a saber:
/*
- tipo: cambi�ndolo de no agrupado a agrupado (siempre que no exista uno agrupado para la misma tabla). No se puede convertir un �ndice agrupado en No agrupado.

- campo: se puede cambiar el campo por el cual se indexa, agregar campos, eliminar alg�n campo de un �ndice compuesto.

- �nico: se puede modificar un �ndice para que los valores sean �nicos o dejen de serlo.
*/

--En este ejemplo se crea un �ndice no agrupado para el campo "titulo" de la tabla "libros":
create nonclustered index I_libros
		on libros(titulo);

--Regeneramos el �ndice "I_libros" y lo convertimos a agrupado:
create clustered index I_libros
		on libros(titulo)
		with drop_existing;
--Agregamos un campo al �ndice "I_libros":
create clustered index I_libros
		on libros(titulo,editorial)
		with drop_existing;
--Esta opci�n no puede emplearse con �ndices creados a partir de una restricci�n "primary key" o "unique".

/*****************************************************Eliminar �ndices***************************************/

--Los �ndices creados con "create index" se eliminan con "drop index"; la siguiente es la sintaxis b�sica:
drop index NOMBRETABLA.NOMBREINDICE; 

--Ejemplo plactico eliminamos el �ndice "I_libros_titulo":
drop index libros.I_libros_titulo;

--Los �ndices que SQL Server crea autom�ticamente al establecer una restricci�n "primary key" o "unique" no pueden eliminarse con "drop index", se eliminan autom�ticamente cuando quitamos la restricci�n.

--Podemos averiguar si existe un �ndice para eliminarlo, consultando la tabla del sistema "sysindexes":
if exists (select name from sysindexes
		where name = 'NOMBREINDICE')
		drop index NOMBRETABLA.NOMBREINDICE;

--Eliminamos el �ndice "I_libros_titulo" si existe:
if exists (select *from sysindexes
		where name = 'I_libros_titulo')
		drop index libros.I_libros_titulo;