/*
 para borrar todos los registro de una tabla se usa "delete" sin condici�n "where".
Tambi�n podemos eliminar todos los registros de una tabla con "truncate table".
Por ejemplo, queremos vaciar la tabla "libros", usamos:
*/
truncate table nombre_tabla;--vac�a la tabla (elimina todos los registros) y conserva la estructura de la tabla.
							--La diferencia con "drop table" es que esta sentencia borra la tabla, "truncate table" la vac�a

/*
La diferencia con "delete" es la velocidad, es m�s r�pido "truncate table" que "delete" 
(se nota cuando la cantidad de registros es muy grande) ya que �ste borra los registros uno a uno.
*/

/*
Otra diferencia es la siguiente: cuando la tabla tiene un campo "identity", 
si borramos todos los registros con "delete" y luego ingresamos un registro, 
al cargarse el valor en el campo de identidad, contin�a con la secuencia teniendo en cuenta el valor mayor que se hab�a guardado; 
si usamos "truncate table" para borrar todos los registros, al ingresar otra vez un registro, la secuencia del campo de identidad vuelve a iniciarse en 1.
*/