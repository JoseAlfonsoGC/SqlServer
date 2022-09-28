
/*"insert into" - "select"

Un registro es una fila de la tabla que contiene datos ordenados por columnas. 

*/
--sintaxis basica

insert into NOMBRETABLA (NOMBRECAMPO1, NOMBRECAMPOn)--los nombres de ls columnas se pueden omitir
 values ('VALORCAMPO1', 'VALORCAMPOn');--los valores se pueden omitir si la tabla lo permite con "null" desde la creación de la tabla 
									--ejemplo
									-- nombreCamppo varchar(50)null


/*
Note que los datos ingresados, como corresponden a cadenas de caracteres se colocan entre comillas simples.

Para ver los registros de una tabla usamos "select":

*/

 select * from ¨NOMBRETABLA; --Con el asterisco indicamos que muestre todos los campos de la tabla
