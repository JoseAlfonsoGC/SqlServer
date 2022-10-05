/***************************************Lenguaje de control de flujo (case)********************************
La sentencia "case" compara 2 o más valores y devuelve un resultado.
La sintaxis es la siguiente:

 case VALORACOMPARAR
  when VALOR1 then RESULTADO1
  when VALOR2 then RESULTADO2
  ...
  else RESULTADO3
 end
Por cada valor hay un "when" y un "then"; si encuentra un valor coincidente en algún "when" ejecuta el "then" correspondiente a ese "when", 
si no encuentra ninguna coincidencia, se ejecuta el "else"; si no hay parte "else" retorna "null". Finalmente se coloca "end" para indicar que el "case" ha finalizado.
*/
--ejemplo
/*
Un profesor guarda las notas de sus alumnos de un curso en una tabla llamada "alumnos" que consta de los siguientes campos:
- nombre (30 caracteres),
- nota (valor entero entre 0 y 10, puede ser nulo).
¨*/

--Queremos mostrar los nombres, notas de los alumnos y en una columna extra llamada "resultado" empleamos un case que testee la nota y muestre un mensaje diferente si en dicho campo hay un valor

-- 0, 1, 2 ó 3: 'libre';
-- 4, 5 ó 6: 'regular';
-- 7, 8, 9 ó 10: 'promocionado';

--Esta es la sentencia:

 select nombre,nota, resultado=
 case nota
  when 0 then 'libre'
  when 1 then 'libre'
  when 2 then 'libre'
  when 3 then 'libre'
  when 4 then 'regular'
  when 5 then 'regular'
  when 6 then 'regular'
  when 7 then 'promocionado'
  when 8 then 'promocionado'
  when 9 then 'promocionado'
  when 10 then 'promocionado'
 end
from alumnos;

/*
Note que cada "when" compara un valor puntual, por ello los valores devueltos son iguales para algunos casos. 
Note que como omitimos la parte "else", en caso que el valor no encuentre coincidencia con ninguno valor "when", retorna "null".
*/

--Podemos realizar comparaciones en cada "when". La sintaxis es la siguiente:
case
  when VALORACOMPARAR OPERADOR VALOR1 then RESULTADO1
  when VALORACOMPARAR OPERADOR VALOR2 then RESULTADO2
  ...
  else RESULTADO3
 end
--Mostramos los nombres de los alumnos y en una columna extra llamada "resultado" empleamos un case que testee si la nota es menor a 4, está entre 4 y 7 o supera el 7:
select nombre, nota, condicion=
  case 
   when nota<4 then 'libre'
   when nota >=4 and nota<7 then 'regular'
   when nota>=7 then 'promocionado'
   else 'sin nota'
  end
 from alumnos;
--Puede utilizar una expresión "case" en cualquier lugar en el que pueda utilizar una expresión.
--También se puede emplear con "group by" y funciones de agrupamiento.
/*****************************************Lenguaje de control de flujo (if)*********************************
Existen palabras especiales que pertenecen al lenguaje de control de flujo que controlan la ejecución de las sentencias, 
los bloques de sentencias y procedimientos almacenados.

Tales palabras son: begin... end, goto, if... else, return, waitfor, while, break y continue.

- "begin... end" encierran un bloque de sentencias para que sean tratados como unidad.

- "if... else": testean una condición; se emplean cuando un bloque de sentencias debe ser ejecutado si una condición se cumple y si no se cumple, 
se debe ejecutar otro bloque de sentencias diferente.

- "while": ejecuta repetidamente una instrucción siempre que la condición sea verdadera.

- "break" y "continue": controlan la operación de las instrucciones incluidas en el bucle "while".
*/
--Ejemplo. Tenemos nuestra tabla "libros"; queremos mostrar todos los títulos de los cuales no hay libros disponibles (cantidad=0), 
--si no hay, mostrar un mensaje indicando tal situación:
if exists (select * from libros where cantidad=0)
		  (select titulo from libros where cantidad=0)--SQL Server ejecuta la sentencia (en este caso, una subconsulta) luego del "if" si la condición es verdadera; si es falsa, ejecuta la sentencia del "else" (si existe).
		   else
		   select 'No hay libros sin stock';

--Podemos emplear "if...else" en actualizaciones. Por ejemplo, queremos hacer un descuento en el precio, 
--del 10% a todos los libros de una determinada editorial; si no hay, mostrar un mensaje:

 if exists (select * from libros where editorial='Emece')--Note que si la condición es verdadera, se deben ejecutar 2 sentencias. Por lo tanto, se deben encerrar en un bloque "begin...end"
		    begin
		    update libros set precio=precio-(precio*0.1) where editorial='Emece'
			select 'libros actualizados'
			end
			else
			select 'no hay registros actualizados';

--En el siguiente ejemplo eliminamos los libros cuya cantidad es cero; si no hay, mostramos un mensaje:
if exists (select * from libros where cantidad=0)
		delete from libros where cantidad=0
		else
		select 'No hay registros eliminados';


/*
Dentro de los comandos SQL select, update y delete no podemos hacer uso de la sentencia de control de flujo if, 
debemos utilizar la sentencia case que vimos en el concepto anterior.

A partir de la versión 2012 de SQL Server disponemos de la función integrada iif:

select titulo,costo=iif(precio<38,'barato','caro') from libros;
*/

