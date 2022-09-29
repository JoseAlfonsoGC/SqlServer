/*Seleccionar grupos (having)
As� como la cl�usula "where" permite seleccionar (o rechazar) registros individuales; la cl�usula "having" permite seleccionar (o rechazar) un grupo de registros.
*/

/*
Si queremos saber la cantidad de libros agrupados por editorial usamos la siguiente instrucci�n ya aprendida:

 select editorial, count(*)
  from libros
  group by editorial;
*/
/*
i queremos saber la cantidad de libros agrupados por editorial pero considerando s�lo algunos grupos, por ejemplo, los que devuelvan un valor mayor a 2, usamos la siguiente instrucci�n:

 select editorial, count(*) from libros
  group by editorial
  having count(*)>2; --Se utiliza "having", seguido de la condici�n de b�squeda, para seleccionar ciertas filas retornadas por la cl�usula "group by".
*/
--Veamos otros ejemplos. Queremos el promedio de los precios de los libros agrupados por editorial, pero solamente de aquellos grupos cuyo promedio supere los 25 pesos:
 select editorial, avg(precio) from libros
  group by editorial
  having avg(precio)>25;
--En algunos casos es posible confundir las cl�usulas "where" y "having". Queremos contar los registros agrupados por editorial sin tener en cuenta a la editorial "Planeta".
--Analicemos las siguientes sentencias:

 select editorial, count(*) from libros
  where editorial<>'Planeta'
  group by editorial;

 select editorial, count(*) from libros
  group by editorial
  having editorial<>'Planeta';
--Ambas devuelven el mismo resultado, pero son diferentes. La primera, selecciona todos los registros rechazando los de editorial "Planeta" y luego los agrupa para contarlos. 
--La segunda, selecciona todos los registros, los agrupa para contarlos y finalmente rechaza fila con la cuenta correspondiente a la editorial "Planeta"


--No debemos confundir la cl�usula "where" con la cl�usula "having"; la primera establece condiciones para la selecci�n de registros de un "select"; la segunda establece condiciones para la selecci�n de registros de una salida "group by".

--Veamos otros ejemplos combinando "where" y "having". Queremos la cantidad de libros, sin considerar los que tienen precio nulo, agrupados por editorial, sin considerar la editorial "Planeta":

 select editorial, count(*) from libros
  where precio is not null
  group by editorial
  having editorial<>'Planeta';
--Aqu�, selecciona los registros rechazando los que no cumplan con la condici�n dada en "where", luego los agrupa por "editorial" y finalmente rechaza los grupos que no cumplan con la condici�n dada en el "having".

--Se emplea la cl�usula "having" con funciones de agrupamiento, esto no puede hacerlo la cl�usula "where". Por ejemplo queremos el promedio de los precios agrupados por editorial, de aquellas editoriales que tienen m�s de 2 libros:

 select editorial, avg(precio) from libros
  group by editorial
  having count(*) > 2; 
--En una cl�usula "having" puede haber hasta 128 condiciones. Cuando utilice varias condiciones, tiene que combinarlas con operadores l�gicos (and, or, not)