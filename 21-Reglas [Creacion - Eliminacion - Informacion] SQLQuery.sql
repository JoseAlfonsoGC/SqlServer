/*en SQL Server existen varias alternativas para asegurar la integridad de los datos
RESTRICCIONES (constraints), que se establecen en tablas y campos y son controlados autom�ticamente por SQL Server. Hay 3 tipos:

I) DE LOS CAMPOS (hace referencia a los valores v�lidos para un campo determinado). Pueden ser:
a) DEFAULT: especifica un valor por defecto para un campo cuando no se inserta expl�citamente en un comando "insert".

b) CHECK: especifica un rango de valores que acepta un campo, se emplea en inserciones y actualizaciones ("insert" y "update").

II) DE LA TABLA (asegura un identificador �nico para cada registro de una tabla). Hay 2 tipos:
a) PRIMARY KEY: identifica un�vocamente cada uno de los registros; asegura que no haya valores duplicados ni valores nulos. Se crea un �ndice autom�ticamente.

b) UNIQUE: impide la duplicaci�n de claves alternas (no primarias). Se permiten valores nulos. Se crea un �ndice autom�ticamente.

III) REFERENCIAL: lo veremos m�s adelante.

2.REGLAS (rules) y
3.VALORES PREDETERMINADOS (defaults).
*/
/************************************reglas***************************
Las reglas especifican los valores que se pueden ingresar en un campo, asegurando que los datos se encuentren en un intervalo de valores espec�fico, coincidan con una lista de valores o sigan un patr�n.

Una regla se asocia a un campo de una tabla (o a un tipo de dato definido por el usuario
Un campo puede tener solamente UNA regla asociado a �l
*/
--sintaxis
create rule NOMBREREGLA
 as @VARIABLE CONDICION--Entonces, luego de "create rule" se coloca el nombre de la regla, luego la palabra clave "as" seguido de una variable (a la cual la precede el signo arroba) y finalmente la condici�n.

--ejemplo practico
--Creamos una regla para restringir los valores que se pueden ingresar en un campo "sueldo" de una tabla llamada "empleados", estableciendo un intervalo de valores:
create rule RG_sueldo_intervalo
		as @sueldo between 100 and 1000

--Luego de crear la regla, debemos asociarla a un campo ejecutando un procedimiento almacenado del sistema empleando la siguiente sintaxis b�sica:
exec sp_bindrule NOMBREREGLA, 'TABLA.CAMPO'; --Asociamos la regla creada anteriormente al campo "sueldo" de la tabla "empleados":

exec sp_bindrule RG_sueldo_intervalo, 'empleados.sueldo';

/*
Si intentamos agregar (o actualizar) un registro con valor para el campo "sueldo" que no est� en el intervalo de valores especificado en la regla, aparece un mensaje de error indicando que hay conflicto con la regla y la inserci�n (o actualizaci�n) no se realiza.

SQL Server NO controla los datos existentes para confirmar que cumplen con la regla como lo hace al aplicar restricciones; si no los cumple, la regla se asocia igualmente; pero al ejecutar una instrucci�n "insert" o "update" muestra un mensaje de error, es decir, act�a en inserciones y actualizaciones.

La regla debe ser compatible con el tipo de datos del campo al cual se asocia; si esto no sucede, SQL Server no lo informa al crear la regla ni al asociarla, pero al ejecutar una instrucci�n "insert" o "update" muestra un mensaje de error.

No se puede crear una regla para campos de tipo text, image, o timestamp.

Si asocia una nueva regla a un campo que ya tiene asociada otra regla, la nueva regla reeemplaza la asociaci�n anterior; pero la primera regla no desaparece, solamente se deshace la asociaci�n.

La sentencia "create rule" no puede combinarse con otras sentencias en un lote.

La funci�n que cumple una regla es b�sicamente la misma que una restricci�n "check", las siguientes caracter�sticas explican algunas diferencias entre ellas:

- podemos definir varias restricciones "check" sobre un campo, un campo solamente puede tener una regla asociada a �l;

- una restricci�n "check" se almacena con la tabla, cuando �sta se elimina, las restricciones tambi�n se borran. Las reglas son objetos diferentes e independientes de las tablas, si eliminamos una tabla, las asociaciones desaparecen, pero las reglas siguen existiendo en la base de datos;

- una restricci�n "check" puede incluir varios campos; una regla puede asociarse a distintos campos (incluso de distintas tablas);

- una restricci�n "check" puede hacer referencia a otros campos de la misma tabla, una regla no.

Un campo puede tener reglas asociadas a �l y restricciones "check". Si hay conflicto entre ellas, SQL Server no lo informa al crearlas y/o asociarlas, pero al intentar ingresar un valor que alguna de ellas no permita, aparece un mensaje de error.

Con "sp_helpconstraint" podemos ver las reglas asociadas a los campos de una tabla.

Con "sp_help" podemos ver todos los objetos de la base de datos activa, incluyendo las reglas, en tal caso en la columna "Object_type" aparece "rule".
*/

/********************Eliminar y dasasociar reglas (sp_unbindrule - drop rule)***********************
Para eliminar una regla, primero se debe deshacer la asociaci�n, ejecutando el procedimiento almacenado del sistema "sp_unbindrule":

 exec sp_unbindrule 'TABLA.CAMPO';
No es posible eliminar una regla si est� asociada a un campo. Si intentamos hacerlo, aparece un mensaje de error y la eliminaci�n no se realiza.

Con la instrucci�n "drop rule" eliminamos la regla:
*/
 drop rule NOMBREREGLA;
--Quitamos la asociaci�n de la regla "RG_sueldo_intervalo" con el campo "sueldo" de la tabla "empleados" tipeando:

 exec sp_unbindrule 'empleados.sueldo';
--Luego de quitar la asociaci�n la eliminamos:

 drop rule RG_sueldo_100a1000;
--Si eliminamos una tabla, las asociaciones de reglas de sus campos desaparecen, pero las reglas siguen existiendo.

/***************************Informaci�n de reglas (sp_help - sp_helpconstraint)**********************/

--Podemos utilizar el procedimiento almacenado "sp_help" con el nombre del objeto del cual queremos informaci�n, en este caso el nombre de una regla:

 exec sp_help NOMBREREGLA;
--muestra nombre, propietario, tipo y fecha de creaci�n.

--Con "sp_help", no sabemos si las reglas existentes est�n o no asociadas a alg�n campo.

--"sp_helpconstraint" retorna una lista de todas las restricciones que tiene una tabla. Podemos ver las reglas asociadas a una tabla con este procedimiento almacenado:

 exec sp_helpconstraint NOMBRETABLA;
--muestra la siguiente informaci�n:

-- constraint_type: indica que es una regla con "RULE", nombrando el campo al que est� asociada.

-- constraint_name: nombre de la regla.

-- constraint_keys: muestra el texto de la regla.

--Para ver el texto de una regla empleamos el procedimiento almacenado "sp_helptext" seguido del nombre de la regla:

 exec sp_helptext NOMBREREGLA;
--Tambi�n se puede consultar la tabla del sistema "sysobjects", que nos muestra el nombre y varios datos de todos los objetos de la base de datos actual. La columna "xtype" indica el tipo de objeto, en caso de ser una regla aparece el valor "R":

 select * from sysobjects;
--Si queremos ver todas las reglas creadas por nosotros, podemos tipear:

 select * from sysobjects
  where xtype='R' and-- tipo regla
  name like 'RG%';--b�squeda con comod�n