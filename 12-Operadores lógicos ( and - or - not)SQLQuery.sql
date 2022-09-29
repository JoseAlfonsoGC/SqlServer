/*Operadores logicos (and - or - not)*/

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
