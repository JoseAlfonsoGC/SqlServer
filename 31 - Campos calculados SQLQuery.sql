/***************************************************Campos calculados****************************************
Un campo calculado es un campo que no se almacena físicamente en la tabla. 
SQL Server emplea una fórmula que detalla el usuario al definir dicho campo para calcular el valor según otros campos de la misma tabla.

Un campo calculado no puede:

- definirse como "not null".

- ser una subconsulta.

- tener restricción "default" o "foreign key".

- insertarse ni actualizarse.

Puede ser empleado como llave de un índice o parte de restricciones "primary key" o "unique" si la expresión que la define no cambia en cada consulta.
*/

--Crea un campo calculado denominado "sueldototal" que suma al sueldo básico de cada empleado la cantidad abonada por los hijos (100 por cada hijo):
create table empleados(
  documento char(8),
  nombre varchar(10),
  domicilio varchar(30),
  sueldobasico decimal(6,2),
  cantidadhijos tinyint default 0,
  sueldototal as sueldobasico + (cantidadhijos*100)
 );

--También se puede agregar un campo calculado a una tabla existente:
alter table NOMBRETABLA
		add NOMBRECAMPOCALCULADO as EXPRESION;

--ejemplo
alter table empleados
  add sueldototal as sueldo+(cantidadhijos*100);

--Los campos de los cuales depende el campo calculado no pueden eliminarse, se debe eliminar primero el campo calculado.