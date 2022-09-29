/*Operadores relacionales (and - or - not - is null - between - in)*/

/*
Hasta el momento, hemos aprendido a establecer una condición con "where" utilizando operadores relacionales. 
Podemos establecer más de una condición con la cláusula "where" ejemplo.

- and, significa "y",
- or, significa "y/o",
- not, significa "no", invierte el resultado
- (), paréntesis

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

--Queremos recuperar los libros que NO cumplan la condición dada, por ejemplo, aquellos cuya editorial NO sea "Planeta":
--Ejemplo not (negación)
 select * from libros
  where not editorial='Planeta'; --El operador "not" invierte el resultado de la condición a la cual antecede

 /*
 Los paréntesis se usan para encerrar condiciones, para que se evalúen como una sola expresión.
Cuando explicitamos varias condiciones con diferentes operadores lógicos (combinamos "and", "or") permite establecer el orden de prioridad de la evaluación; además permite diferenciar las expresiones más claramente.

Por ejemplo, las siguientes expresiones devuelven un resultado diferente: 
 */

 select* from libros
  where (autor='Borges') or
  (editorial='Paidos' and precio<20);

 select * from libros
  where (autor='Borges' or editorial='Paidos') and
  (precio<20);

/***************is null**********************
Se emplea el operador "is null" para recuperar los registros en los cuales esté almacenado el valor "null" en un campo específico
*/
--Ejemplo
select * from libros
  where editorial is null;--Para obtener los registros que no contiene "null", se puede emplear "is not null", esto mostrará los registros con valores conocidos

/*
Siempre que sea posible, emplee condiciones de búsqueda positivas ("is null"), evite las negativas ("is not null") porque con ellas se evalúan todos los registros y esto hace más lenta la recuperación de los datos.
*/

/************"between (entre)"**********************
trabajan con intervalos de valores.
Hasta ahora, para recuperar de la tabla "libros" los libros con precio mayor o igual a 20 y menor o igual a 40, usamos 2 condiciones unidas por el operador lógico "and"
select * from libros
  where precio>=20 and
  precio<=40; --Averiguamos si el valor de un campo dado (precio) está entre los valores mínimo y máximo especificados (20 y 40 respectivamente).
*/

-- Recuperamos los registros cuyo precio esté entre 20 y 40 empleando "between":
select * from libros
  where precio between 20 and 40;

-- Para seleccionar los libros cuyo precio NO esté entre un intervalo de valores
-- antecedemos "not" al "between":
select * from libros
  where precio not between 20 and 35;
/**************** in ************************
Se utiliza "in" para averiguar si el valor de un campo está incluido en una lista de valores especificada.

En la siguiente sentencia usamos "in" para averiguar si el valor del campo autor está incluido en la lista de valores especificada (en este caso, 2 cadenas)

Hasta ahora para recuperar los libros cuyo autor sea 'Paenza' o 'Borges' usábamos 2 condiciones:
select *from libros
  where autor='Borges' or autor='Paenza';
*/
select * from libros
		where autor in('Borges','Paenza'); --Podemos usar "in" y simplificar la consulta
--Para recuperar los libros cuyo autor no sea 'Paenza' ni 'Borges' usábamos:
select * from libros
		where autor<>'Borges' and
		autor<>'Paenza';
--También podemos usar "in" anteponiendo "not":
select * from libros
		where autor not in ('Borges','Paenza');

--Recuerde: siempre que sea posible, emplee condiciones de búsqueda positivas ("in"), 
--evite las negativas ("not in") porque con ellas se evalún todos los registros y esto hace más lenta la recuperación de los datos.