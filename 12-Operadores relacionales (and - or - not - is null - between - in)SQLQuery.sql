/*Operadores relacionales (and - or - not - is null - between - in)*/

/*
Hasta el momento, hemos aprendido a establecer una condici�n con "where" utilizando operadores relacionales. 
Podemos establecer m�s de una condici�n con la cl�usula "where" ejemplo.

- and, significa "y",
- or, significa "y/o",
- not, significa "no", invierte el resultado
- (), par�ntesis

si se requiere de una consulta mas especifica podemos hacer uso de los operadores logicos

Si queremos recuperar todos los libros cuyo autor sea igual a "Borges" y cuyo precio no supere los 20 pesos, necesitamos 2 condiciones:
*/
--Ejemplo and
 select * from libros
		where (autor='Borges') and
		(precio<=20); --Los registros recuperados en una sentencia que une 2 condiciones con el operador "and", cumplen con las 2 condiciones

--Si se requiere ver los libros cuyo autor sea "Borges" y/o cuya editorial sea "Planeta":
--Ejemplo or
 select * from libros
  where autor='Borges' or
  editorial='Planeta'; --Los registros recuperados cumplen con las dos condiciones o solo una.

--Queremos recuperar los libros que NO cumplan la condici�n dada, por ejemplo, aquellos cuya editorial NO sea "Planeta":
--Ejemplo not (negaci�n)
 select * from libros
  where not editorial='Planeta'; --El operador "not" invierte el resultado de la condici�n a la cual antecede

 /*
 Los par�ntesis se usan para encerrar condiciones, para que se eval�en como una sola expresi�n.
Cuando explicitamos varias condiciones con diferentes operadores l�gicos (combinamos "and", "or") permite establecer el orden de prioridad de la evaluaci�n; adem�s permite diferenciar las expresiones m�s claramente.

Por ejemplo, las siguientes expresiones devuelven un resultado diferente: 
 */

 select* from libros
  where (autor='Borges') or
  (editorial='Paidos' and precio<20);

 select * from libros
  where (autor='Borges' or editorial='Paidos') and
  (precio<20);

/***************is null**********************
Se emplea el operador "is null" para recuperar los registros en los cuales est� almacenado el valor "null" en un campo espec�fico
*/
--Ejemplo
select * from libros
  where editorial is null;--Para obtener los registros que no contiene "null", se puede emplear "is not null", esto mostrar� los registros con valores conocidos

/*
Siempre que sea posible, emplee condiciones de b�squeda positivas ("is null"), evite las negativas ("is not null") porque con ellas se eval�an todos los registros y esto hace m�s lenta la recuperaci�n de los datos.
*/

/************"between (entre)"**********************
trabajan con intervalos de valores.
Hasta ahora, para recuperar de la tabla "libros" los libros con precio mayor o igual a 20 y menor o igual a 40, usamos 2 condiciones unidas por el operador l�gico "and"
select * from libros
  where precio>=20 and
  precio<=40; --Averiguamos si el valor de un campo dado (precio) est� entre los valores m�nimo y m�ximo especificados (20 y 40 respectivamente).
*/

-- Recuperamos los registros cuyo precio est� entre 20 y 40 empleando "between":
select * from libros
  where precio between 20 and 40;

-- Para seleccionar los libros cuyo precio NO est� entre un intervalo de valores
-- antecedemos "not" al "between":
select * from libros
  where precio not between 20 and 35;
/**************** in ************************
Se utiliza "in" para averiguar si el valor de un campo est� incluido en una lista de valores especificada.

En la siguiente sentencia usamos "in" para averiguar si el valor del campo autor est� incluido en la lista de valores especificada (en este caso, 2 cadenas)

Hasta ahora para recuperar los libros cuyo autor sea 'Paenza' o 'Borges' us�bamos 2 condiciones:
select *from libros
  where autor='Borges' or autor='Paenza';
*/
select * from libros
		where autor in('Borges','Paenza'); --Podemos usar "in" y simplificar la consulta
--Para recuperar los libros cuyo autor no sea 'Paenza' ni 'Borges' us�bamos:
select * from libros
		where autor<>'Borges' and
		autor<>'Paenza';
--Tambi�n podemos usar "in" anteponiendo "not":
select * from libros
		where autor not in ('Borges','Paenza');

--Recuerde: siempre que sea posible, emplee condiciones de b�squeda positivas ("in"), 
--evite las negativas ("not in") porque con ellas se eval�n todos los registros y esto hace m�s lenta la recuperaci�n de los datos.