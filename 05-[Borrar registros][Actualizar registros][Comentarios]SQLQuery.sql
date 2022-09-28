--delete elimina los registyros de la tabla 

delete from nombre_tabla;--Muestra un mensaje indicando la cantidad de registros que ha eliminado

/*
Si no queremos eliminar todos los registros, sino solamente algunos, debemos indicar cuál o cuáles, 
para ello utilizamos el comando "delete" junto con la clausula "where" con la cual establecemos la condición que deben cumplir los registros a borrar.

*/

--Por ejemplo, queremos eliminar aquel registro cuyo nombre de usuario es "Marcelo":

delete from usuarios
 where nombre='Marcelo'; --Tenga en cuenta que si no colocamos una condición, se eliminan todos los registros de la tabla nombrada.


--update es usado para modificar uno o varios datos de uno o varios registros 

--Por ejemplo, en nuestra tabla "usuarios", queremos cambiar los valores de todas las claves, por "RealMadrid"

update usuarios set clave='RealMadrid';--Utilizamos "update" junto al nombre de la tabla y "set" junto con el campo a modificar y su nuevo valor, El cambio afectará a todos los registros.

--se puede limitar con "Where"
/*
queremos cambiar el valor correspondiente a la clave de nuestro usuario llamado "Federicolopez", queremos como nueva clave "Boca", 
necesitamos una condición "where" que afecte solamente a este registro:
*/
update usuarios set clave='Boca'
  where nombre='Federicolopez';

-- se puede actualizar varios campos ejemplo
update usuarios set nombre='Marceloduarte', clave='Marce'
  where nombre='Marcelo';