/************************************************Tablas temporales*******************************************
Las tablas temporales son visibles solamente en la sesi�n actual.

Las tablas temporales se eliminan autom�ticamente al acabar la sesi�n o la funci�n o procedimiento almacenado en el cual fueron definidas. Se pueden eliminar con "drop table".

Pueden ser locales (son visibles s�lo en la sesi�n actual) o globales (visibles por todas las sesiones).

Para crear tablas temporales locales se emplea la misma sintaxis que para crear cualquier tabla, excepto que se coloca un signo numeral (#) precediendo el nombre.

 create table #NOMBRE(
  CAMPO DEFINICION,
  ...
 );
Para referenciarla en otras consultas, se debe incluir el numeral(#), que es parte del nombre. Por ejemplo:

 insert into #libros default values;
 select *from #libros;
Una tabla temporal no puede tener una restricci�n "foreign key" ni ser indexada, tampoco puede ser referenciada por una vista.
*/
--Ejemplo crear tablas temporales globales se emplea la misma sintaxis que para crear cualquier tabla, excepto que se coloca un signo numeral doble (##) precediendo el nombre.
create table ##NOMBRE(
  CAMPO DEFINICION,
  ...
 );
--El (o los) numerales son parte del nombre. As� que puede crearse una tabla permanente llamada "libros", otra tabla temporal local llamada "#libros" y una tercera tabla temporal global denominada "##libros".

--No podemos consultar la tabla "sysobjects" para ver las tablas temporales, debemos tipear:
select *from tempdb..sysobjects;