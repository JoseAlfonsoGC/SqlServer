/************************************************Tablas temporales*******************************************
Las tablas temporales son visibles solamente en la sesión actual.

Las tablas temporales se eliminan automáticamente al acabar la sesión o la función o procedimiento almacenado en el cual fueron definidas. Se pueden eliminar con "drop table".

Pueden ser locales (son visibles sólo en la sesión actual) o globales (visibles por todas las sesiones).

Para crear tablas temporales locales se emplea la misma sintaxis que para crear cualquier tabla, excepto que se coloca un signo numeral (#) precediendo el nombre.

 create table #NOMBRE(
  CAMPO DEFINICION,
  ...
 );
Para referenciarla en otras consultas, se debe incluir el numeral(#), que es parte del nombre. Por ejemplo:

 insert into #libros default values;
 select *from #libros;
Una tabla temporal no puede tener una restricción "foreign key" ni ser indexada, tampoco puede ser referenciada por una vista.
*/
--Ejemplo crear tablas temporales globales se emplea la misma sintaxis que para crear cualquier tabla, excepto que se coloca un signo numeral doble (##) precediendo el nombre.
create table ##NOMBRE(
  CAMPO DEFINICION,
  ...
 );
--El (o los) numerales son parte del nombre. Así que puede crearse una tabla permanente llamada "libros", otra tabla temporal local llamada "#libros" y una tercera tabla temporal global denominada "##libros".

--No podemos consultar la tabla "sysobjects" para ver las tablas temporales, debemos tipear:
select *from tempdb..sysobjects;