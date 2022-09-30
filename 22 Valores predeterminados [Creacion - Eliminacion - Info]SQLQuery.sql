/*************************************Valores predeterminados (create default)******************************/
--Sintaxis b�sica:

 create default NOMBREVALORPREDETERMINADO
  as VALORPREDETERMINADO;
/*
"VALORPREDETERMINADO" no puede hacer referencia a campos de una tabla (u otros objetos) y debe ser compatible con el tipo de datos y longitud del campo al cual se asocia; si esto no sucede, SQL Server no lo informa al crear el valor predeterminado ni al asociarlo, pero al ejecutar una instrucci�n "insert" muestra un mensaje de error.
*/

--En el siguiente ejemplo creamos un valor predeterminado llamado "VP_datodesconocido' con el valor "Desconocido":
create default VP_datodesconocido
  as 'Desconocido'

--Luego de crear un valor predeterminado, debemos asociarlo a un campo (o a un tipo de datos definido por el usuario) ejecutando el procedimiento almacenado del sistema "sp_bindefault":
 exec sp_bindefault NOMBRE, 'NOMBRETABLA.CAMPO';

--La siguiente sentencia asocia el valor predeterminado creado anteriormente al campo "domicilio" de la tabla "empleados":
 exec sp_bindefault VP_datodesconocido, 'empleados.domicilio';

--Podemos asociar un valor predeterminado a varios campos. Asociamos el valor predeterminado "VP_datodesconocido" al campo "barrio" de la tabla "empleados":
 exec sp_bindefault VP_datodesconocido, 'empleados.barrio';

 /*
 La funci�n que cumple un valor predeterminado es b�sicamente la misma que una restricci�n "default", las siguientes caracter�sticas explican algunas semejanzas y diferencias entre ellas:

- un campo solamente puede tener definida UNA restricci�n "default", un campo solamente puede tener UN valor predeterminado asociado a �l,

- una restricci�n "default" se almacena con la tabla, cuando �sta se elimina, las restricciones tambi�n. Los valores predeterminados son objetos diferentes e independientes de las tablas, si eliminamos una tabla, las asociaciones desaparecen, pero los valores predeterminados siguen existiendo en la base de datos.

- una restricci�n "default" se establece para un solo campo; un valor predeterminado puede asociarse a distintos campos (inclusive, de diferentes tablas).

- una restricci�n "default" no puede establecerse sobre un campo "identity", tampoco un valor predeterminado.

No se puede asociar un valor predeterminado a un campo que tiene una restricci�n "default".
 */

 /*
Un campo con un valor predeterminado asociado puede tener reglas asociadas a �l y restricciones "check". Si hay conflicto entre ellas, SQL Server no lo informa al crearlas y/o asociarlas, pero al intentar ingresar un valor que alguna de ellas no permita, aparece un mensaje de error.

La sentencia "create default" no puede combinarse con otra sentencia en un mismo lote.

Si asocia a un campo que ya tiene asociado un valor predeterminado otro valor predeterminado, la nueva asociaci�n reemplaza a la anterior.
*/
--Veamos otros ejemplos.
--Creamos un valor predeterminado que inserta el valor "0" en un campo de tipo num�rico:
 create default VP_cero
  as 0;
--En el siguiente creamos un valor predeterminado que inserta ceros con el formato v�lido para un n�mero de tel�fono:
create default VP_telefono
 as '(0000)0-000000';
--Con "sp_helpconstraint" podemos ver los valores predeterminados asociados a los campos de una tabla.

--Con "sp_help" podemos ver todos los objetos de la base de datos activa, incluyendo los valores predeterminados, en tal caso en la columna "Object_type" aparece "default".
 
 /*****************************Desasociar y eliminar valores predeterminados*******************************/
--Un valor predeterminado no puede eliminarse si no se ha desasociado previamente.

--Para deshacer una asociaci�n empleamos el procedimiento almacenado "sp_unbindefault" seguido de la tabla y campo al que est� asociado:
exec sp_unbindefault 'TABLA.CAMPO';

--Quitamos la asociaci�n al campo "sueldo" de la tabla "empleados":
exec sp_unbindefault 'empleados.sueldo';

--Con la instrucci�n "drop default" podemos eliminar un valor predeterminado:
drop default NOMBREVALORPREDETERMINADO;

--Eliminamos el valor predeterminado llamado "VP_cero":
drop default VP_cero;

--Si eliminamos una tabla, las asociaciones de valores predeterminados de sus campos desaparecen, pero los valores predeterminados siguen existiendo.
/************************************Informaci�n de valores predeterminados*********************************/
/*
--Para obtener informaci�n de los valores predeterminados podemos emplear los mismos procedimientos almacenados que usamos para las reglas.

--Si empleamos "sp_help", vemos todos los objetos de la base de datos activa (incluyendo los valores predeterminados); en la columna "Object_type" (tipo de objeto) muestra "default".

--Si al procedimiento almacenado "sp_help" le agregamos el nombre de un valor predeterminado, nos muestra el nombre, propietario, tipo y fecha de creaci�n:
*/
 exec sp_help NOMBREVALORPREDETERMINADO;
--Con "sp_help", no sabemos si los valores predeterminados existentes est�n o no asociadas a alg�n campo.

--"sp_helpconstraint" retorna una lista de todas las restricciones que tiene una tabla. Tambi�n los valores predeterminados asociados; muestra la siguiente informaci�n:

constraint_type: --indica que es un valor predeterminado con "DEFAULT", nombrando el campo al que est� asociado.

constraint_name: --nombre del valor predeterminado.

constraint_keys: --muestra el texto del valor predeterminado.

--Con "sp_helptext" seguido del nombre de un valor predeterminado podemos ver el texto de cualquier valor predeterminado:
exec sp_helptext NOMBREVALORPREDETERMINADO;

--Tambi�n se puede consultar la tabla del sistema "sysobjects", que nos muestra el nombre y varios datos de todos los objetos de la base de datos actual. La columna "xtype" indica el tipo de objeto, en caso de ser un valor predeterminado aparece el valor "D":
select * from sysobjects;

--i queremos ver todos los valores predeterminados creados por nosotros, podemos tipear:

 select * from sysobjects
  where xtype='D' and-- tipo valor predeterminado
  name like 'VP%';--b�squeda con comod�n
