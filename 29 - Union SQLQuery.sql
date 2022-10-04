/*****************************************************Union**************************************************/
/*El operador "union" combina el resultado de dos o m�s instrucciones "select" en un �nico resultado.
Se usa cuando los datos que se quieren obtener pertenecen a distintas tablas y no se puede acceder a ellos con una sola consulta.

Es necesario que las tablas referenciadas tengan tipos de datos similares, la misma cantidad de campos y el mismo orden de campos en la lista de selecci�n de cada consulta. 
No se incluyen las filas duplicadas en el resultado, a menos que coloque la opci�n "all".
*/

/*
Se deben especificar los nombres de los campos en la primera instrucci�n "select".

Puede emplear la cl�usula "order by".

Puede dividir una consulta compleja en varias consultas "select" y luego emplear el operador "union" para combinarlas.

Una academia de ense�anza almacena los datos de los alumnos en una tabla llamada "alumnos" y los datos de los profesores en otra denominada "profesores".
La academia necesita el nombre y domicilio de profesores y alumnos para enviarles una tarjeta de invitaci�n.

Para obtener los datos necesarios de ambas tablas en una sola consulta necesitamos realizar una uni�n:
*/
select nombre, domicilio from alumnos
  union
   select nombre, domicilio from profesores; --El primer "select" devuelve el nombre y domicilio de todos los alumnos; el segundo, el nombre y domicilio de todos los profesores.

--Los encabezados del resultado de una uni�n son los que se especifican en el primer "select".