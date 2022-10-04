/***************************Tipo de dato definido por el usuario (crear - informacion)***********************
Cuando definimos un campo de una tabla debemos especificar el tipo de datos, 
sabemos que los tipos de datos especifican el tipo de informaci�n (caracteres, n�meros, fechas) que pueden almacenarse en un campo. 
SQL Server proporciona distintos tipos de datos del sistema (char, varchar, int, decimal, datetime, etc.) y permite tipos de datos definidos por el usuario siempre que se basen en los tipos de datos existentes.

Se pueden crear y eliminar tipos de datos definidos por el usuario.
Se emplean cuando varias tablas deben almacenar el mismo tipo de datos en un campo y se quiere garantizar que todas tengan el mismo tipo y longitud.
*/

--Para crear un tipo de datos definido por el usuario se emplea el procedimiento almacenado del sistema "sp_addtype". Sintaxis b�sica:
exec sp_addtype NOMBRENUEVOTIPO, 'TIPODEDATODELSISTEMA', 'OPCIONNULL';

--Creamos un tipo de datos definido por el usuario llamado "tipo_documento" que admite valores nulos:
exec sp_addtype tipo_documento, 'char(8)', 'null';

/*
Ejecutando el procedimiento almacenado "sp_help" junto al nombre del tipo de dato definido por el usuario se obtiene informaci�n del mismo (nombre, el tipo de dato en que se basa, la longitud, si acepta valores nulos, si tiene valor por defecto y reglas asociadas).

Tambi�n podemos consultar la tabla "systypes" en la cual se almacena informaci�n de todos los tipos de datos:

 select name from systypes;
*/
/***********************Tipo de dato definido por el usuario (asociaci�n de reglas)**************************/
--Se puede asociar una regla a un tipo de datos definido por el usuario. Luego de crear la regla se establece la asociaci�n; la sintaxis es la siguiente
exec sp_bindrule NOMBREREGLA, 'TIPODEDATODEFINIDOPORELUSUARIO', 'futureonly';

/*
El par�metro "futureonly" es opcional, especifica que si existen campos (de cualquier tabla) con este tipo de dato, no se asocien a la regla; si creamos una nueva tabla con este tipo de dato, si deber�n cumplir la regla. Si no se especifica este par�metro, todos los campos de este tipo de dato, existentes o que se creen posteriormente (de cualquier tabla), quedan asociados a la regla.

Recuerde que SQL Server NO controla los datos existentes para confirmar que cumplen con la regla, si no los cumple, la regla se asocia igualmente; pero al ejecutar una instrucci�n "insert" o "update" muestra un mensaje de error.

Si asocia una regla a un tipo de dato definido por el usuario que tiene otra regla asociada, esta �ltima la reemplaza.
*/

--Para quitar la asociaci�n, empleamos el mismo procedimiento almacenado que aprendimos cuando quitamos asociaciones a campos, ejecutamos el procedimiento almacenado "sp_unbindrule" seguido del nombre del tipo de dato al que est� asociada la regla:
exec sp_unbindrule 'TIPODEDATODEFINIDOPORELUSUARIO';

/*
--Si asocia una regla a un campo cuyo tipo de dato definido por el usuario ya tiene una regla asociada, la nueva regla se aplica al campo, 
pero el tipo de dato contin�a asociado a la regla. La regla asociada al campo prevalece sobre la asociada al tipo de dato. Por ejemplo, 
tenemos un campo "precio" de un tipo de dato definido por el usuario "tipo_precio", este tipo de dato tiene asociada una regla "RG_precio0a99" 
(precio entre 0 y 99), luego asociamos al campo "precio" la regla "RG_precio100a500" (precio entre 100 y 500); al ejecutar una instrucci�n "insert" admitir� valores entre 100 y 500, es decir, 
tendr� en cuenta la regla asociada al campo, aunque vaya contra la regla asociada al tipo de dato.

--Un tipo de dato definido por el usuario puede tener una sola regla asociada.

--Cuando obtenemos informaci�n del tipo da dato definido por el usuario ejecutando "sp_help", en la columna "rule_name" se muestra el nombre de la regla asociada a dicho tipo de dato; muestran "none" cuando no tiene regla asociada.
*/

/***********************Tipo de dato definido por el usuario (valores predeterminados)**********************
Se puede asociar un valor predeterminado a un tipo de datos definido por el usuario. Luego de crear un valor predeterminado, 

sintaxis
exec sp_bindefault NOMBREVALORPREDETERMINADO, 'TIPODEDATODEFINIDOPORELUSUARIO','futureonly';
El par�metro "futureonly" es opcional, especifica que si existen campos (de cualquier tabla) con este tipo de dato, no se asocien al valor predeterminado; 
si creamos una nueva tabla con este tipo de dato, si estar� asociado al valor predeterminado. Si no se especifica este par�metro, todos los campos de este tipo de dato, 
existentes o que se creen posteriormente (de cualquier tabla), quedan asociados al valor predeterminado.
*/
--Si asocia un valor predeterminado a un tipo de dato definido por el usuario que tiene otro valor predeterminado asociado, el �ltimo lo reemplaza.

--Para quitar la asociaci�n, empleamos el mismo procedimiento almacenado que aprendimos cuando quitamos asociaciones a campos:
sp_unbindefault 'TIPODEDATODEFINIDOPORELUSUARIO';

/*
Debe tener en cuenta que NO se puede aplicar una restricci�n "default" en un campo con un tipo de datos definido por el usuario si dicho campo o tipo de dato tienen asociado un valor predeterminado.

Si un campo de un tipo de dato definido por el usuario tiene una restricci�n "default" y luego se asocia un valor predeterminado al tipo de dato, el valor predeterminado no queda asociado en el campo que tiene la restricci�n "default".

Un tipo de dato definido por el usuario puede tener un solo valor predeterminado asociado.

Cuando obtenemos informaci�n del tipo da dato definido por el usuario ejecutando "sp_help", en la columna "default_name" se muestra el nombre del valor predeterminado asociado a dicho tipo de dato; muestra "none" cuando no tiene ning�n valor predeterminado asociado.
*/

/******************************Tipo de dato definido por el usuario (eliminar)******************************/
--Podemos eliminar un tipo de dato definido por el usuario con el procedimiento almacenado "sp_droptype":
exec sp_droptype TIPODEDATODEFINIDOPORELUSUARIO;

--Eliminamos el tipo de datos definido por el usuario llamado "tipo_documento":
exec sp_droptype tipo_documento;

--Los tipos de datos definidos por el usuario se almacenan en la tabla del sistema "systypes".
--Podemos averiguar si un tipo de dato definido por el usuario existe para luego eliminarlo:
if exists (select *from systypes
		where name = 'NOMBRETIPODEDATODEFINIDOPORELUSUARIO')
		exec sp_droptype TIPODEDATODEFINIDOPORELUSUARIO;

--Consultamos la tabla "systypes" para ver si existe el tipo de dato "tipo_documento", si es as�, lo eliminamos:
if exists (select *from systypes
		where name = 'tipo_documento')
		exec sp_droptype tipo_documento;

--No se puede eliminar un tipo de datos definido por el usuario si alguna tabla (u otro objeto) hace uso de �l; por ejemplo, si una tabla tiene un campo definido con tal tipo de dato.

--Si eliminamos un tipo de datos definido por el usuario, desaparecen las asociaciones de las reglas y valores predeterminados, pero tales reglas y valores predeterminados, no se eliminan, siguen existiendo en la base de datos.